//================================================
// ƒл€ тестировани€ идей как сделать LaserTrigger.

class TestLaserTrace extends DeusExDecoration;

var float CheckTime;
var() int MaxDistance;
var actor LastHitActor;

var EM_LaserBeam emitter;

function BeginPlay()
{
    Super.BeginPlay();

	    LastHitActor = None;
	    emitter = Spawn(class'EM_Laserbeam');
	    if (emitter != none)
    	{
	    	BeamEmitter(emitter.Emitters[0]).BeamDistanceRange.Min=MaxDistance;
  	  	BeamEmitter(emitter.Emitters[0]).BeamDistanceRange.Max=MaxDistance;
      }
}

function Tick(float deltatime)
{
	CheckTime += deltaTime;

  emitter.SetLocation(Location);
  emitter.SetRotation(Rotation);

  if ((beamTarget().isA('Actor')) && (!beamTarget().isA('LevelInfo')) && (beamTarget() != LastHitActor))
  {
		log(beamTarget()@"broken beam!");
  }

}

// “рассирует линию, и при пересечении с актором возвращает его им€.
function Actor BeamTarget()
{
	local Actor Target;
	local Vector HitLoc, HitNormal, StartTrace, EndTrace;

	// ѕровер€ть каждые 0.01 сек.
	if (CheckTime > 0.01) // >=
	{
		StartTrace = Location;
		EndTrace = Location + (Vector(Rotation) * MaxDistance);
		
		foreach TraceActors(class'Actor', target, HitLoc, HitNormal, EndTrace, StartTrace)
		{
			if (target != none)
			{
				return target;
				EndTrace = target.Location;
			}
		}
		LastHitActor=target;
		EndTrace = Location + (Vector(Rotation) * MaxDistance);
	}
	CheckTime=0;
}


defaultProperties
{
		ItemName="TestTrace"
		drawType=DT_Mesh
		mesh=mesh'DeusExDeco.LaserEmitter'
	  CollisionRadius=2.50
	  CollisionHeight=2.50
    SoundRadius=16
    AmbientSound=Sound'Ambient.Ambient.Laser'
    bDirectional=true
    Physics=PHYS_none
    bPushable=false
		MaxDistance=1000
}