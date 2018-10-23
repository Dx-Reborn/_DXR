//=========================================
// A laser beam. Used for LaserTrigger
//=========================================

class EM_LaserBeam extends DeusExEmitter;

var LaserSpot spot[2];			// max of 2 reflections
var bool bIsOn;
var actor HitActor;
var bool bFrozen;				// are we out of the player's sight?
var bool bRandomBeam;
var bool bBlueBeam;				// is this beam blue?
var bool bHiddenBeam;			// is this beam hidden?

var float beamPlusCorrector;

function PostBeginPlay()
{
   super.PostBeginPlay();
     SetTimer(1.0, true);
}

function CalcTrace(float deltaTime)
{
	local vector StartTrace, EndTrace, HitLocation, HitNormal, Reflection;
	local actor target;
	local int i, texFlags;
	local name texName, texGroup;
//	local material material;

	StartTrace = Location;
	EndTrace = Location + 5000 * vector(Rotation);
	HitActor = None;

	// trace the path of the reflected beam and draw points at each hit
	for (i=0; i<ArrayCount(spot); i++)
	{
//    foreach TraceActors(class'Actor', target, HitLocation, HitNormal, EndTrace, StartTrace)
   	foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
		{
			if ((target.DrawType == DT_None) || target.bHidden)
			{
				// do nothing - keep on tracing
			}
			else if ((target == Level) || target.IsA('Mover') || target.IsA('StaticMeshActor') || target.IsA('TerrainInfo'))
			{
				break;
			}
			else
			{
				HitActor = target;
				break;
			}
		}

		// draw first beam
		if (i == 0)
		{
//			if (LaserIterator(RenderInterface) != None)
//				LaserIterator(RenderInterface).AddBeam(i, Location, Rotation, VSize(Location - HitLocation));
          BeamEmitter(Emitters[0]).BeamDistanceRange.Min=VSize(Location - HitLocation);
          BeamEmitter(Emitters[0]).BeamDistanceRange.Max=VSize(Location - HitLocation);
		}
		else
		{
//			if (LaserIterator(RenderInterface) != None)
//				LaserIterator(RenderInterface).AddBeam(i, StartTrace - HitNormal, Rotator(Reflection), VSize(StartTrace - HitLocation - HitNormal));
          BeamEmitter(Emitters[0]).BeamDistanceRange.Min=VSize(StartTrace - HitLocation - HitNormal);
          BeamEmitter(Emitters[0]).BeamDistanceRange.Max=VSize(StartTrace - HitLocation - HitNormal);

		}

		if (spot[i] == None)
		{
			spot[i] = Spawn(class'LaserSpot', Self, , HitLocation, Rotator(HitNormal));
			if (bBlueBeam && (spot[i] != None))
				spot[i].Texture = Texture'LaserSpot2'; /*Skins[0]*/
		}
		else
		{
			spot[i].SetLocation(HitLocation);
			spot[i].SetRotation(Rotator(HitNormal));
		}

		// Отражение вроде как работает, но выглядит странно, возможно нужно "сгибать" луч или создавать несколько эмиттеров...
		// don't reflect any more if we don't hit a mirror
		// 0x08000000 is the PF_Mirrored flag from UnObj.h
		if ((texFlags & /*0x08000000*/0x20000000) == 0)
		{
			// kill all of the other spots after this one
			if (i < ArrayCount(spot)-1)
			{
				do
				{
					i++;
					if (spot[i] != None)
					{
						spot[i].Destroy();
						spot[i] = None;
//						if (LaserIterator(RenderInterface) != None)
//							LaserIterator(RenderInterface).DeleteBeam(i);
					}
				} until (i>=ArrayCount(spot)-1);
			}
			return;
		}
		Reflection = MirrorVectorByNormal(Normal(HitLocation - StartTrace), HitNormal);
		StartTrace = HitLocation + HitNormal;
		EndTrace = Reflection * 10000;
	}
}

function TurnOn()
{
	if (!bIsOn)
	{
		bIsOn = True;
		HitActor = None;
		CalcTrace(0.0);
		if (!bHiddenBeam)
			BeamEmitter(Emitters[0]).Opacity=1.0;
		SoundVolume = 128;
		Resume(self);
	}
}

function TurnOff()
{
 local int i;

	if (bIsOn)
	{
		for (i=0; i<ArrayCount(spot); i++)
		{
			if (spot[i] != None)
			{
				spot[i].Destroy();
				spot[i] = None;
			}
		}

		HitActor = None;
		bIsOn = False;
		if (!bHiddenBeam)
			BeamEmitter(Emitters[0]).Opacity=0.1;
		SoundVolume = 0;
		Pause(self);
	}
}

function Destroyed()
{
	TurnOff();
	Kill();
	Super.Destroyed();
}

function Tick(float deltaTime)
//function Timer()
{
/*	local DeusExPlayer player;

	// check for visibility
	player = DeusExPlayer(GetPlayerPawn());*/

	if (bIsOn)
	{
/*		// if we are a weapon's laser sight, do not freeze us
		if ((Owner != None) && (Owner.IsA('Weapon') || Owner.IsA('ScriptedPawn')))
			bFrozen = False;
		else if (proxy != None)
		{
			// if we are close, say 60 feet
			if (proxy.DistanceFromPlayer < 960)
				bFrozen = False;
			else
			{
				// can the player see the generator?
				if (proxy.LastRendered() <= 2.0)
					bFrozen = False;
				else
					bFrozen = True;
			}
		}
		else
			bFrozen = True;

		if (bFrozen)
			return;*/

		CalcTrace(deltaTime);
//		CalcTrace(timerRate);
	}
}


function SetBlueBeam()
{
	bBlueBeam = True;
	BeamEmitter(Emitters[0]).Texture = Texture'LaserBeam2';
}

function SetHiddenBeam(bool bHide)
{
	bHiddenBeam = bHide;
	If (bHiddenBeam)
	BeamEmitter(Emitters[0]).Opacity=0.01;
	else
		BeamEmitter(Emitters[0]).Opacity=1.0;
/*	if (proxy != None)
		proxy.bHidden = bHide;*/
}



defaultproperties
{
    Begin Object Class=BeamEmitter Name=BeamEmitter1
        BeamDistanceRange=(Min=512.000000,Max=512.000000)
        DetermineEndPointBy=PTEP_Distance
        BeamTextureUScale=8.000000
        RotatingSheets=3
        LowFrequencyPoints=2
        HighFrequencyPoints=2
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(R=192))
        ColorScale(1)=(RelativeTime=0.500000,Color=(B=64,G=64,R=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(R=192))
        ColorMultiplierRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        MaxParticles=1
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.200000))
        ScaleSizeByVelocityMax=1000000.000000
        InitialParticlesPerSecond=5000.000000
        Texture=FireTexture'Effects.Laser.LaserBeam1'
        LifetimeRange=(Min=0.020000,Max=0.020000)
        StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter1'

    bDirectional=true
    DrawScale=0.1
    bFullVolume=true
    SoundRadius=16
    AmbientSound=Sound'Ambient.Ambient.Laser'
}