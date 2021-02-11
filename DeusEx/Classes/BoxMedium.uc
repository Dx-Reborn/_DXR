//=============================================================================
// BoxMedium.
//=============================================================================
class BoxMedium extends CardBoardBoxes;

defaultproperties
{
     bBlockSight=True
     HitPoints=10
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Cardboard Box"
//     mesh=mesh'DeusExDeco.BoxMedium'
     StaticMesh=StaticMesh'DeusExStaticMeshes0.CardBoardBox_Medium_SM'
     DrawType=DT_StaticMesh
     CollisionRadius=42.000000
     CollisionHeight=30.000000
     Mass=50.000000
     Buoyancy=60.000000
//     Skins[0]=Texture'DeusExDeco.Skins.BoxMediumTex1'
     Skins[0]=Texture'DeusExStaticMeshes0.Cardboard.CardBoardBoxMedium_Tex'
}
