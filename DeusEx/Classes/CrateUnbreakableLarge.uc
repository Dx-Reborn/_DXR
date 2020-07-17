//=============================================================================
// CrateUnbreakableLarge.
//=============================================================================
class CrateUnbreakableLarge extends MetalBoxes;

defaultproperties
{
     bBlockSight=True
     bInvincible=True
     bFlammable=False
     ItemName="Metal Crate"
//     mesh=mesh'DeusExDeco.CrateUnbreakableLarge'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Crates.Scripted.CrateUnbreakableLarge_SM'
     CollisionRadius=56.500000
     CollisionHeight=56.000000
     Mass=150.000000
     Buoyancy=160.000000
     Skins[0]=Shader'DXR_Crates.Metal.CrateUnbreakableLarge_SH'
//     Skins[0]=Texture'DeusExDeco.Skins.CrateUnbreakableLargeTex1'
}