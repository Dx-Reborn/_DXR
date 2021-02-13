//=============================================================================
// AmmoDartFlare.
//=============================================================================
class AmmoDartFlare extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoDartsFlare'
     Description="Mini-crossbow flare darts use a slow-burning incendiary device, ignited on impact, to provide illumination of a targeted area."
     beltDescription="FLR DART"
     ItemName="Flare Darts"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoDartsFlare'
//     Skins[0]=Texture'DeusExItems.Skins.AmmoDartTex2'
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=60
//     Mesh=Mesh'DeusExItems.AmmoDart'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Ammo.AmmoDartFlare_HD'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
}

