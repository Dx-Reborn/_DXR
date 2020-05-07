//=============================================================================
// Trashbag2.
//=============================================================================
class Trashbag2 extends TrashBags;

defaultproperties
{
     bGenerateTrash=True
     HitPoints=10
     FragType=Class'DeusEx.PaperFragment'
     bGenerateFlies=True
     ItemName="Trashbag"
//     mesh=mesh'DeusExDeco.Trashbag2'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes10.TrashBag_E'
     CollisionRadius=19.610001
     CollisionHeight=16.700001
     Mass=30.000000
     Buoyancy=40.000000
     Skins[0]=Shader'DeusExStaticMeshes10.Plastic.TrashBag_E_SH'
}
