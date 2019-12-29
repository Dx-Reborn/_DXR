/*

*/

class Human extends DeusExPlayer
    abstract;

var bool bAnimTransition;
var bool bIsTurning;

event AnimEnd(int channel)
{
   if ((Controller != none) && (Controller.GetStateName() == 'PlayerWalking'))
       AnimatePlayerWalking(); else
   if ((Controller != none) && (Controller.GetStateName() == 'PlayerSwimming'))
       AnimatePlayerSwimming(); else
   if ((Controller != none) && (Controller.GetStateName() == 'Conversation'))
       AnimatePlayerWalking();
}

// Called from PlayerControllerExt
function H_ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)
{
    local vector OldAccel;
        
        OldAccel = Acceleration;
        Acceleration = NewAccel;
        bIsTurning = (Abs(DeltaRot.Yaw/DeltaTime) > 5000);

        if ((Physics == PHYS_Walking) && (!AnimIsInGroup(0, 'Dodge')))
        {
            if (!bIsCrouching)
            {
                if (controller.bDuck != 0)
                {
                    bIsCrouching = true;
                    PlayDuck();
                }
            }
            else if (controller.bDuck == 0)
            {
                OldAccel = vect(0,0,0);
                bIsCrouching = false;
                TweenToRunning(0.1);
            }

            if (!bIsCrouching)
            {
                if ((!bAnimTransition || (GetAnimFrame() > 0)) && (!AnimIsInGroup(0, 'Landing')))
                {
                    if (Acceleration != vect(0,0,0) )
                    {
                        if ((AnimIsInGroup(0, 'Waiting')) || (AnimIsInGroup(0, 'Gesture')) || (AnimIsInGroup(0, 'TakeHit')))
                        {
                            bAnimTransition = true;
                            TweenToRunning(0.1);
                        }
                    }
                    else if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000) && (!AnimIsInGroup(0,  'Gesture')))
                    {
                        if (AnimIsInGroup(0, 'Waiting'))
                        {
                            if (bIsTurning && (GetAnimFrame() >= 0)) 
                            {
                                bAnimTransition = true;
                                PlayTurning();
                            }
                        }
                        else if (!bIsTurning)
                        {
                            bAnimTransition = true;
                            TweenToWaiting(0.2);
                        }
                    }
                }
            }
            else
            {
                if ( (OldAccel == vect(0,0,0)) && (Acceleration != vect(0,0,0)) )
                    PlayCrawling();
                else if (!bIsTurning && (Acceleration == vect(0,0,0)) && (GetAnimFrame() > 0.1))
                    PlayDuck();
            }
        }
}

function AnimatePlayerSwimming()
{
        local vector X,Y,Z;

        GetAxes(GetViewRotation(), X,Y,Z);

        if ((Acceleration Dot X) <= 0)
        {
            if (AnimIsInGroup(0, 'TakeHit'))
            {
                bAnimTransition = true;
                TweenToWaiting(0.2);
            } 
            else
                PlayWaiting();
        }   
        else
        {
            if (AnimIsInGroup(0, 'TakeHit'))
            {
                bAnimTransition = true;
                TweenToSwimming(0.2);
            } 
            else
                PlaySwimming();
        }
}

function AnimatePlayerWalking()
{
        bAnimTransition = false;

        if (Physics == PHYS_Walking)
        {
            if (bIsCrouching)
            {
                if ( !bIsTurning && ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000) )
                    PlayDuck(); 
                else
                    PlayCrawling();
            }
            else
            {
                if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000)
                {
                    if (AnimIsInGroup(0, 'Waiting'))
                        PlayWaiting();
                    else
                    {
                        bAnimTransition = true;
                        TweenToWaiting(0.2);
                    }
                }   
                else if (bIsWalking)
                {
                    if ((AnimIsInGroup(0,'Waiting')) || (AnimIsInGroup(0, 'Landing')) || (AnimIsInGroup(0, 'Gesture')) || (AnimIsInGroup(0,  'TakeHit')))
                    {
                        TweenToWalking(0.1);
                        bAnimTransition = true;
                    }
                    else 
                        PlayWalking();
                }
                else
                {
                    if ((AnimIsInGroup(0, 'Waiting')) || (AnimIsInGroup(0,'Landing')) || (AnimIsInGroup(0,'Gesture')) || (AnimIsInGroup(0,'TakeHit')))
                    {
                        bAnimTransition = true;
                        TweenToRunning(0.1);
                    }
                    else
                        PlayRunning();
                }
            }
        }
        else
            PlayInAir();
}


