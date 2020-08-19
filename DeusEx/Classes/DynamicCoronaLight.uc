/*

*/

class DynamicCoronaLight extends DXRLight;

var() bool bPulse;
var() float PulseRange; // 0.1 ~ 0.5 // 0.1 will produce values from 0.00 to 0.20 and so on.
var() float PulseBaseValue; // Base value + PulseRange + pulsing = final DrawScale.
var() float PulseFreq; // Hz
var float pulseTime;
var float TargetScale;

event Tick(float dt)
{
    if (bPulse)
    {
        pulseTime += dt;
        TargetScale = PulseBaseValue + (PulseRange * (1+sin(2 * pi * PulseFreq * pulseTime)));
        SetDrawScale(TargetScale);
    }
}

//   vScale = 0.8 + (0.1 * (1+sin(2 * pi * 1.0 * vsTime1)));

defaultproperties
{
    bPulse=false
    PulseRange=0.5
    PulseFreq=1.00
    PulseBaseValue=0.0

    bUnlit=True
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
    bDetailAttachment=true
    Skins[0]=Texture'Effects.Corona.Corona_A'

    MinCoronaSize=10
    MaxCoronaSize=100

}
