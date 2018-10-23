//=============================================================================
// HumanMilitary.
//=============================================================================
class HumanMilitary extends ScriptedPawn
	abstract;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// change the sounds for chicks
	if (bIsFemale)
	{
		HitSound1 = Sound'FemalePainMedium';
		HitSound2 = Sound'FemalePainLarge';
		Die = Sound'FemaleDeath';
	}
}


defaultproperties
{
     VisibilityThreshold=0.010000
     BindName="HumanMilitary"
     BaseAccuracy=0.200000
     MaxRange=1000.000000
     MinHealth=20.000000
     bPlayIdle=True
     bCanCrouch=True
     bSprint=True
     CrouchRate=1.000000
     SprintRate=1.000000
     bReactAlarm=True
     EnemyTimeout=5.000000
     bCanTurnHead=True
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     die=Sound'DeusExSounds.Player.MaleDeath'
     Texture=Texture'Engine.S_Pawn'
     Mass=150.000000
     Buoyancy=155.000000
}