function PlayDyingSound()
{
    if (PhysicsVolume.bWaterVolume)
        PlaySound(sound'MaleWaterDeath', SLOT_Pain,,,, RandomPitch());
    else
        PlaySound(die, SLOT_Pain,,,, RandomPitch());
}

event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    local Vector X, Y, Z;
    local float dotp;

//  ClientMessage("PlayDying()");
    GetAxes(GetViewRotation(), X, Y, Z);
    dotp = (Location - HitLoc) dot X;

    if (PhysicsVolume.bWaterVolume)
    {
        PlayAnim('WaterDeath',,0.1);
    }
    else
    {
        // die from the correct side
        if (dotp < 0.0)     // shot from the front, fall back
            PlayAnim('DeathBack',,0.1);
        else                // shot from the back, fall front
            PlayAnim('DeathFront',,0.1);
    }
    PlayDyingSound();
}

function bool IsFiring()
{
    if ((Weapon != None) && ( Weapon.IsInState('NormalFire') || Weapon.IsInState('ClientFiring') ) ) 
        return True;
    else
        return False;
}

function bool HasTwoHandedWeapon()
{
    if ((Weapon != None) && (Weapon.Mass >= 30))
        return True;
    else
        return False;
}

//
// animation functions
//
function PlayTurning()
{
//  ClientMessage("PlayTurning()");
    if (bForceDuck || bCrouchOn || IsLeaning())
        TweenAnim('CrouchWalk', 0.1);
    else
    {
        if (HasTwoHandedWeapon())
            TweenAnim('Walk2H', 0.1);
        else
            TweenAnim('Walk', 0.1);
    }
}

function TweenToWalking(float tweentime)
{
//  ClientMessage("TweenToWalking()");
    if (bForceDuck || bCrouchOn)
        TweenAnim('CrouchWalk', tweentime);
    else
    {
        if (HasTwoHandedWeapon())
            TweenAnim('Walk2H', tweentime);
        else
            TweenAnim('Walk', tweentime);
    }
}

function PlayWalking()
{
    local float newhumanAnimRate;

    newhumanAnimRate = humanAnimRate;

    // UnPhysic.cpp walk speed changed by proportion 0.7/0.3 (2.33), but that looks too goofy (fast as hell), so we'll try something a little slower
    if ( Level.NetMode != NM_Standalone ) 
        newhumanAnimRate = humanAnimRate * 1.75;

    //  ClientMessage("PlayWalking()");
    if (bForceDuck || bCrouchOn)
        LoopAnim('CrouchWalk', newhumanAnimRate);
    else
    {
        if (HasTwoHandedWeapon())
            LoopAnim('Walk2H', newhumanAnimRate);
        else
            LoopAnim('Walk', newhumanAnimRate);
    }
}

