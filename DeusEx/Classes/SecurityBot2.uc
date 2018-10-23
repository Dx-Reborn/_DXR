//=============================================================================
// SecurityBot2.
//=============================================================================
class SecurityBot2 extends Robot;

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
		case SC_UNATCO:		Skins[1] = Texture'SecurityBot2Tex1'; break;
		case SC_Chinese:	Skins[1] = Texture'SecurityBot2Tex2'; break;
	}
}


// These two functions are called from mesh notify
function SecBot2StepLeft()
{
  PlayFootStep();
}

function SecBot2StepRight()
{
  PlayFootStep();
}

function PlayDisabled()
{
	local int rnd;

	rnd = Rand(3);
	if (rnd == 0)
		TweenAnimPivot('Disabled1', 0.2);
	else if (rnd == 1)
		TweenAnimPivot('Disabled2', 0.2);
	else
		TweenAnimPivot('Still', 0.2);
}


defaultproperties
{
     SearchingSound=Sound'DeusExSounds.Robot.SecurityBot2Searching'
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.SecurityBot2TargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.SecurityBot2TargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.SecurityBot2OutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.SecurityBot2CriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.SecurityBot2Scanning'
     EMPHitPoints=100
     explosionSound=Sound'DeusExSounds.Robot.SecurityBot2Explode'
     BindName="SecurityBot2"
     FamiliarName="Security Bot"
     UnfamiliarName="Security Bot"
     WalkingSpeed=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotMachinegun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=50)
     WalkSound=Sound'DeusExSounds.Robot.SecurityBot2Walk'
     GroundSpeed=95.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=250
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     Mesh=mesh'DeusExCharacters.SecurityBot2'
     CollisionRadius=62.000000
     CollisionHeight=58.279999
     Mass=800.000000
     Buoyancy=100.000000

     skins(0)=Texture'DeusExCharacters.Skins.RobotWeaponTex1'
     skins(1)=Texture'DeusExCharacters.Skins.SecurityBot2Tex1'
}
