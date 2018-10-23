//=============================================================================
// Fishes.
//=============================================================================
class Fishes extends Animal
	abstract;

var   float leaderTimer;
var   float forwardTimer;
var   float bumpTimer;
var   float abortTimer;
var   float breatheTimer;
var() bool  bFlock;
var() bool  bStayHorizontal;












// Approximately five million stubbed out functions...

defaultproperties
{
     bFlock=True
     BindName="Fishes"
     WalkingSpeed=1.000000
     bHasShadow=False
     bHighlight=False
     bSpawnBubbles=False
     bCanWalk=False
     bCanSwim=True
     GroundSpeed=100.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     // MaxStepHeight=1.000000
     //  MinHitWall=0.000000
     BaseEyeHeight=1.000000
     UnderWaterTime=99999.000000
     Physics=PHYS_Swimming
     Mesh=mesh'DeusExCharacters.Fish'
     CollisionRadius=7.760000
     CollisionHeight=3.890000
     bBlockActors=False
     bBlockPlayers=False
     bBounce=True
     Mass=1.000000
     Buoyancy=1.000000
     RotationRate=(Pitch=6000,Yaw=25000)
}
