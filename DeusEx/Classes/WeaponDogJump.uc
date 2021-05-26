//=============================================================================
// WeaponDogJump.
//=============================================================================
class WeaponDogJump extends WeaponNPCRanged;

function Fire(float Value)
{
    local ScriptedPawn PawnOwner;
    
    Super.Fire(Value);
    
    if (Owner.IsA('ScriptedPawn'))
    {
        PawnOwner = ScriptedPawn(Owner);
        
        PawnOwner.Velocity.Z += 300;
        PawnOwner.SetPhysics(PHYS_Falling);
        
        if (PawnOwner.Controller.Enemy != None)
            PawnOwner.Velocity = PawnOwner.groundspeed * 3 * normal(PawnOwner.Controller.Enemy.Location - PawnOwner.Location);
                
        PawnOwner.PlayAnimPivot('Attack');
    }
}

defaultproperties
{
    ShotTime=0.10
    HitDamage=0
    maxRange=250
    AccurateRange=250
    BaseAccuracy=0.00
    AITimeLimit=1.10
    AmmoName=Class'AmmoDogJump'
    FireSound=Sound'DeusExSounds.Animal.DogAttack1'
    SelectSound=Sound'DeusExSounds.Animal.DogAttack2'
    Misc1Sound=Sound'DeusExSounds.Animal.DogAttack1'
    Misc2Sound=Sound'DeusExSounds.Animal.DogAttack1'
    Misc3Sound=Sound'DeusExSounds.Animal.DogAttack2'
    ItemName="Jump"
    bInstantHit=true
}
