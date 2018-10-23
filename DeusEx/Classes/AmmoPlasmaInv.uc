//=============================================================================
// AmmoPlasma.
//=============================================================================
class AmmoPlasmaInv extends DeusExAmmoInv;

defaultproperties
{
     largeIconWidth=22
     largeIconHeight=46
     Description="A clip of extruded, magnetically-doped plastic slugs that can be heated and delivered with devastating effect using the plasma gun."
     beltDescription="PMA CLIP"
     bShowInfo=True
     AmmoAmount=12
     MaxAmmo=84
     ItemName="Plasma Clip"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoPlasma'
     Mesh=Mesh'DeusExItems.AmmoPlasma'
     CollisionRadius=4.300000
     CollisionHeight=8.440000
     bCollideActors=True
	   PickupClass=class'AmmoPlasma'
}
