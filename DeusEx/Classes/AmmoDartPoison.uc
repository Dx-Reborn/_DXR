//=============================================================================
// AmmoDartPoison.
//=============================================================================
class AmmoDartPoison extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoDartsPoison'
     Description="A mini-crossbow dart tipped with a succinylcholine-variant that causes complete skeletal muscle relaxation, effectively incapacitating a target in a non-lethal manner."
     beltDescription="TRQ DART"
     ItemName="Tranquilizer Darts"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoDartsPoison'
//     Skins[0]=Texture'DeusExItems.Skins.AmmoDartTex3'
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=60
//     Mesh=Mesh'DeusExItems.AmmoDart'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Ammo.AmmoDart_HD'
     CollisionRadius=8.500000
     CollisionHeight=2.000000
     bCollideActors=True
}
