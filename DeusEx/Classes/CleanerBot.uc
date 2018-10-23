//=============================================================================
// CleanerBot.
//=============================================================================
class CleanerBot extends Robot;

var float blotchTimer;
var float fleePawnTimer;

enum ECleanDirection  {
	CLEANDIR_North,
	CLEANDIR_South,
	CLEANDIR_East,
	CLEANDIR_West
};

var ECleanDirection minorDir;
var ECleanDirection majorDir;





// hack -- copied from Animal.uc

defaultproperties
{
     majorDir=CLEANDIR_East
     EMPHitPoints=20
     BindName="CleanerBot"
     FamiliarName="Cleaner Bot"
     UnfamiliarName="Cleaner Bot"
     WalkingSpeed=0.200000
     GroundSpeed=300.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=20
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     AmbientSound=Sound'DeusExSounds.Robot.CleanerBotMove'
     Mesh=mesh'DeusExCharacters.CleanerBot'
     SoundRadius=16
     SoundVolume=128
     CollisionRadius=18.000000
     CollisionHeight=11.210000
     Mass=70.000000
     Buoyancy=97.000000
     RotationRate=(Yaw=100000)
}
