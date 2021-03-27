//=============================================================================
// RoadBlock.
//=============================================================================
class RoadBlock extends DeusExDecoration;

defaultproperties
{
     HitPoints=75
     minDamageThreshold=75
     FragType=Class'DeusEx.Rockchip'
     ItemName="Concrete Barricade"
//     mesh=mesh'DeusExDeco.RoadBlock'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.RoadBlock_HD'
     CollisionRadius=33.000000
     CollisionHeight=23.400000
     Mass=200.000000
     Buoyancy=50.000000
//     Skins[0]=Texture'DeusExDeco.Skins.RoadBlockTex1'
//     Skins[0]=Texture'DeusExStaticMeshes0.Stone.roadblock_HD_Tex'
}