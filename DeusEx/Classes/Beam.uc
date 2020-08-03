//=============================================================================
// Beam
//=============================================================================
class Beam extends Light;

//native final function SetDrawType(EDrawType NewDrawType);

event BeginPlay()
{
//  SetDrawType(DT_None); // Нужно для того чтобы лампочка не висела перед игроком :)
    SetTimer(1.0, True);
    setCollision(false,false,false);
}

event Timer()
{
    MakeNoise(0.3);
}

defaultproperties
{
//    bStatic=False
//    bHidden=False
//    bNoDelete=False
//    bMovable=True
//    LightEffect=13
//    LightBrightness=250
//    LightHue=32
//    LightSaturation=142
//    LightRadius=7
//    LightPeriod=0

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
