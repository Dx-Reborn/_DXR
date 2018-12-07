//=============================================================================
// BloodDrop.
//=============================================================================
class BloodDrop extends DeusExFragment;

auto state Flying
{
	simulated function HitWall(vector HitNormal, actor Wall)
	{
		spawn(class'BloodSplat',,, Location, Rotator(HitNormal));
		Destroy();
	}

	simulated function BeginState()
	{
		Velocity = VRand() * 100;
		SetDrawScale(1.0 + FRand());
		SetRotation(Rotator(Velocity));

		// Gore check
		if (Level.Game.bLowGore)
		{
			Destroy();
			return;
		}
	}
}

simulated function Tick(float deltaTime)
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
     Style=STY_Modulated
     Mesh=Mesh'DeusExItems.BloodDrop'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bBounce=False
     NetPriority=1.000000
     NetUpdateFrequency=5.000000
}
