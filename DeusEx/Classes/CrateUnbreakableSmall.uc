//=============================================================================
// CrateUnbreakableSmall.
//=============================================================================
class CrateUnbreakableSmall extends MetalBoxes;


defaultproperties
{
     bBlockSight=True
     bInvincible=True
     bFlammable=False
     ItemName="Metal Crate"
//     mesh=mesh'DeusExDeco.CrateUnbreakableSmall'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     Mass=40.000000
     Buoyancy=50.000000
//     Skins[0]=Texture'DeusExDeco.Skins.CrateUnbreakableSmallTex1'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Crates.CrateUnbreakableSmall_SM'
     Skins[0]=Shader'DXR_Crates.Metal.CrateUnbreakableSmall_SH'
}
