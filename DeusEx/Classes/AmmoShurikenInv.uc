//=============================================================================
// AmmoShuriken.
//=============================================================================
class AmmoShurikenInv extends DeusExAmmoInv;

defaultproperties
{
     AmmoAmount=5
     MaxAmmo=25
     Mesh=Mesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
	   PickupClass=class'AmmoShuriken'
}
