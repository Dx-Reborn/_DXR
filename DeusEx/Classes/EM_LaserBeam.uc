/*
   A laser beam. Used for LaserTrigger and laser sight.
*/

class EM_LaserBeam extends DeusExEmitter;

var LaserSpot spot[2];          // max of 2 reflections
var bool bIsOn;
var actor HitActor;
//var bool bFrozen;               // are we out of the player's sight?
var bool bRandomBeam;
var bool bBlueBeam;             // is this beam blue?
var bool bHiddenBeam;           // is this beam hidden?
var float InitDist;

function SetBeamLength(int Length)
{
      BeamEmitter(Emitters[0]).BeamDistanceRange.Min = Length;
      BeamEmitter(Emitters[0]).BeamDistanceRange.Max = Length;
}

function CalcTrace(float deltaTime)
{
    local vector StartTrace, EndTrace, HitLocation, HitNormal;
    local actor target;
    local int texFlags;
    local name texName, texGroup;

    StartTrace = Location;
    EndTrace = Location + InitDist * vector(Rotation);
    HitActor = None;

      foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace, StartTrace)
      {
            if ((target.DrawType == DT_None) || target.bHidden)
            {
                // do nothing - keep on tracing
            }
            else if ((target == Level) || target.IsA('Mover') || (target.bWorldGeometry)) //target.IsA('StaticMeshActor') || target.IsA('TerrainInfo'))
            {
                break;
            }
            else
            {
                if (target != none)
                    HitActor = target;
                break;
            }

      }
      SetBeamLength(Abs(vSize(Location - HitLocation)));

        if (spot[0] == None)
        {
            spot[0] = Spawn(class'LaserSpot', Self, , HitLocation, Rotator(HitNormal));
            if (bBlueBeam && (spot[0] != None))
                spot[0].Texture = Texture'LaserSpot2';
        }
        else
        {
            spot[0].SetLocation(HitLocation);
            spot[0].SetRotation(Rotator(HitNormal));
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
        Emitters[0].Disabled = false;
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

        Emitters[0].Disabled = true;
    }
}

event Destroyed()
{
    TurnOff();
    Kill();
    Super.Destroyed();
}

event Tick(float deltaTime)
{
    if (bIsOn)
        CalcTrace(deltaTime);
}

function SetBlueBeam()
{
    bBlueBeam = True;
    BeamEmitter(Emitters[0]).Texture = Texture'LaserBeam2';
}

function SetHiddenBeam(bool bHide)
{
    bHiddenBeam = bHide;
    if (bHiddenBeam)
        BeamEmitter(Emitters[0]).Opacity = 0.0;
    else
        BeamEmitter(Emitters[0]).Opacity = 1.0;
/*  if (proxy != None)
        proxy.bHidden = bHide;*/
}



defaultproperties
{
    initDist=5000

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