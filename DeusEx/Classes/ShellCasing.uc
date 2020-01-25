//=============================================================================
// ShellCasing.
//=============================================================================
class ShellCasing extends DeusExFragment;

defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_Decals.Shell_Generic'
     DrawScale=0.2
//     Fragments(0)=Mesh'DeusExItems.ShellCasing'
//     Mesh=Mesh'DeusExItems.ShellCasing'
//     numFragmentTypes=1
     numFragmentTypes=0
     elasticity=0.400000

     ImpactSound=Sound'DeusExSounds.Generic.ShellHit'
     MiscSound=Sound'DeusExSounds.Generic.ShellHit'

     CollisionRadius=0.600000
     CollisionHeight=0.300000
}
