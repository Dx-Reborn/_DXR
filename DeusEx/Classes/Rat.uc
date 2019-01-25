//=============================================================================
// Rat.
//=============================================================================
class Rat extends Animal;

var(AI) float MinLightLevel;
var(AI) float MaxLightLevel;
var(AI) float ReactionTime;
var(AI) float MaxWaitTime;
var float     ComputedSpeed;
var float     LastAgitation;
var float     CurrentAgitation;

var float time;




// ----------------------------------------------------------------------
// state Wandering
// ----------------------------------------------------------------------

// Ripped right out of ScriptedPawn and modified -- need to make this generic?

defaultproperties
{
     MinLightLevel=0.030000
     MaxLightLevel=0.080000
     ReactionTime=0.500000
     MaxWaitTime=10.000000
     bFleeBigPawns=True
     HealthHead=5
     HealthTorso=5
     HealthLegLeft=5
     HealthLegRight=5
     HealthArmLeft=5
     HealthArmRight=5
     Alliance=Rat
     BindName="Rat"
     FamiliarName="Rat"
     UnfamiliarName="Rat"
     Restlessness=0.900000
     Wanderlust=0.200000
     MinHealth=2.000000
     CarcassType=Class'DeusEx.RatCarcass'
     WalkingSpeed=0.360000
     GroundSpeed=250.000000
     WaterSpeed=24.000000
     AirSpeed=150.000000
     AccelRate=500.000000
     JumpZ=0.000000
     // MaxStepHeight=8.000000
     BaseEyeHeight=1.000000
     Health=5
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Fear
     HitSound1=Sound'DeusExSounds.Animal.RatSqueak1'
     HitSound2=Sound'DeusExSounds.Animal.RatSqueak3'
     die=Sound'DeusExSounds.Animal.RatDie'
     Mesh=mesh'DeusExCharacters.Rat'
     CollisionRadius=16.000000
     CollisionHeight=3.500000
     bBlockActors=False
     Mass=2.000000
     Buoyancy=2.000000
     RotationRate=(Yaw=65530)
}
