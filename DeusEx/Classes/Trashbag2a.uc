//=============================================================================
// Trashbag2.
//=============================================================================
class Trashbag2a extends TrashBags;

defaultproperties
{
     bGenerateTrash=True
     HitPoints=10
     FragType=Class'DeusEx.PaperFragment'
     bGenerateFlies=True
     ItemName="Trashbag"
//     mesh=mesh'DeusExDeco.Trashbag2'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_TrashBags.TrashBag_E'
     CollisionRadius=19.610001
     CollisionHeight=16.700001
     Mass=30.000000
     Buoyancy=40.000000
     Skins[0]=Shader'DXR_TrashBags.Plastic.TrashBag_E_SH'
}