function TweenToRunning(float tweentime)
{
//  ClientMessage("TweenToRunning()");
    if (bIsWalking)
    {
        TweenToWalking(0.1);
        return;
    }

    if (IsFiring())
    {
        if (PlayerController(Controller).aStrafe != 0)
        {
            if (HasTwoHandedWeapon())
                PlayAnim('Strafe2H',humanAnimRate, tweentime);
            else
                PlayAnim('Strafe',humanAnimRate, tweentime);
        }
        else
        {
            if (HasTwoHandedWeapon())
                PlayAnim('RunShoot2H',humanAnimRate, tweentime);
            else
                PlayAnim('RunShoot',humanAnimRate, tweentime);
        }
    }
    else if (bOnFire)
        PlayAnim('Panic',humanAnimRate, tweentime);
    else
    {
        if (HasTwoHandedWeapon())
            PlayAnim('RunShoot2H',humanAnimRate, tweentime);
        else
            PlayAnim('Run',humanAnimRate, tweentime);
    }
}

function PlayRunning()
{
//  ClientMessage("PlayRunning()");
    if (IsFiring())
    {
        if (playerController(controller).aStrafe != 0)
        {
            if (HasTwoHandedWeapon())
                LoopAnim('Strafe2H', humanAnimRate);
            else
                LoopAnim('Strafe', humanAnimRate);
        }
        else
        {
            if (HasTwoHandedWeapon())
                LoopAnim('RunShoot2H', humanAnimRate);
            else
                LoopAnim('RunShoot', humanAnimRate);
        }
    }
    else if (bOnFire)
        LoopAnim('Panic', humanAnimRate);
    else
    {
        if (HasTwoHandedWeapon())
            LoopAnim('RunShoot2H', humanAnimRate);
        else
            LoopAnim('Run', humanAnimRate);
    }
}

