//=============================================================================
// CandybarInv
//=============================================================================
class CandybarInv extends DeusExPickupInv;

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;
		
		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
			player.HealPlayer(2, False);
		
		UseOnce();
	}
Begin:
}

defaultproperties
{
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    Icon=Texture'DeusExUI.Icons.BeltIconCandyBar'
    largeIcon=Texture'DeusExUI.Icons.LargeIconCandyBar'
    largeIconWidth=46
    largeIconHeight=36
    Description="'CHOC-O-LENT DREAM. IT'S CHOCOLATE! IT'S PEOPLE! IT'S BOTH!(tm) 85% Recycled Material.'"
    ItemName="Candy Bar"
    beltDescription="CANDY BAR"

    Mesh=Mesh'DeusExItems.Candybar'
    PickupViewMesh=Mesh'DeusExItems.Candybar'
    FirstPersonViewMesh=Mesh'DeusExItems.Candybar'

    PickupClass=class'CandyBar'
    CollisionRadius=6.250000
    CollisionHeight=0.670000
    Mass=3.000000
    Buoyancy=4.000000
}