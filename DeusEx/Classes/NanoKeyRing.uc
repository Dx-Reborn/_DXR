//=============================================================================
// NanoKeyRing
//
// NanoKeyRing object.  In order to make things easier
// on the player, when the player picks up a key it's added 
// to the list of keys stored in the keyring
//=============================================================================

class NanoKeyRing extends SkilledTool;

defaultproperties
{
		 InventoryType=class'NanoKeyRingInv'
     ItemName="Nanokey Ring"
     Mesh=Mesh'DeusExItems.NanoKeyRing'
     CollisionRadius=5.510000
     CollisionHeight=4.690000
     Mass=10.000000
     Buoyancy=5.000000
}
