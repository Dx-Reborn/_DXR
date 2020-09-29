//=============================================================================
// AugLight.
// Здесь был Projector, который засвечивал альфа-канал у текстур и включал
// собой все триггеры которых касался :(
//=============================================================================
class AugLight extends Augmentation;

var Beam b1, b2;
var LightProjector AL;

/* Уничтожение источников света обрабатывается через DXRSaveSystem */
/*function PreTravel() // called from DeusExPlayerController
{
    // make sure we destroy the light before we travel
    if (b1 != None)
        b1.Destroy();
    if (b2 != None)
        b2.Destroy();
    if (AL != None)
        AL.Destroy();
    b1 = None;
    b2 = None;
    AL = None;
} */

function UpdateProjector()
{
    local Vector loc;

    loc = Player.Location;
    loc.z = loc.z + Player.EyeHeight;

    if (AL != none)
    {
       AL.SetRotation(Player.GetViewRotation());
       AL.SetLocation(loc);
    }
}

function SetBeamLocation()
{
    local float dist, size, radius, brightness;
    local Vector HitNormal, HitLocation, StartTrace, EndTrace;

    if (b1 != None)
    {
        StartTrace = Player.Location;
        StartTrace.Z += Player.BaseEyeHeight;
        EndTrace = StartTrace + LevelValues[CurrentLevel] * Vector(Player.GetViewRotation());

        Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);
        if (HitLocation == vect(0,0,0))
            HitLocation = EndTrace;

        dist       = VSize(HitLocation - StartTrace);
        size       = fclamp(dist/LevelValues[CurrentLevel], 0, 1);
        radius     = size*5.12 + 4.0;
        brightness = fclamp(size-0.5, 0, 1)*2*-192 + 192;
        b1.SetLocation(HitLocation-vector(Player.GetViewRotation())*64);
        b1.LightRadius     = byte(radius);
        b1.LightType       = LT_Steady;
    }
}

function SetGlowLocation()
{
    local vector pos;

    if (b2 != None)
    {
        pos = Player.Location + vect(0,0,1)*Player.BaseEyeHeight +
              vect(1,1,0)*vector(Player.GetViewRotation())*Player.CollisionRadius*1.5;
        b2.SetLocation(pos);
    }
}

state Active
{
    event Tick(float deltaTime)
    {
        SetBeamLocation();
        SetGlowLocation();
        If (AL != none)
            UpdateProjector(); //
    }
    
    function BeginState()
    {
        Super.BeginState();

        AL = Spawn(class'LightProjector',Player,,Player.Location,Player.GetViewRotation());

        b1 = Spawn(class'Beam', Player, '', Player.Location);
        if (b1 != None)
        {
            class'EventManager'.static.AIStartEvent(self,'Beam', EAITYPE_Visual);
            b1.LightHue = 32;
            b1.LightRadius = 4;
            b1.LightSaturation = 140;
            b1.LightBrightness = 192;
            SetBeamLocation();
        }
        b2 = Spawn(class'Beam', Player, '', Player.Location);
        if (b2 != None)
        {
            b2.LightHue = 32;
            b2.LightRadius = 4;
            b2.LightSaturation = 140;
            b2.LightBrightness = 220;
            SetGlowLocation();
        }
    }

Begin:
}

function Deactivate()
{
    Super.Deactivate();
    if (b1 != None)
        b1.Destroy();
    if (b2 != None)
        b2.Destroy();

    if (AL != none)
        AL.Destroy();
    b1 = None;
    b2 = None;

    AL = None;
}

defaultproperties
{
    EnergyRate=10.00
    MaxLevel=0
    Icon=Texture'DeusExUI.UserInterface.AugIconLight'
    smallIcon=Texture'DeusExUI.UserInterface.AugIconLight_Small'
    AugmentationName="Light"
    InternalAugmentationName="Light"
    Description="Bioluminescent cells within the retina provide coherent illumination of the agent's field of view.||NO UPGRADES"
    LevelValues=1024.00
    AugmentationLocation=LOC_Default
}
