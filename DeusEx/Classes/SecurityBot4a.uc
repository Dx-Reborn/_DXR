//=============================================================================
// SecurityBot4.
//=============================================================================
class SecurityBot4a extends Robot;

defaultproperties
{
     SpeechTargetAcquired=Sound'DeusExSounds.Robot.SecurityBot3TargetAcquired'
     SpeechTargetLost=Sound'DeusExSounds.Robot.SecurityBot3TargetLost'
     SpeechOutOfAmmo=Sound'DeusExSounds.Robot.SecurityBot3OutOfAmmo'
     SpeechCriticalDamage=Sound'DeusExSounds.Robot.SecurityBot3CriticalDamage'
     SpeechScanning=Sound'DeusExSounds.Robot.SecurityBot3Scanning'
     BindName="SecurityBot4"
     FamiliarName="Security Bot"
     UnfamiliarName="Security Bot"
     WalkingPct=1.000000
     bEmitDistress=True
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponRobotMachinegun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=50)
     GroundSpeed=95.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=150
     UnderWaterTime=20.000000
     AmbientSound=Sound'DeusExSounds.Robot.SecurityBot4Move'
     Mesh=mesh'DeusExCharacters.SecurityBot4'
     SoundRadius=16
     SoundVolume=128
     CollisionRadius=27.500000
     CollisionHeight=24.50
     //CollisionHeight=28.500000
     Mass=1000.000000
     Buoyancy=100.000000
}
