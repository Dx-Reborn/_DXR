//=============================================================================
// PatrolPoint.
//=============================================================================
class PatrolPoint extends /*SmallNavigationPoint*/ PathNode
                          placeable;

var() name Nextpatrol; //next point to go to
var() float pausetime; //how long to pause here
var	 vector lookdir; //direction to look while stopped
var() name PatrolAnim;
var() sound PatrolSound;
var() byte numAnims;
var int	AnimCount;
var PatrolPoint NextPatrolPoint;
var int LoopTimes;

function PreBeginPlay()
{
	local PatrolPoint CurPoint;

	lookdir = 200 * vector(Rotation);

	//find the patrol point with the tag specified by Nextpatrol
	NextPatrolPoint = None;
	if (NextPatrol != '')
	{
		foreach AllActors(class 'PatrolPoint', CurPoint, Nextpatrol)
		{
			if (CurPoint != self)
			{
				NextPatrolPoint = CurPoint;
				//log(self$", next one is "$NextPatrolPoint);
				break;
			}
		}
	}
	
	Super.PreBeginPlay();
}

defaultproperties
{
    bDirectional=True
    Texture=Texture'S_Patrol'
    SoundVolume=128
}
