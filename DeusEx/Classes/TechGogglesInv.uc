//=============================================================================
// TechGoggles.
//=============================================================================
class TechGogglesInv extends ChargedPickupInv;

// ----------------------------------------------------------------------
// ChargedPickupBegin()
// ----------------------------------------------------------------------
function ChargedPickupBegin(DeusExPlayer Player)
{
  local DeusExHUD dxh;

  dxh = DeusExHUD(DeusExPlayerController(Player.Controller).myHUD);
	Super.ChargedPickupBegin(Player);

	dxh.activeCount++;
//	DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount++;
	UpdateHUDDisplay(Player);
}

// ----------------------------------------------------------------------
// UpdateHUDDisplay()
// ----------------------------------------------------------------------

function UpdateHUDDisplay(DeusExPlayer Player)
{
  local DeusExHUD dxh;

  dxh = DeusExHUD(DeusExPlayerController(Player.Controller).myHUD);

  if ((dxh.activeCount == 0) && (IsActive()))
      dxh.ActiveCount++;
//	if ((DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 0) && (IsActive()))
//		DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount++;

  dxh.bVisionActive = true;
  dxh.visionLevel = 0;
  dxh.visionLevelValue = 0;
	
//	DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = True;
//	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevel = 0;
//	DeusExRootWindow(Player.rootWindow).hud.augDisplay.visionLevelValue = 0;
}

// ----------------------------------------------------------------------
// ChargedPickupEnd()
// ----------------------------------------------------------------------

function ChargedPickupEnd(DeusExPlayer Player)
{
  local DeusExHUD dxh;

  dxh = DeusExHUD(DeusExPlayerController(Player.Controller).myHUD);
	Super.ChargedPickupEnd(Player);

	if (--dxh.activeCount == 0)
	    dxh.bVisionActive = false;

//	if (--DeusExRootWindow(Player.rootWindow).hud.augDisplay.activeCount == 0)
//		DeusExRootWindow(Player.rootWindow).hud.augDisplay.bVisionActive = False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    LoopSound=Sound'DeusExSounds.Pickup.TechGogglesLoop'
    ChargedIcon=Texture'DeusExUI.Icons.ChargedIconGoggles'
    ExpireMessage="TechGoggles power supply used up"
    ItemName="Tech Goggles"
    PlayerViewOffset=(X=20.00,Y=0.00,Z=-6.00)

    FirstPersonViewMesh=Mesh'DeusExItems.GogglesIR'
    PickupViewMesh=Mesh'DeusExItems.GogglesIR'
    Mesh=Mesh'DeusExItems.GogglesIR'

    Charge=500
    LandSound=Sound'DeusExSounds.Generic.PaperHit2'
    Icon=Texture'DeusExUI.Icons.BeltIconTechGoggles'
    largeIcon=Texture'DeusExUI.Icons.LargeIconTechGoggles'
    largeIconWidth=49
    largeIconHeight=36
    Description="Tech goggles are used by many special ops forces throughout the world under a number of different brand names, but they all provide some form of portable light amplification in a disposable package."
    beltDescription="GOGGLES"
    CollisionRadius=8.00
    CollisionHeight=2.80
    Mass=10.00
    Buoyancy=5.00
}
