//=============================================================================
// Fire.
// œŒ◊≈Ã” “€ “¿ Œ…  –»¬”Ÿ»…!!!!!!!!!!!!11111111111111111111111111111111111111111111111111111????????????
//=============================================================================
class Fire extends Effects;

var EM_BlackSmoke smokeGen;
var EM_FireA			fireGen;
var Actor 				origBase;

#exec OBJ LOAD FILE=Ambient
#exec OBJ LOAD FILE=Effects
#exec OBJ LOAD FILE=Effects_EX // ¯ÂÈ‰Â˚

simulated function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	// if our owner or base is destroyed, destroy us
	if (Owner == None)
  	Destroy();

  If (firegen==none)
  	AmbientSound=none;
}

simulated function SetInitialState()
{
	Super.SetInitialState();

	SetBase(Owner);
	origBase = Owner;

  SpawnSmokeEffects();
}

simulated function BaseChange()
{
	Super.BaseChange();

	if (Base == None)
		SetBase(origBase);
}

simulated event Destroyed()
{
	if (smokeGen != None)
		{
			smokeGen.Emitters[0].Disabled = true;
			smokeGen.lifespan=1;
			smokeGen.Kill(); // somebody kill me!
		}

	if (fireGen != None)
		{
			FireGen.Emitters[0].Disabled = true;
			fireGen.lifespan=1;
			firegen.kill();
		}

//		log("Fire Destroyed");

	Super.Destroyed();
}

simulated function SpawnSmokeEffects()
{
	smokeGen = Spawn(class'EM_BlackSmoke', Self,, Location, rot(16384,0,0));
	if (smokeGen != None)
	{
		smokeGen.SetBase(Self);
	}
}

simulated function AddFire(optional float fireLifeSpan)
{
	if (fireLifeSpan == 0.0)
		fireLifeSpan = 0.5;

	if (fireGen == None)
	{
		fireGen = Spawn(class'EM_FireA', Self,, Location, rot(16384,0,0));
		if (fireGen != None)
		{
			fireGen.Emitters[0].LifeTimeRange.Max=fireLifeSpan;
			fireGen.Emitters[0].LifeTimeRange.Min=fireLifeSpan - 0.1;
			fireGen.SetBase(Self);
		}
	}
}

defaultproperties
{
	   DrawType=DT_None
     AmbientSound=Sound'Ambient.Ambient.FireSmall1'
     Style=STY_Translucent
     Texture=FireTexture'Effects.Fire.OnFire_J'
     SoundVolume=192

	   bMovable=True
  	 bStatic=false
		 bFullVolume=true
}