function TweenToWaiting(float tweentime)
{
//  ClientMessage("TweenToWaiting()");
    if (controller.IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
    {
        if (IsFiring())
            LoopAnim('TreadShoot');
        else
            LoopAnim('Tread');
    }
    else if (IsLeaning() || bForceDuck)
        TweenAnim('CrouchWalk', tweentime);
    else if (((GetAnimSequence() == 'Pickup') && /*bAnimFinished*/!IsAnimating()) || ((GetAnimSequence() != 'Pickup') && !IsFiring()))
    {
        if (HasTwoHandedWeapon())
            TweenAnim('BreatheLight2H', tweentime);
        else
            TweenAnim('BreatheLight', tweentime);
    }
}

function PlayWaiting()
{
//  ClientMessage("PlayWaiting()");
    if (controller.IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
    {
        if (IsFiring())
            LoopAnim('TreadShoot');
        else
            LoopAnim('Tread');
    }
    else if (IsLeaning() || bForceDuck)
        TweenAnim('CrouchWalk', 0.1);
    else if (!IsFiring())
    {
        if (HasTwoHandedWeapon())
            LoopAnim('BreatheLight2H');
        else
            LoopAnim('BreatheLight');
    }

}

function PlaySwimming()
{
    LoopAnim('Tread');
}

function TweenToSwimming(float tweentime)
{
    TweenAnim('Tread', tweentime);
}

function PlayInAir()
{
    if (!bIsCrouching && (GetAnimSequence() != 'Jump'))
        PlayAnim('Jump',3.0,0.1);
}

function PlayLanded(float impactVel)
{
    PlayFootStep(1);
    if (!bIsCrouching)
        PlayAnim('Land',3.0,0.1);
}

function PlayDuck()
{
    if ((GetAnimSequence() != 'Crouch') && (GetAnimSequence() != 'CrouchWalk'))
    {
        if (IsFiring())
            PlayAnim('CrouchShoot',,0.1);
        else
            PlayAnim('Crouch',,0.1);
    }
    else
        TweenAnim('CrouchWalk', 0.1);
}

function PlayRising()
{
    PlayAnim('Stand',,0.1);
}

function PlayCrawling()
{
    if (IsFiring())
        LoopAnim('CrouchShoot');
    else
        LoopAnim('CrouchWalk');
}

function PlayFiring(optional float Rate, optional name FiringMode)
{
    local DeusExWeaponInv W;

    W = DeusExWeaponInv(Weapon);

    if (W != None)
    {
        if (Controller.IsInState('PlayerSwimming') || (Physics == PHYS_Swimming))
            LoopAnim('TreadShoot',,0.1);
        else if (W.bHandToHand)
        {
            if (/*bAnimFinished*/ !IsAnimating() || (GetAnimSequence() != 'Attack'))
                PlayAnim('Attack',,0.1);
        }
        else if (bIsCrouching || IsLeaning())
            LoopAnim('CrouchShoot',,0.1);
        else
        {
            if (HasTwoHandedWeapon())
                LoopAnim('Shoot2H',,0.1);
            else
                LoopAnim('Shoot',,0.1);
        }
    }
}

function PlayWeaponSwitch(Weapon newWeapon)
{
    if (!bIsCrouching && !bForceDuck && !bCrouchOn && !IsLeaning())
        PlayAnim('Reload');
}

function float RandomPitch()
{
    return (1.1 - 0.2*FRand());
}

function Gasp()
{
    PlaySound(sound'MaleGasp', SLOT_Pain,,,, RandomPitch());
}

function PlayTakeHitSound(int Damage, class<damageType> damageType, int Mult)
{
    local float rnd;

    if ( Level.TimeSeconds - LastPainSound < FRand() + 0.5)
        return;

    LastPainSound = Level.TimeSeconds;

    if (PhysicsVolume.bWaterVolume)
    {
        if (damageType == class'DM_Drowned')
        {
            if (FRand() < 0.8)
                PlaySound(sound'MaleDrown', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
        }
        else
            PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
    }
    else
    {
        // Body hit sound for multiplayer only
        if (((damageType == class'DM_Shot') || (damageType == class'DM_AutoShot'))  && (Level.NetMode != NM_Standalone))
        {
            PlaySound(sound'BodyHit', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
        }

        if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas'))
            PlaySound(sound'MaleEyePain', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
        else if (damageType == class'DM_PoisonGas')
            PlaySound(sound'MaleCough', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
        else
        {
            rnd = FRand();
            if (rnd < 0.33)
                PlaySound(sound'MalePainSmall', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
            else if (rnd < 0.66)
                PlaySound(sound'MalePainMedium', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
            else
                PlaySound(sound'MalePainLarge', SLOT_Pain, FMax(Mult * TransientSoundVolume, Mult * 2.0),,, RandomPitch());
        }
        class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, FMax(Mult * TransientSoundVolume, Mult * 2.0));
    }
}

function p_HandleWalking()
{
    local rotator carried;

    if (CarriedDecoration != None)
    {
        if ((Role == ROLE_Authority) && (standingcount() == 0))
            PutCarriedDecorationInHand();//CyberP: Really nice hack fix to a weird vanilla bug.

        if (CarriedDecoration != None) //verify its still in front
        {
//            PlayerController(Controller).bIsWalking = true;
            if (Role == ROLE_Authority)
            {
                carried = Rotator(CarriedDecoration.Location - Location);
                carried.Yaw = ((carried.Yaw & 65535) - (Rotation.Yaw & 65535)) & 65535;
                //if ( (carried.Yaw > 3072) && (carried.Yaw < 62463) )  //CyberP: Another fix
                //  DropDecoration();
            }
        }
    }
}

function TakeDrowningDamage()
{
    // DEUS_EX CNN - make drowning damage happen from center
    TakeDamage(5, None, Location, vect(0,0,0), class'DM_Drowned');
}

defaultproperties
{
     humanAnimRate=1.000000
     WaterSpeed=300.000000
     GroundSpeed=320.00
     AirSpeed=4000.000000
     AccelRate=1000.000000
     JumpZ=300.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     CollisionRadius=20.000000
     CollisionHeight=45.500000
     Mass=150.000000
     Buoyancy=155.000000
//     RotationRate=(Pitch=4096,Yaw=50000,Roll=3072)
     RotationRate=(Pitch=0,Yaw=20000,Roll=2048)
     bMuffledHearing=true

}




