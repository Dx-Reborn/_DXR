//=============================================================================
// CrateBreakableMedMedical.
//=============================================================================
class CrateBreakableMedMedical extends BoxesWithStuff;

// From HardCoreDX mod...
auto state Active
{
   function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
   {
       if ((damageType == class'DM_Shot') || (damageType == class'DM_Decapitated'))
       {
           PlayWoodHitSounds();
       }
       Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
   }
}

function OnFrag()
{
   stub.PlayWoodHitSounds();
}


defaultproperties
{
   bBlockSight=true
   HitPoints=10
   FragType=Class'DeusEx.WoodFragment'
   ItemName="Medical Supply Crate"
   contents=Class'DeusEx.MedKit'
//     skins[0]=Texture'DeusExDeco.Skins.CrateBreakableMedTex1'
//     mesh=mesh'DeusExDeco.CrateBreakableMed'
   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DXR_Crates.Scripted.CrateBreakableMed_HD'
   Skins[0]=Shader'DXR_Crates.Wood.BreakableMedMedical_SH'
   CollisionRadius=34.000000
   CollisionHeight=24.000000
   Mass=50.000000
   Buoyancy=60.000000
   SurfaceType=EST_Wood
}
