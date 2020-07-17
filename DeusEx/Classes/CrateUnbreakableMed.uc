//=============================================================================
// CrateUnbreakableMed.
//=============================================================================
class CrateUnbreakableMed extends MetalBoxes;

defaultproperties
{
     bBlockSight=True
     bInvincible=True
     bFlammable=False
     ItemName="Metal Crate"
//     mesh=mesh'DeusExDeco.CrateUnbreakableMed'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Crates.Scripted.CrateUnbreakableMed_SM'
     CollisionRadius=45.200001
     CollisionHeight=32.000000
     Mass=80.000000
     Buoyancy=90.000000
     Skins[0]=Shader'DXR_Crates.Metal.CrateUnbreakableMed_SH'
//     Skins[0]=Texture'DeusExDeco.Skins.CrateUnbreakableMedTex1'
}



