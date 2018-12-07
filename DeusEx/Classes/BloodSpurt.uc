//=============================================================================
// BloodSpurt.
//=============================================================================
class BloodSpurt extends Effects;

auto state Flying
{
	simulated function BeginState()
	{
		Velocity = vect(0,0,0);
		SetDrawScale(FRand() * 0.5); // -=
		PlayAnim('Spurt');

		// Gore check
		if (Level.Game.bLowGore)
		{
			Destroy();
			return;
		}
	}
}


defaultproperties
{
     LifeSpan=0.500000
     Style=STY_Modulated
     Mesh=Mesh'DeusExItems.BloodSpurt'
     bFixedRotationDir=True
     NetUpdateFrequency=5.000000
}
