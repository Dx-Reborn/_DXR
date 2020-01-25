class DynamicCoronaLight extends Light;

defaultproperties
{
    bUnlit=True
    DrawType=DT_None
    bHidden=False
    DrawScale=1.00
//    bHardAttach=True
    bCollideActors=False
    bCorona=True
    bBlockActors=False
    LightType=LT_None
    LightBrightness=0
    LightSaturation=255
    LightHue=255
    LightRadius=100
    LightPeriod=0
    LightCone=0
    bDynamicLight=False
    bMovable=True
    Physics=PHYS_None
    bNoDelete=false
    bStatic=false
    bDirectionalCorona=true
    CoronaRotation=10
    bDetailAttachment=true
    Skins[0]=Texture'Effects.Corona.Corona_E'

    MinCoronaSize=5
    MaxCoronaSize=10
}
