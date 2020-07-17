//=============================================================================
// Trashbag.
//=============================================================================
class Trashbag extends TrashBags;

defaultproperties
{
     bGenerateTrash=True
     HitPoints=10
     FragType=Class'DeusEx.PaperFragment'
     bGenerateFlies=True
     ItemName="Trashbag"
//     mesh=mesh'DeusExDeco.Trashbag'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_TrashBags.TrashBag_b'
     CollisionRadius=26.360001
     CollisionHeight=26.760000
     Mass=30.000000
     Buoyancy=40.000000
     skins[0]=Shader'DXR_TrashBags.Plastic.TrashBag_b_SH'
//     skins[0]=Texture'DeusExDeco.Skins.TrashbagTex1'
}

