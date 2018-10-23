//=============================================================================
// Ammo20mm.
//=============================================================================
class Ammo20mmInv extends DeusExAmmoInv;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmo20mm'
     largeIconWidth=47
     largeIconHeight=37
     Description="The 20mm high-explosive round complements the standard 7.62x51mm assault rifle by adding the capability to clear small rooms, foxholes, and blind corners using an underhand launcher."
     beltDescription="20MM AMMO"
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=32
     ItemName="20mm HE Ammo"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmo20mm'
     Mesh=Mesh'DeusExItems.Ammo20mm'
     CollisionRadius=9.500000
     CollisionHeight=4.750000
     bCollideActors=True
	   PickupClass=class'Ammo20mm'
}
