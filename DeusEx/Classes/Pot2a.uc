//=============================================================================
// Pot2.
//=============================================================================
class Pot2a extends DeusExDecoration;

defaultproperties
{
     bCanBeBase=True
     ItemName="Clay Pot"
//     mesh=mesh'DeusExDeco.Pot2'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.Pot2a_HD'
     CollisionRadius=7.980000
     CollisionHeight=13.000000
     Mass=20.000000
     Buoyancy=5.000000
//     Skins[0]=Texture'DeusExDeco.Skins.Pot2Tex1'
     Skins[0]=Shader'DeusExStaticMeshes0.Glass.Pot2a_HD_SH'
}
