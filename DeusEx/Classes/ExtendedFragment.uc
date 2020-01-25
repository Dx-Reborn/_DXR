//=============================================================================
// ExtendedFragment
// by -SkrillaX-
//=============================================================================
class ExtendedFragment extends Fragment;

var bool bSmoking;
var Vector lastHitLoc;
var float LF;
var float smokeTime;
var ParticleGenerator smokeGen;

var() bool bKeepForever; // New
var() float Elasticity;
var() float    Speed;               // Initial speed of projectile.
var() float    MaxSpeed;            // Limit on speed of projectile (0 means no limit)
var   sound	   MiscSound;		

//
// copied from Engine.Fragment
//
simulated function HitWall (vector HitNormal, actor HitWall)
{
	local Sound sound;
	local float volume, radius;

	// if we are stuck, stop moving
	if (lastHitLoc == Location)
		Velocity = vect(0,0,0);
	else
		Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	speed = VSize(Velocity);	
	if (bFirstHit && speed<400) 
	{
		bFirstHit=False;
		bRotatetoDesired=True;
		bFixedRotationDir=False;
		DesiredRotation.Pitch=0;	
		DesiredRotation.Yaw=FRand()*65536;
		DesiredRotation.roll=0;
	}
	RotationRate.Yaw = RotationRate.Yaw*0.75;
	RotationRate.Roll = RotationRate.Roll*0.75;
	RotationRate.Pitch = RotationRate.Pitch*0.75;
	if ( ( (speed < 60) && (HitNormal.Z > 0.7) ) || (speed == 0) )
	{
		class'ActorManager'.static.SetPhysicsEx(self,PHYS_none, HitWall);
		if (Physics == PHYS_None)
		{
			bBounce = false;
			GoToState('Dying');
		}
	}

	volume = 0.5+FRand()*0.5;
	radius = 768;
	if (FRand()<0.5)
		sound = ImpactSound;
	else
		sound = MiscSound;
	PlaySound(sound, SLOT_None, volume,, radius, (0.85+FRand()*0.3)); // * DeusExPlayer(GetPlayerPawn()));//.GetSoundPitchMultiplier());
	if (sound != None)
		class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, volume, radius * 0.5);		// lower AI sound radius for gameplay balancing
	lastHitLoc = Location;
}

state Dying
{
	simulated function HitWall (vector HitNormal, actor HitWall)
	{
		// if we are stuck, stop moving
		if (lastHitLoc == Location)
			Velocity = vect(0,0,0);
		else
			Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
		speed = VSize(Velocity);	
		if (bFirstHit && speed<400) 
		{
			bFirstHit=False;
			bRotatetoDesired=True;
			bFixedRotationDir=False;
			DesiredRotation.Pitch=0;	
			DesiredRotation.Yaw=FRand()*65536;
			DesiredRotation.roll=0;
		}
		RotationRate.Yaw = RotationRate.Yaw*0.75;
		RotationRate.Roll = RotationRate.Roll*0.75;
		RotationRate.Pitch = RotationRate.Pitch*0.75;
		if ( (Velocity.Z < 50) && (HitNormal.Z > 0.7) )
		{
			class'ActorManager'.static.SetPhysicsEx(self,PHYS_none, HitWall);
			if (Physics == PHYS_None)
				bBounce = false;
		}

		if (FRand()<0.5)
			PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 512, (0.85+FRand()*0.3));// * DeusExPlayer(GetPlayerPawn()).GetSoundPitchMultiplier());
		else
			PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, (0.85+FRand()*0.3));// * DeusExPlayer(GetPlayerPawn()).GetSoundPitchMultiplier());
		lastHitLoc = Location;
	}
	function BeginState()
	{
		Super.BeginState();
	//	if (smokeGen != None)
		//	smokeGen.DelayedDestroy();
	}
}
function Destroyed()
{
//	if (smokeGen != None)
//		smokeGen.DelayedDestroy();
	Super.Destroyed();
}

function PostBeginPlay()
{
     local DeusExPlayer player;

     Super.PostBeginPlay();
     player = DeusExPlayer(GetPlayerPawn());

     if (player != none) //.bNoResurrection)
     {
     	if(bKeepForever)
     		  LifeSpan = 999999;
     	else
     	{
        	LifeSpan=4.000000;
          LifeSpan += FRand()*4.0;
     	}
     }
     else
     {
     	if(bKeepForever)
     		  LifeSpan = 999999;
     	else
     	{
        	LifeSpan=15.000000;
			    LifeSpan += FRand()*4.0;
     	}
     }
}

simulated function AddSmoke()
{
/*	smokeGen = Spawn(class'ParticleGenerator', Self);
	if (smokeGen != None)
	{
		smokeGen.particleTexture = Texture'WhiteStatic';
		smokeGen.particleDrawScale = 0.15;
		smokeGen.riseRate = 10.0;
		smokeGen.ejectSpeed = 0.0;
		smokeGen.particleLifeSpan = 1.0;
		smokeGen.bRandomEject = True;
		smokeGen.SetBase(Self);
	}*/
}

simulated function Tick(float deltaTime)
{
   if ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority))
      return;
	if (bSmoking && !IsInState('Dying') && (smokeGen == None))
		AddSmoke();
	// fade out the object smoothly 2 seconds before it dies completely
	if (LifeSpan <= 2)
	{
		if (Style != STY_Translucent)
			Style = STY_Translucent;
		ScaleGlow = LifeSpan / 2.0;
	}
}

function pawn GetPlayerPawn()
{
  return Level.GetLocalPlayerController().Pawn;
}


defaultproperties
{
     LifeSpan=15.000000
}