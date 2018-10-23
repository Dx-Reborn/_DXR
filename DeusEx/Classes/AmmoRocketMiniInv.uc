//=============================================================================
// AmmoRocketMini.
//=============================================================================
class AmmoRocketMiniInv extends DeusExAmmoInv;

defaultproperties
{
     AmmoAmount=20
     MaxAmmo=60
     Mesh=Mesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
	   PickupClass=class'AmmoRocketMini'
}