//=============================================================================
// AmmoNone.
//=============================================================================
class AmmoNoneInv extends DeusExAmmoInv;

// special ammo type for hand to hand weapons

defaultproperties
{
     Mesh=Mesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
	   PickupClass=class'AmmoNone'
	   ammoamount=50
	   maxammo=50
	   itemName="Ammo noneInv"
}
