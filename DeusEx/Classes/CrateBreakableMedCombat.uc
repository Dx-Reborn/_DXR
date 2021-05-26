//=============================================================================
// CrateBreakableMedCombat.
//=============================================================================
class CrateBreakableMedCombat extends BoxesWithStuff;

// From HardCoreDX mod...
auto state Active
{
   function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
   {
       if ((damageType == class'DM_Shot') || (damageType == class'DM_Decapitated'))
       {
           stub.PlayWoodHitSounds(1.0);
       }
       Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
   }
}

defaultproperties
{
   bBlockSight=true
   HitPoints=10
//   FragType=Class'DeusEx.WoodFragment'
   FragType=class'DeusEx.CrateBreakableFragment'
   ItemName="Combat Supply Crate"
   contents=Class'DeusEx.Ammo10mm'
//     skins[0]=Texture'DeusExDeco.Skins.CrateBreakableMedTex3'
//     mesh=mesh'DeusExDeco.CrateBreakableMed'
   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DXR_Crates.Scripted.CrateBreakableMed_HD'
   Skins[0]=Shader'DXR_Crates.Wood.BreakableMedCombat_SH'
   CollisionRadius=34.000000
   CollisionHeight=24.000000
   Mass=50.000000
   Buoyancy=60.000000
   SurfaceType=EST_Wood
}
