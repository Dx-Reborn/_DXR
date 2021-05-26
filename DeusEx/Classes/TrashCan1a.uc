//=============================================================================
// TrashCan1.
//=============================================================================
class TrashCan1a extends TrashCans;

defaultproperties
{
    bGenerateTrash=True
    ItemName="Trashcan"
//     mesh=mesh'DeusExDeco.TrashCan1'
//     CollisionRadius=19.250000
//     CollisionHeight=33.000000
    DrawScale=0.650000
    CollisionRadius=16.000000
    CollisionHeight=21.500000

    Mass=50.000000
    Buoyancy=60.000000
//     Skins[0]=Texture'DeusExDeco.Skins.TrashCan1Tex1'
    Skins[0]=Shader'DXR_TrashCans.Metal.Trashcan1_HD_SH'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_TrashCans.Trashcan1a_HD'
}

