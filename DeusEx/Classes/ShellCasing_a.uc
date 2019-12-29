//=============================================================================
// ShellCasing2.
// Для дробовиков
// Примечание: класс переименован (было ShellCasing2)
//=============================================================================
class ShellCasing_a extends DeusExFragment;

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Decals.Shell_ShotGun'
     DrawScale=0.2
//     Fragments(0)=Mesh'DeusExItems.ShellCasing2'
//     Mesh=Mesh'DeusExItems.ShellCasing2'
//     numFragmentTypes=1
     numFragmentTypes=0
     elasticity=0.400000

     ImpactSound=Sound'STALKER_Sounds.Hit.ShotGunShellImpact'
     MiscSound=Sound'STALKER_Sounds.Hit.ShotGunShellImpact'

     CollisionRadius=2.570000
     CollisionHeight=0.620000
}
