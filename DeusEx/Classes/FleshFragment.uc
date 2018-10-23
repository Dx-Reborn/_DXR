//=============================================================================
// FleshFragment.
//=============================================================================
class FleshFragment extends DeusExFragment;

auto state Flying
{
	simulated function BeginState()
	{
		Super.BeginState();

		Velocity = VRand() * 300;
		SetDrawScale(FRand() + 1.5);
	}
}

simulated function Tick(float deltaTime)
{
	Super.Tick(deltaTime);
	
/*	if (!IsInState('Dying'))
		if (FRand() < 0.5)
			Spawn(class'BloodSplatterPurple',,, Location);*/
}


defaultproperties
{
     elasticity=0.400000
     bVisionImportant=True
     Fragments(0)=Mesh'DeusExItems.FleshFragment1'
     Fragments(1)=Mesh'DeusExItems.FleshFragment2'
     Fragments(2)=Mesh'DeusExItems.FleshFragment3'
     Fragments(3)=Mesh'DeusExItems.FleshFragment4'
     numFragmentTypes=4
     ImpactSound=Sound'DeusExSounds.Generic.FleshHit1'
     MiscSound=Sound'DeusExSounds.Generic.FleshHit2'
     Mesh=Mesh'DeusExItems.FleshFragment1'
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     Mass=5.000000
     Buoyancy=5.500000
}
