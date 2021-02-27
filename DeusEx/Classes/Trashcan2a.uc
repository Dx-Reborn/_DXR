//=============================================================================
// Trashcan2.
//=============================================================================
class Trashcan2a extends TrashCans;

defaultproperties
{
     bGenerateTrash=True
     ItemName="Trashcan"
     mesh=mesh'DeusExDeco.Trashcan2'
//     CollisionRadius=14.860000
//     CollisionHeight=24.049999
     CollisionRadius=16.000000
     CollisionHeight=26.500000
     DrawScale=0.800000
     Mass=40.000000
     Buoyancy=50.000000
//     Skins[0]=Texture'DeusExDeco.Skins.Trashcan2Tex1'
     Skins[0]=Shader'DXR_TrashCans.Metal.Trashcan2a_HD_SH'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_TrashCans.Trashcan2a_HD'
}
