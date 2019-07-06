//=============================================================================
// AmmoDart.
//=============================================================================
class AmmoDartInv extends DeusExAmmoInv;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoDartsNormal'
     largeIconWidth=20
     largeIconHeight=47
     Description="The mini-crossbow dart is a favored weapon for many 'wet' operations; however, silent kills require a high degree of skill."
     beltDescription="DART"
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=60
     ItemName="Darts"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoDartsNormal'
     Mesh=Mesh'DeusExItems.AmmoDart'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
     PickupClass=class'AmmoDart'
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
}
