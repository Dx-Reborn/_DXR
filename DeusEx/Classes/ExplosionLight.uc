//=============================================================================
// ExplosionLight
//=============================================================================
class ExplosionLight extends Light;

var int size;

event Timer()
{
    if (size > 0)
    {
        LightRadius = Clamp(size, 1, 16);
        size = -1;
    }

    LightRadius-=1;
    if (LightRadius < 1)
        Destroy();
}

function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(0.1, True);
}


defaultproperties
{
     size=1
     bStatic=False
     bNoDelete=False
     bDynamicLight=true
     bCorona=true
     RemoteRole=ROLE_SimulatedProxy
     bMovable=True
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=16
     LightSaturation=192
//     LightRadius=60
//     lightType=LT_None
     LightRadius=1
//     Skins(0)=texture'Effects.corona.corona_E'
}
