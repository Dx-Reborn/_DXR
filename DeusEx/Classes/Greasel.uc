//=============================================================================
// Greasel.
//=============================================================================
class Greasel extends Animal;

function bool FilterDamageType(Pawn instigatedBy, Vector hitLocation, Vector offset, class<damageType> damageType)
{
    if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas') || (damageType == class'DM_PoisonGas'))
        return false;
    else
        return Super.FilterDamageType(instigatedBy, hitLocation, offset, damageType);
}

function vector GetSwimPivot()
{
    // THIS IS A HIDEOUS, UGLY, MASSIVELY EVIL HACK!!!!
    return (vect(0,0,1)*CollisionHeight);
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
        LoopAnimPivot('Tread',1.5,,, GetSwimPivot());
    else
        LoopAnimPivot('Run', 1.5);
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
 if (Acceleration != vect(0, 0, 0))
 return;

 if (Controller.IsInState('Paralyzed') || Controller.IsInState('Eating') || bSitting || bDancing || bStunned)
 return;

    if (PhysicsVolume.bWaterVolume)
        LoopAnimPivot('Tread',1.5,,, GetSwimPivot());
    else
        LoopAnimPivot('BreatheLight', , 0.3);
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

function vector GetChompPosition()
{
    return (Location+Vector(Rotation)*(CollisionRadius+10)+vect(0,0,-10));
}

function PlayEating()
{
    PlayAnimPivot('Eat', 2.0, 0.2);
}

function SpewBlood(vector Position)
{
    local float         size;
    local FleshFragment chunk;

    size = (CollisionRadius + CollisionHeight) / 2;  // yes, we *are* using the Greasel's size...  :)
    if ((FRand() < 0.5) && (size > 10.0))
    {
        chunk = spawn(class'FleshFragment', None,, Position);
        if (chunk != None)
        {
            chunk.SetDrawScale(size / 25);
            chunk.SetCollisionSize(chunk.CollisionRadius / chunk.DrawScale, chunk.CollisionHeight / chunk.DrawScale);
            chunk.bFixedRotationDir = True;
            chunk.RotationRate = RotRand(false);
            chunk.Velocity = VRand()*100;
            chunk.Velocity.Z = chunk.Velocity.Z + 250;
        }
    }
    else
        Super.SpewBlood(Position);
}

// sound functions
function PlayEatingSound()
{
    PlaySound(sound'GreaselEat', SLOT_None,,, 128); // 384
}

function PlayIdleSound()
{
    if (FRand() < 0.5)
        PlaySound(sound'GreaselIdle', SLOT_None);
    else
        PlaySound(sound'GreaselIdle2', SLOT_None);
}

function PlayScanningSound()
{
    if (FRand() < 0.3)
    {
        if (FRand() < 0.5)
            PlaySound(sound'GreaselIdle', SLOT_None);
        else
            PlaySound(sound'GreaselIdle2', SLOT_None);
    }
}

function PlayTargetAcquiredSound()
{
    PlaySound(sound'GreaselAlert', SLOT_None);
}

function PlayCriticalDamageSound()
{
    PlaySound(sound'GreaselFlee', SLOT_None);
}

defaultproperties
{
     bPlayDying=True
     FoodClass=Class'DeusEx.DeusExCarcass'
     FoodDamage=5
     FoodHealth=2
     bMessyEater=True
     Alliance=Greasel
     BindName="Greasel"
     FamiliarName="Greasel"
     UnfamiliarName="Greasel"
     MinHealth=20.000000
     CarcassType=Class'DeusEx.GreaselCarcass'
     WalkingPct=0.080000
     bCanBleed=True
     ShadowScale=1.000000
     InitialAlliances(0)=(AllianceName=Karkian,AllianceLevel=1.000000,bPermanent=True)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponGreaselSpit')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoGreaselSpit',Count=9999)
     WalkSound=Sound'DeusExSounds.Animal.GreaselFootstep'
     bSpawnBubbles=False
     bCanSwim=True
     GroundSpeed=350.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=12.500000
     Health=100
     UnderWaterTime=99999.000000
     HitSound1=Sound'DeusExSounds.Animal.GreaselPainSmall'
     HitSound2=Sound'DeusExSounds.Animal.GreaselPainLarge'
     die=Sound'DeusExSounds.Animal.GreaselDeath'
     Mesh=mesh'DeusExCharacters.Greasel'
     //CollisionHeight=17.879999
//     CollisionRadius=34.00
     CollisionRadius=26.00
     CollisionHeight=13.37
//     CollisionRadius=8.00
//     CollisionHeight=8.37
     Mass=40.000000
     Buoyancy=40.000000
     ControllerClass=class'GreaselController'
}
