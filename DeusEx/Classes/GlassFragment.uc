//=============================================================================
// GlassFragment.
//=============================================================================
class GlassFragment extends DeusExFragment;

defaultproperties
{
     elasticity=0.300000
/*     Fragments(0)=Mesh'DeusExItems.GlassFragment1'
     Fragments(1)=Mesh'DeusExItems.GlassFragment2'
     Fragments(2)=Mesh'DeusExItems.GlassFragment3'*/

     SFragments(0)=StaticMesh'BallisticHardware2.Glass.GlassFragC'
     SFragments(1)=StaticMesh'BallisticHardware2.Glass.GlassFragB'
     SFragments(2)=StaticMesh'BallisticHardware2.Glass.GlassFragA'
     numFragmentTypes=3
     ImpactSound=Sound'DeusExSounds.Generic.GlassHit1'
     MiscSound=Sound'DeusExSounds.Generic.GlassHit2'
     Mesh=Mesh'DeusExItems.GlassFragment1'
     CollisionRadius=6.000000
     CollisionHeight=0.000000
     Mass=5.000000
     Buoyancy=4.000000
}