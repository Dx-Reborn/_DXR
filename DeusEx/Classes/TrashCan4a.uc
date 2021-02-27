//=============================================================================
// TrashCan4.
//=============================================================================
class TrashCan4a extends TrashCans;

defaultproperties
{
     bGenerateTrash=True
     bGenerateFlies=True
     ItemName="Trashcan"
//     mesh=mesh'DeusExDeco.TrashCan4'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_TrashCans.Trashcan_Opened_a'
//     CollisionRadius=24.000000
//     CollisionHeight=29.000000
     DrawScale=0.850000
     CollisionRadius=21.000000
     CollisionHeight=24.700001
     Mass=40.000000
     Buoyancy=50.000000
     Skins[0]=Texture'DXR_TrashCans.Metal.Trashcan_Open_a_Tex'
//     Skins[0]=Texture'DeusExDeco.Skins.TrashCan4Tex1'
}
