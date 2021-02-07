//=============================================================================
// ShellCasing2.
// Для дробовиков
// Примечание: класс переименован (было ShellCasing2)
//=============================================================================
class ShellCasing_a extends DeusExFragment;

var EM_ShellTrail trail;

event SetInitialState()
{
   trail = Spawn(class'EM_ShellTrail',self,'',Location);
   trail.SetPhysics(PHYS_Trailer);
}

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Decals.Shell_ShotGun'
     DrawScale=0.2
     numFragmentTypes=0
     elasticity=0.400000

     ImpactSound=Sound'STALKER_Sounds.Hit.ShotGunShellImpact'
     MiscSound=Sound'STALKER_Sounds.Hit.ShotGunShellImpact'

     CollisionRadius=2.570000
     CollisionHeight=0.620000

     bUnlit=false
}
