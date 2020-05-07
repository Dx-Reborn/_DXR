//=============================================================================
// SignFloor.
//=============================================================================
class SignFloor extends DeusExDecoration;

defaultproperties
{
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Caution Sign"
//     mesh=mesh'DeusExDeco.SignFloor'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.WetFloorSign_a'
     CollisionRadius=12.500000
     CollisionHeight=15.380000
     Mass=10.000000
     Buoyancy=12.000000
     DrawScale=0.750000
     PrePivot=(Z=20.500000)
//     Skins[0]=Texture'DeusExDeco.Skins.SignFloorTex1'
}
