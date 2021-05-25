//=============================================================================
// Beam
//=============================================================================
class Beam extends Light;


event BeginPlay()
{
    SetTimer(1.0, True);
    setCollision(false,false,false);
}

event Timer()
{
    // DXR: Only if player really wants that!
    if (class'DeusExGlobals'.static.GetGlobals().bMoreAINotifications)
        Level.GetLocalPlayerController().pawn.AISendEvent('LoudNoise', EAITYPE_Audio,, LightRadius * 2);
}

defaultproperties
{
    LightType=LT_Steady
    LightEffect=LE_NonIncidence
    LightBrightness=180
    LightSaturation=255
    LightRadius=3.0
    CollisionRadius=+0.000000
    CollisionHeight=+0.000000
    bHidden=true
    bStatic=false
    bNoDelete=false
    bMovable=true
    bDynamicLight=true //false
    bDirectional=false //true
    bLightingVisibility=False
    bCollideActors=False
}
