//=============================================================================
// Valve.
//=============================================================================
class Valve extends DeusExDecoration;

#exec OBJ LOAD FILE=MoverSFX
#exec OBJ LOAD FILE=Ambient

var() bool bOpen;

function Frob(actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    bOpen = !bOpen;
    if (bOpen)
    {
        PlaySound(sound'ValveOpen',,,, 256);
        PlayAnim('Open',, 0.001);
    }
    else
    {
        PlaySound(sound'ValveClose',,,, 256);
        PlayAnim('Close',, 0.001);
    }
}

event PostBeginPlay()
{
    Super.PostBeginPlay();

    PlayAnimations();
}

event PostLoadSavedGame()
{
    Super.PostLoadSavedGame();

    PlayAnimations();
}

function PlayAnimations()
{
    if (bOpen)
        PlayAnim('Open', 10.0, 0.001);
    else
        PlayAnim('Close', 10.0, 0.001);
}

defaultproperties
{
     bInvincible=True
     ItemName="Valve"
     bPushable=False
     Physics=PHYS_None
     AmbientSound=Sound'Ambient.Ambient.WaterRushing'
     mesh=mesh'DeusExDeco.Valve'
     SoundRadius=6
     SoundVolume=48
     SoundPitch=96
     CollisionRadius=7.200000
     CollisionHeight=1.920000
     Mass=20.000000
     Buoyancy=10.000000
}
