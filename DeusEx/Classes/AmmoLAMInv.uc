//=============================================================================
// AmmoLAM.
//=============================================================================
class AmmoLAMInv extends DeusExAmmoInv;

defaultproperties
{
     itemName="AmmoLAMInv"
     beltDescription="LAM"
     AmmoAmount=1
     MaxAmmo=10
     Icon=Texture'DeusExUI.Icons.BeltIconLAM'
     Mesh=Mesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
	   PickupClass=class'AmmoLAM'
}
