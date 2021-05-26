//=============================================================================
// AcousticSensor.
//=============================================================================
class AcousticSensor extends HackableDevices;

function HackAction(Actor Hacker, bool bHacked)
{
    Super.HackAction(Hacker, bHacked);

    if (bHacked)
        AIClearEventCallback('WeaponFire');
}

function NoiseHeard(Name eventName, EAIEventState state, XAIParams params)
{
    local Actor A;

    if (Event != '')
        foreach AllActors(class 'Actor', A, Event)
            A.Trigger(Self, GetPlayerPawn());
}

event PostBeginPlay()
{
    Super.PostBeginPlay();

    AISetEventCallback('WeaponFire', 'NoiseHeard');
}

event PostLoadSavedGame()
{
    Super.PostLoadSavedGame();
    AISetEventCallback('WeaponFire', 'NoiseHeard');
}

function Pawn GetPlayerPawn()
{
    return Level.GetLocalPlayerController().Pawn;
}

defaultproperties
{
     ItemName="Gunfire Acoustic Sensor"
     mesh=mesh'DeusExDeco.AcousticSensor'
     CollisionRadius=24.400000
     CollisionHeight=23.059999
     Mass=10.000000
     Buoyancy=5.000000
}
