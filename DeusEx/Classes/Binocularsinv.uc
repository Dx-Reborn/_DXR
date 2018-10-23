//=============================================================================
// Binoculars.
//=============================================================================
class BinocularsInv extends DeusExPickupInv;

var localized string binocsActive, binocsInactive;

state Activated
{
	function Activate()
	{
//		local DeusExPlayer player;

		Super.Activate();

//		player = DeusExPlayer(Owner);
//		if (player != None)
//			player.DesiredFOV = player.Default.DesiredFOV;
	}

	function BeginState()
	{
//		local DeusExPlayer player;
	
		Super.BeginState();
    ToggleBinocularsView(true);

//		player = DeusExPlayer(Owner);
//		RefreshScopeDisplay(player, False);
	}
Begin:
}

//---------------
state DeActivated
{
	function BeginState()
	{
		local DeusExPlayer player;
		
		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
		{
			// Hide the Scope View
         ToggleBinocularsView(false);
//			DeusExRootWindow(player.rootWindow).scopeView.DeactivateView();
		}
	}
}

function ToggleBinocularsView(bool bDoIt)
{
  local DeusExHUD dh;
  local DeusExPlayerController dc;

  dh = DeusExHUD(level.getLocalPlayerController().myHUD);
  dc = DeusExPlayerController(level.GetLocalPlayerController());
  dh.bUseBinocularView = bDoIt;

  if (bDoIt)
      dc.DesiredFOV=20;
  else
      dc.ResetFOV();
}


function string GetDescription()
{
  return description;
}


defaultproperties
{
    bActivatable=True
    Pickupclass=class'Binoculars'
    PlayerViewOffset=(X=18.00,Y=0.00,Z=-6.00)
 		PlayerViewPivot=(Pitch=0,Roll=0,Yaw=16384)
    binocsActive="Binoculars activated"
    binocsInactive="Binoculars DeActivated"
    Description="A pair of military binoculars."
    ItemName="Binoculars"
    beltDescription="BINOCS"
    Icon=Texture'DeusExUI.Icons.BeltIconBinoculars'
    largeIcon=Texture'DeusExUI.Icons.LargeIconBinoculars'
    largeIconWidth=49
    largeIconHeight=34
    bCanHaveMultipleCopies=false

    Mesh=Mesh'DeusExItems.Binoculars'
    PickupViewMesh=Mesh'DeusExItems.Binoculars'
    FirstPersonViewMesh=Mesh'DeusExItems.Binoculars'

    CollisionRadius=7.000000
    CollisionHeight=2.060000
    Mass=5.000000
    Buoyancy=6.000000
}
