//=============================================================================
// AmmoNone.
//=============================================================================
class AmmoNone extends DeusExAmmo Notplaceable;

// special ammo type for hand to hand weapons

defaultproperties
{
		 InventoryType=class'AmmoNoneInv'
     Mesh=Mesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
}
