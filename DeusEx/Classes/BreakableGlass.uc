//=============================================================================
// BreakableGlass.
//=============================================================================
class BreakableGlass extends DeusExMover;

defaultproperties
{
     bBlockSight=False
     bOwned=True
     bPickable=False
     bBreakable=True
     doorStrength=0.100000
     bHighlight=False
     bFrobbable=False
     minDamageThreshold=3
     NumFragments=10
     FragmentScale=1.000000
     FragmentSpread=16
     FragmentClass=Class'DeusEx.GlassFragment'
     bFragmentTranslucent=True
     ExplodeSound1=Sound'DeusExSounds.Generic.GlassBreakSmall'
     ExplodeSound2=Sound'DeusExSounds.Generic.GlassBreakLarge'
     bPathColliding=true
}
