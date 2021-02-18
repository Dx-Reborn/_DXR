//=============================================================================
// Vase2.
//=============================================================================
class Vase2a extends DeusExDecoration;

defaultproperties
{
     FragType=Class'DeusEx.GlassFragment'
     ItemName="Vase"
//     mesh=mesh'DeusExDeco.Vase2'
     CollisionRadius=7.540000
     CollisionHeight=5.080000
     Mass=20.000000
     Buoyancy=15.000000
//     Skins[0]=Texture'DeusExDeco.Skins.Vase2Tex1'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.Vase2a_HD'
     Skins[0]=Shader'DeusExStaticMeshes0.Glass.Vase2a_HD_SH'
}

