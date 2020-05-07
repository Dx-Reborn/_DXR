//=============================================================================
// ShellCasing.
//=============================================================================
class ShellCasing extends DeusExFragment;

var EM_SmallShellTrail trail;

event SetInitialState()
{
   trail = Spawn(class'EM_SmallShellTrail',self,'',Location);
   trail.SetPhysics(PHYS_Trailer);
}


defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Decals.Shell_Generic'
     DrawScale=0.2

     numFragmentTypes=0
     elasticity=0.400000

     ImpactSound=Sound'DeusExSounds.Generic.ShellHit'
     MiscSound=Sound'DeusExSounds.Generic.ShellHit'

     CollisionRadius=0.600000
     CollisionHeight=0.300000
}
