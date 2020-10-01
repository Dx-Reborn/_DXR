//=============================================================================
// TrashCan3.
//=============================================================================
class TrashCan3a extends TrashCans;

defaultproperties
{
     bGenerateTrash=True
     bGenerateFlies=True
     ItemName="Trashcan"
//     mesh=mesh'DeusExDeco.TrashCan3'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_TrashCans.TrashCan_c_a'
     CollisionRadius=24.000000
     CollisionHeight=30.500000
     Mass=40.000000
     Buoyancy=50.000000
     Skins[0]=Texture'DXR_TrashCans.Metal.TrashCan_c_a_Tex'
//     Skins[0]=Texture'DeusExDeco.Skins.TrashCan3Tex1'
}