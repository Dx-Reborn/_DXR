//=============================================================================
// PatrolPoint.
//=============================================================================
class PatrolPoint extends SmallNavigationPoint
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

function touch(actor act)
{
  log(self$" touched by "$act);
}


/*DEUS_EX STM -- fixed a bug involving NextPatrolPoint
function PreBeginPlay()
{
	if (pausetime > 0.0)
		lookdir = 200 * vector(Rotation);

	//find the patrol point with the tag specified by Nextpatrol
	foreach AllActors(class 'PatrolPoint', NextPatrolPoint, Nextpatrol)
		break; 
	
	Super.PreBeginPlay();
}
*/
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
// DEUS_EX STM -- end changes


defaultproperties
{
    bDirectional=True
    Texture=Texture'S_Patrol'
    SoundVolume=128
//        CollisionRadius=12.00
//    CollisionHeight=15.00
     bHidden=false
}
