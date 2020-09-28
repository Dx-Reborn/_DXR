//=============================================================================
// Karkian.
//=============================================================================
class Karkian extends Animal;

function ComputeFallDirection(float totalTime, int numFrames, out vector moveDir, out float stopTime)
{
    // Determine direction, and how long to slide
    if ((GetAnimSequence() == 'DeathFront') || (GetAnimSequence() == 'DeathBack'))
    {
        moveDir = Vector(DesiredRotation-rot(0,16384,0)) * default.CollisionRadius*1.2;
        stopTime = totalTime*0.7;
    }
}

function bool FilterDamageType(Pawn instigatedBy, vector hitLocation, vector offset, class<DamageType> damageType)
{
    if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas') || (damageType == class'DM_PoisonGas'))
        return false;
    else
        return Super.FilterDamageType(instigatedBy, hitLocation, offset, damageType);
}

function vector GetSwimPivot()
{
    // THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
    return (vect(0,0,1)*CollisionHeight*1.5);
}

function TweenToAttack(float tweentime)
{
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('Tread', tweentime, GetSwimPivot());
    else
        TweenAnimPivot('Attack', tweentime);
}

function PlayAttack()
{
    PlayAnimPivot('Attack');
}

function PlayPanicRunning()
{
    PlayRunning();
}

function PlayTurning()
{
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,, GetSwimPivot());
    else
        LoopAnimPivot('Walk', 0.1);
}

function TweenToWalking(float tweentime)
{
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('Tread', tweentime, GetSwimPivot());
    else
        TweenAnimPivot('Walk', tweentime);
}

function PlayWalking()
{
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,, GetSwimPivot());
    else
        LoopAnimPivot('Walk', , 0.15);
}

function TweenToRunning(float tweentime)
{
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('Tread', tweentime, GetSwimPivot());
    else
        LoopAnimPivot('Run',, tweentime);
}

function PlayRunning()
{
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,, GetSwimPivot());
    else
        LoopAnimPivot('Run');
}

function TweenToWaiting(float tweentime)
{
    if (PhysicsVolume.bWaterVolume)
        TweenAnimPivot('Tread', tweentime, GetSwimPivot());
    else
        TweenAnimPivot('BreatheLight', tweentime);
}

function PlayWaiting()
{
 if (Controller.IsInState('Paralyzed') || 
     Controller.IsInState('Attacking') || 
     Controller.IsInState('Eating') || 
     bSitting || bDancing || bStunned)
    return;

 if (Acceleration == vect(0, 0, 0))
 {
    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',,,, GetSwimPivot());
    else
        LoopAnimPivot('BreatheLight', , 0.3);
 }
}

function bool PlayRoar()
{
    if (PhysicsVolume.bWaterVolume)
        return false;
    else
    {
        PlayAnimPivot('Roar');
        return true;
    }

}

function PlayPauseWhenEating()
{
    PlayRoar();
}

function bool PlayBeginAttack()
{
    if (FRand() < 0.4)
        return PlayRoar();
    else
        return false;
}

function PlayRoarSound()
{
    PlaySound(Sound'KarkianIdle2', SLOT_Pain, 1.0,,, RandomPitch());
}

function vector GetChompPosition()
{
    return (Location+Vector(Rotation)*CollisionRadius - vect(0,0,1)*CollisionHeight*0.5);
}

function PlayTakingHit(EHitLocation hitPos)
{
    local vector pivot;
    local name   animName;

    animName = '';
    if (!PhysicsVolume.bWaterVolume)
    {
        switch (hitPos)
        {
            case HITLOC_HeadFront:
            case HITLOC_TorsoFront:
            case HITLOC_LeftArmFront:
            case HITLOC_RightArmFront:
            case HITLOC_LeftLegFront:
            case HITLOC_RightLegFront:
                animName = 'HitFront';
                break;

            case HITLOC_HeadBack:
            case HITLOC_TorsoBack:
            case HITLOC_LeftArmBack:
            case HITLOC_RightArmBack:
            case HITLOC_LeftLegBack:
            case HITLOC_RightLegBack:
                animName = 'HitBack';
                break;
        }
        pivot = vect(0,0,0);
    }

    if (animName != '')
        PlayAnimPivot(animName, , 0.1, pivot);
}

// sound functions
function PlayEatingSound()
{
    PlaySound(sound'KarkianEat', SLOT_None,,, 128); //384
}

function PlayIdleSound()
{
    PlaySound(sound'KarkianIdle', SLOT_None);
}

function PlayScanningSound()
{
    if (FRand() < 0.3)
        PlaySound(sound'KarkianIdle', SLOT_None);
}

function PlayTargetAcquiredSound()
{
    PlaySound(sound'KarkianAlert', SLOT_None);
}

function PlayCriticalDamageSound()
{
    PlaySound(sound'KarkianFlee', SLOT_None);
}

defaultproperties
{
bAIDebugLogMessages=true
     bPlayDying=True
     FoodClass=Class'DeusEx.DeusExCarcass'
     bPauseWhenEating=True
     bMessyEater=True
     bFoodOverridesAttack=True
     Alliance=Karkian
     BindName="Karkian"
     FamiliarName="Karkian"
     UnfamiliarName="Karkian"
     MinHealth=50.000000
     CarcassType=Class'DeusEx.KarkianCarcass'
     WalkingPct=0.200000
     bCanBleed=True
     bShowPain=False
     ShadowScale=1.000000
     InitialAlliances(0)=(AllianceName=Greasel,AllianceLevel=1.000000,bPermanent=True)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponKarkianBite')
     InitialInventory(1)=(Inventory=Class'DeusEx.WeaponKarkianBump')
     WalkSound=Sound'DeusExSounds.Animal.KarkianFootstep'
     bSpawnBubbles=False
     bCanSwim=True
     GroundSpeed=400.000000
     WaterSpeed=110.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=12.500000
     Health=400
     UnderWaterTime=99999.000000
     HitSound1=Sound'DeusExSounds.Animal.KarkianPainSmall'
     HitSound2=Sound'DeusExSounds.Animal.KarkianPainLarge'
     die=Sound'DeusExSounds.Animal.KarkianDeath'
     Mesh=mesh'DeusExCharacters.Karkian'
     CollisionRadius=54.000000
     CollisionHeight=32.6
     //CollisionHeight=37.099998
     Mass=500.000000
     Buoyancy=500.000000
     RotationRate=(Yaw=30000)
     ControllerClass=class'KarkianController'
}
