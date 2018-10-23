//=============================================================================
// SkilledToolInv.
// Все инструменты и оружие праворукие, учитывать Hand не нужно.
//=============================================================================

#exec OBJ LOAD FILE=DeusExItemsEx

class SkilledToolInv extends DeusExPickupInv
	abstract;

var() sound		useSound;
var bool			bBeingUsed;
var int 			ToolsFOV;

function Activate()
{
}
function UsedUp()
{
}

// ----------------------------------------------------------------------
// PlayUseAnim()
// ----------------------------------------------------------------------

function PlayUseAnim()
{
	if (!IsInState('UseIt'))
		GotoState('UseIt');
}

// ----------------------------------------------------------------------
// StopUseAnim()
// ----------------------------------------------------------------------

function StopUseAnim()
{
	if (IsInState('UseIt'))
		GotoState('StopIt');
}

// ----------------------------------------------------------------------
// PlayIdleAnim()
// ----------------------------------------------------------------------

function PlayIdleAnim()
{
	local float rnd;

	rnd = FRand();

	if (rnd < 0.1)
		PlayAnim('Idle1');
	else if (rnd < 0.2)
		PlayAnim('Idle2');
	else if (rnd < 0.3)
		PlayAnim('Idle3');
}

// ----------------------------------------------------------------------
// PickupFunction()
//
// called when the object is picked up off the ground
// ----------------------------------------------------------------------

function PickupFunction(Pawn Other)
{
	GotoState('Idle2');
}

// ----------------------------------------------------------------------
// BringUp()
//
// called when the object is put in hand
// ----------------------------------------------------------------------

function BringUp()
{
	if (!IsInState('Idle'))
		GotoState('Idle');
}

// ----------------------------------------------------------------------
// PutDown()
//
// called to put the object away
// ----------------------------------------------------------------------

function PutDown()
{
	if (IsInState('Idle'))
		GotoState('DownItem');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state Idle
{
	function Timer()
	{
		PlayIdleAnim();
	}

Begin:
//	bHidden = False;
	bOnlyOwnerSee = True;
	PlayAnim('Select',, 0.1);
DontPlaySelect:
	FinishAnim();
	PlayAnim('Idle1',, 0.1);
	SetTimer(3.0, True);
}

//
// Null state.
//
State Idle2
{
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state UseIt
{
	function PutDown()
	{
		
	}

Begin:
	AmbientSound = useSound;
	PlayAnim('UseBegin',, 0.1);
	FinishAnim();
	LoopAnim('UseLoop',, 0.1);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state StopIt
{
	function PutDown()
	{
		
	}

Begin:
	AmbientSound = None;
	PlayAnim('UseEnd',, 0.1);
	FinishAnim();
	GotoState('Idle', 'DontPlaySelect');
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
state DownItem
{
	function PutDown()
	{
		
	}

Begin:
	AmbientSound = None;
//	bHidden = False;		// make sure we can see the animation
	PlayAnim('Down',, 0.1);
	FinishAnim();
//	bHidden = True;			// hide it correctly
	GotoState('Idle2');
}

// ----------------------------------------------------------------------
// UseOnce()
//
// Subtract a use, then destroy if out of uses
// ----------------------------------------------------------------------

function UseOnce()
{
	local DeusExPlayer player;

	player = DeusExPlayer(Owner);
	NumCopies--;

	if (NumCopies <= 0)
	{
		if (player.inHand == Self)
			player.PutInHand(None);
		Destroy();
	}
	else
	{
		DeusExPlayer(Owner).ClientMessage("UpdateBeltText()"); //UpdateBeltText();
	}
}

//function AttachToPawn(Pawn P){}
// Stubbed


/*event RenderOverlays(canvas Canvas)
{
	if ( (Instigator == None) || (Instigator.Controller == None))
		return;
 	super.RenderOverlays(Canvas);
  bDrawingFirstPerson = true;
  Canvas.DrawActor(self, false, true);
  bDrawingFirstPerson = false;

// function DrawActor( Actor A, bool WireFrame, optional bool ClearZ, optional float DisplayFOV );
}*/


defaultproperties
{
		bDisplayableInv=true
		bCanHaveMultipleCopies=true     // if player can possess more than one of this
		bAutoActivate=false			   // automatically activated when picked up
		bActivatable=false       // Whether item can be activated/deactivated (if true, must auto activate)
		DrawType=DT_Mesh
		PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768) 
    CountLabel="Uses:"
		ToolsFOV=75
		bHidden=true
//		attachmentclass=class'EmptyAttachment'
}
