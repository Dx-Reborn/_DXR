//=============================================================================
// AirBubble.
//=============================================================================
class AirBubble extends Effects;

var() float RiseRate;
var vector OrigVel;

auto state flying
{
	simulated function Tick(float deltaTime)
	{
		Velocity.X = OrigVel.X + 8 - FRand() * 17;
		Velocity.Y = OrigVel.Y + 8 - FRand() * 17;
		Velocity.Z = RiseRate * (FRand() * 0.2 + 0.9);

    if (!TouchingWaterVolume())
        Destroy();
	}

	simulated function BeginState()
	{
		Super.BeginState();

		OrigVel = Velocity;
		SetDrawScale(FRand() * 0.1);
		LifeSpan = 1 + 2 * FRand();
	}


  function bool TouchingWaterVolume()
  {
	  local PhysicsVolume V;

	  ForEach TouchingActors(class'PhysicsVolume',V)
		  if (V.bWaterVolume)
			     return true;

	     return false;
   }
}



defaultproperties
{
     RiseRate=50.000000
     LifeSpan=10.000000
     Style=STY_Translucent
     DrawType=DT_Sprite
     Texture=Texture'DeusExItems.Skins.FlatFXTex45'
     DrawScale=0.050000
		 CollisionRadius=1.00000
		 CollisionHeight=1.00000
     Buoyancy=5.000000
}