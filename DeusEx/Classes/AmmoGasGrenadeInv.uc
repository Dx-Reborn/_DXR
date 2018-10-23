//=============================================================================
// AmmoGasGrenade.
//=============================================================================
class AmmoGasGrenadeInv extends DeusExAmmoInv;

defaultproperties
{
     itemname="AmmoGasGrenadeInv"
     beltDescription="GAS GREN"
     AmmoAmount=1
     MaxAmmo=10
     Icon=Texture'DeusExUI.Icons.BeltIconGasGrenade'
     Mesh=Mesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
	   PickupClass=class'AmmoGasGrenade'
}
