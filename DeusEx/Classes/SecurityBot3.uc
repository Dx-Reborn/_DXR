//=============================================================================
// SecurityBot3.
//=============================================================================
class SecurityBot3 extends Robot;

enum ESkinColor
{
	SC_UNATCO,
	SC_Chinese
};

var() ESkinColor SkinColor;

function BeginPlay()
{
	Super.BeginPlay();

	switch (SkinColor)
	{
		case SC_UNATCO:		Skins[0] = Texture'SecurityBot3Tex1'; break;
		case SC_Chinese:	Skins[0] = Texture'SecurityBot3Tex2'; break;
	}
}


defaultproperties
{
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.SecurityBot3TargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.SecurityBot3TargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.SecurityBot3OutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.SecurityBot3CriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.SecurityBot3Scanning'
     EMPHitPoints=40
     BindName="SecurityBot3"
     FamiliarName="Security Bot"
     UnfamiliarName="Security Bot"
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotMachinegun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mmInv',Count=50)
     GroundSpeed=95.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=150
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     AmbientSound=Sound'DeusExSounds.Robot.SecurityBot3Move'
     Mesh=mesh'DeusExCharacters.SecurityBot3'
     SoundRadius=16
     SoundVolume=128
     CollisionRadius=25.350000
     CollisionHeight=24.00
     //CollisionHeight=28.500000
     Mass=1000.000000
     Buoyancy=100.000000
//     PrePivot=(X=0,Y=0,Z=-28.5)
}
