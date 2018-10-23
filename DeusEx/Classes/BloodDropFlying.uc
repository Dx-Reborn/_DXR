//=============================================================================
// BloodDropFlying.
//=============================================================================
class BloodDropFlying extends DeusExFragment;

auto state Flying
{
	function HitWall(vector HitNormal, actor Wall)
	{
		spawn(class'BloodSplat',,, Location, Rotator(HitNormal));
		Destroy();
	}
	function BeginState()
	{
		Velocity = VRand() * 270; //CyberP: faster blood
		Velocity.Z = FRand() * 350 + 350; //so blood hits the ceiling
		SetDrawScale(1.5 + (FRand()*2.3));
		SetRotation(Rotator(Velocity));

		// Gore check
		if (Level.Game.bLowGore) // || Level.Game.bVeryLowGore)
		{
			Destroy();
			return;
		}
	}
}

function Tick(float deltaTime)
{
	if (Velocity == vect(0,0,0))
	{
		spawn(class'BloodSplat',,, Location, rot(16384,0,0));
		Destroy();
	}
	else
		SetRotation(Rotator(Velocity));
}


defaultproperties
{
    Style=4
    Mesh=LodMesh'DeusExItems.BloodDrop'
    CollisionRadius=0.00
    CollisionHeight=0.00
    bBounce=False
}