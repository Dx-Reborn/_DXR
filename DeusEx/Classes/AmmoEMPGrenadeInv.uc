//=============================================================================
// AmmoEMPGrenade.
//=============================================================================
class AmmoEMPGrenadeInv extends DeusExAmmoInv;

defaultproperties
{
     itemname="AmmoEMPGrenadeInv"
     beltDescription="EMP GREN"
     AmmoAmount=1
     MaxAmmo=10
     Icon=Texture'DeusExUI.Icons.BeltIconEMPGrenade'
     Mesh=Mesh'DeusExItems.TestBox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     bCollideActors=True
	   PickupClass=class'AmmoEMPGrenade'
}
