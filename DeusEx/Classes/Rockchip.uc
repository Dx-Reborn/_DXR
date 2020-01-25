//=============================================================================
// Rockchip.
//=============================================================================
class Rockchip extends DeusExFragment;


auto state Flying
{
	simulated function BeginState()
	{
		Super.BeginState();

		Velocity = VRand() * 100;
		SetDrawScale((DrawScale * 0.1) + FRand() * 0.25);
	}
}


defaultproperties
{
     elasticity=0.400000
     Fragments(0)=Mesh'DeusExItems.Rockchip1'
     Fragments(1)=Mesh'DeusExItems.Rockchip2'
     Fragments(2)=Mesh'DeusExItems.Rockchip3'
     numFragmentTypes=3
     ImpactSound=Sound'DeusExSounds.Generic.RockHit1'
     MiscSound=Sound'DeusExSounds.Generic.RockHit2'
     Mesh=Mesh'DeusExItems.Rockchip1'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
