//=============================================================================
// CrateExplosiveSmall.
//=============================================================================
class CrateExplosiveSmall extends MetalBoxes;

defaultproperties
{
   bBlockSight=True
   HitPoints=4
   bExplosive=True
   explosionDamage=300
   explosionRadius=800.000000
   ItemName="TNT Crate"
//    mesh=mesh'DeusExDeco.CrateExplosiveSmall'
   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DeusExStaticMeshes0.CrateExplosiveSmall_HD'
   CollisionRadius=22.500000
   CollisionHeight=16.000000
   Mass=30.000000
   Buoyancy=40.000000
//    Skins[0]=Texture'DeusExDeco.Skins.CrateExplosiveSmallTex1'
}



