//=============================================================================
// Vehicles.
//=============================================================================
class Vehicles extends DeusExDecoration
	abstract;

//
// bInWorld stuff copied from ScripedPawn
//
var() bool bInWorld;
var vector WorldPosition;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (!bInWorld)
	{
		// tricky
		bInWorld = true;
		LeaveWorld();
	}
}

function StartInterpolation()
{
  	SetCollision(false, false, false);
		bCollideWorld = False;
		SetPhysics(PHYS_Interpolating);
		bInterpolating = True;
		bStasis = false;
		GotoState('Interpolating');

}


state Interpolating
{
//  function Tick(float deltaTime)
//  {
//  }
	// check to see if we are done interpolating, if so, then destroy us
	function FinishedInterpolation()// (Actor Other)
	{
	    Super.FinishedInterpolation();
//		Super.InterpolateEnd(Other);

//		if (InterpolationPoint(Other).bEndOfPath)
			Destroy();
	}
}

// ----------------------------------------------------------------------
// EnterWorld()
// ----------------------------------------------------------------------

function EnterWorld()
{
	PutInWorld(true);
}


// ----------------------------------------------------------------------
// LeaveWorld()
// ----------------------------------------------------------------------

function LeaveWorld()
{
	PutInWorld(false);
}


// ----------------------------------------------------------------------
// PutInWorld()
// ----------------------------------------------------------------------

function PutInWorld(bool bEnter)
{
	if (bInWorld && !bEnter)
	{
		bInWorld = false;
		bHidden       = true;
		bDetectable   = false;
		WorldPosition = Location;
		SetCollision(false, false, false);
		bCollideWorld = false;
		SetPhysics(PHYS_None);
		SetLocation(Location+vect(0,0,20000));  // move it out of the way
	}
	else if (!bInWorld && bEnter)
	{
		bInWorld    = true;
		bHidden     = Default.bHidden;
		bDetectable = Default.bDetectable;
		SetLocation(WorldPosition);
		SetCollision(default.bCollideActors, default.bBlockActors, default.bBlockPlayers);
		bCollideWorld = Default.bCollideWorld;
		SetPhysics(Default.Physics);
	}
}

defaultproperties
{
    bInWorld=True
    bInvincible=True
    bPushable=False
    Physics=0
}