//=============================================================================
// ElectricityEmitter.
//=============================================================================
class ElectricityEmitter extends EM_LaserBeam;

#exec OBJ LOAD FILE=Effects
#exec OBJ LOAD FILE=Ambient

var() float randomAngle;            // random amount to change yaw/pitch
var() int damageAmount;             // how much damage does this do?
var() float damageTime;             // how often does this do damage?
var() texture beamTexture;          // texture for beam
var() bool bInitiallyOn;            // is this initially on?
var() bool bFlicker;                // randomly flicker on and off?
var() float flickerTime;            // how often to check for random flicker?
var() bool bEmitLight;              // should I cast light, also?
var bool bFrozen;

var Actor lastHitActor;
var float lastDamageTime;
var float lastFlickerTime;
var bool bAlreadyInitialized;       // has this item been init'ed yet?

function CalcTrace(float deltaTime)
{
    local vector StartTrace, EndTrace, HitLocation, HitNormal;
    local Rotator rot;
    local actor target;
    local int texFlags;
    local name texName, texGroup;
//    local DeusExHUD hud;

//    hud = DeusExHUD(level.GetLocalPlayerController().myHUD);

    if (!bHiddenBeam)
    {
        // set up the random beam stuff
//        rot.Pitch = Int((0.5 - FRand()) * randomAngle);
//        rot.Yaw = Int((0.5 - FRand()) * randomAngle);
        rot.Roll = Int((0.5 - FRand()) * randomAngle);

        StartTrace = Location;
        EndTrace = Location + InitDist * vector(Rotation + rot);
        HitActor = None;

        foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace, StartTrace)
        {
            if ((target.DrawType == DT_None) || target.bHidden)
            {
                // do nothing - keep on tracing
            }
            else if ((target == Level) || target.IsA('Mover'))
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
        lastDamageTime += deltaTime;

        // shock whatever gets in the beam
        if ((HitActor != None) && (lastDamageTime >= damageTime))
        {
            HitActor.TakeDamage(damageAmount, Instigator, HitLocation, vect(0,0,0), class'DM_Shocked');
            lastDamageTime = 0;
        }
    SetBeamLength(Abs(vSize(Location - HitLocation)));
    SetRotation(rot + Rotation); // ������� ������ �����

// Used for debugging.
//    hud.DebugConString = "Beam length ="@BeamEmitter(Emitters[0]).BeamDistanceRange.Min $ "  HitLocation = " $ HitLocation @"PlayerLocation = "$ level.GetLocalPlayerController().pawn.Location;
    }
}

function TurnOn()
{
    Super.TurnOn();

    if (bEmitLight)
    {
        LightType = LT_Steady;
        bDynamicLight=true;
    }
}

function TurnOff()
{
    Super.TurnOff();

    if (bEmitLight)
    {
        LightType = LT_None;
        bDynamicLight = false;
    }
}

event SetInitialState()
{
    Super.SetInitialState();

    BeamEmitter(Emitters[0]).Texture = beamTexture;

    if (bAlreadyInitialized)
        return;

    if (bInitiallyOn)
    {
        bIsOn = False;
        TurnOn();
    }
    else
    {
        bIsOn = True;
        TurnOff();
    }

    bAlreadyInitialized = True;
}

event Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    if (bIsOn && !bFrozen && bFlicker)
    {
        lastFlickerTime += deltaTime;

        if (lastFlickerTime >= flickerTime)
        {
            lastFlickerTime = 0;
            if (FRand() < 0.5)
            {
                SetHiddenBeam(True);
                SoundVolume = 0;
                if (bEmitLight)
                    LightType = LT_None;
            }
            else
            {
                SetHiddenBeam(False);
                SoundVolume = 128;
                if (bEmitLight)
                    LightType = LT_Steady;
            }
        }
    }
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
    Super.Trigger(Other, Instigator);

    TurnOn();
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
    Super.UnTrigger(Other, Instigator);

    TurnOff();
}



defaultproperties
{
     DrawScale=1.0
     randomAngle=8192.000000
     DamageAmount=2
     damageTime=0.200000
     beamTexture=FireTexture'Effects.Electricity.Nano_SFX'
     bInitiallyOn=True
     bFlicker=True
     flickerTime=0.020000
     bEmitLight=True
     bRandomBeam=True
     AmbientSound=Sound'Ambient.Ambient.Electricity4'
     bDirectional=True
     Texture=Texture'Engine.S_Inventory' // �������� (c ��c������ :))
     SoundRadius=64
     LightBrightness=128
     LightHue=150
     LightSaturation=32
     LightRadius=6

    Begin Object Class=BeamEmitter Name=BeamEmitter2
        BeamDistanceRange=(Min=512.000000,Max=512.000000)
        DetermineEndPointBy=PTEP_Distance
        BeamTextureUScale=8.000000
        RotatingSheets=3 
        // Not required anymore, rotate actor itself instead.
        // LowFrequencyNoiseRange=(X=(Min=-128.000000,Max=128.000000),Y=(Min=-128.000000,Max=128.000000),Z=(Min=-128.000000,Max=128.000000))
        LowFrequencyPoints=2
        HighFrequencyNoiseRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-5.000000,Max=5.000000))
        HighFrequencyPoints=15
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(R=192))
        ColorScale(1)=(RelativeTime=0.500000,Color=(B=64,G=64,R=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(R=192))
        ColorMultiplierRange=(X=(Min=0.500000),Y=(Min=0.500000),Z=(Min=0.500000))
        MaxParticles=1
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.200000))
        ScaleSizeByVelocityMax=1000000.000000
        InitialParticlesPerSecond=5000.000000
        Texture=FireTexture'Effects.Laser.LaserBeam1'
        LifetimeRange=(Min=0.020000,Max=0.020000)
        StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
        TriggerDisabled=true // false ??
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter2'
}
