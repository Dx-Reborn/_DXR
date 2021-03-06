//=============================================================================
// AmmoDart.
//=============================================================================
class AmmoDart extends DeusExAmmo;

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
//     Mesh=Mesh'DeusExItems.AmmoDart'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Ammo.AmmoDartSteel_HD'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
     LandSound=Sound'DeusExSounds.Generic.PaperHit2'
}

