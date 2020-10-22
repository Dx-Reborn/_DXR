//=============================================================================
// AlarmLight.
//=============================================================================
class AlarmLight extends DeusExDecoration;

enum ESkinColor
{
    SC_Red,
    SC_Green,
    SC_Blue,
    SC_Amber
};

var() ESkinColor SkinColor;
var() bool bIsOn;

function SetLightColor(ESkinColor color)
{
    switch (SkinColor)
    {
        case SC_Red:        
                            Skins[0]=Shader'DeusExDeco_EX.Shader.AlarmLightTex1_SH';
                            Skins[1]=Shader'DeusExDeco_EX.Shader.AlarmLightTex2_SH';
                            Skins[2]=TexEnvMap'DeusExDeco_EX.Shader.AlarmLightRed_TE';
                            LightHue = 0;
                            break;
        case SC_Green:      
                            Skins[1]=Shader'DeusExDeco_EX.Shader.AlarmLightTex3_SH';
                            Skins[2]=TexEnvMap'DeusExDeco_EX.Shader.AlarmLightGreen_TE';
                            LightHue = 64;
                            break;
        case SC_Blue:       
                            Skins[1]=Shader'DeusExDeco_EX.Shader.AlarmLightTex4_SH';
                            Skins[2]=TexEnvMap'DeusExDeco_EX.Shader.AlarmLightBlue_TE';
                            LightHue = 160;
                            break;
        case SC_Amber:      
                            Skins[1]=Shader'DeusExDeco_EX.Shader.AlarmLightTex5_SH';
                            Skins[2]=TexEnvMap'DeusExDeco_EX.Shader.AlarmLightAmber_TE';
                            LightHue = 36;
                            break;
    }
}

event BeginPlay()
{
    Super.BeginPlay();

    SetLightColor(SkinColor);

    if (!bIsOn)
    {
        Skins[1] = Texture'BlackMaskTex';
        LightType = LT_None;
        bFixedRotationDir = False;
    }
}


// if we are triggered, turn us on
function Trigger(Actor Other, Pawn EventInstigator)
{
    if (!bIsOn)
    {
        bIsOn = True;
        SetLightColor(SkinColor);
        LightType = LT_Steady;
        bFixedRotationDir = True;
    }

    Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn EventInstigator)
{
    if (bIsOn)
    {
        bIsOn = False;
        Skins[1] = Texture'BlackMaskTex';
        LightType = LT_None;
        bFixedRotationDir = False;
    }

    Super.UnTrigger(Other, Instigator);
}


defaultproperties
{
     bIsOn=True
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Alarm Light"
     bPushable=False
     Physics=PHYS_Rotating
     Texture=Texture'DeusExDeco.Skins.AlarmLightTex3'
     mesh=mesh'DeusExDeco.AlarmLight'
     CollisionRadius=4.000000
     CollisionHeight=6.140000
     LightType=LT_Steady
     LightEffect=LE_Spotlight
     LightBrightness=255
     LightRadius=32
     LightCone=32
     bFixedRotationDir=True
     Mass=20.000000
     Buoyancy=15.000000
     RotationRate=(Yaw=98304)

     Skins[0]=Shader'DeusExDeco_EX.Shader.AlarmLightTex1_SH'
     Skins[1]=Shader'DeusExDeco_EX.Shader.AlarmLightTex2_SH'
     Skins[2]=TexEnvMap'DeusExDeco_EX.Shader.AlarmLightRed_TE'

     bDynamicLight=true
}

/*
Begin Map
Begin Actor Class=AlarmLight Name=AlarmLight1
    SkinColor=SC_Blue
    LightType=LT_Strobe
    LightRadius=64.000000
    LightPeriod=32
    LightPhase=64
    bLightChanged=True
    Level=LevelInfo'myLevel.LevelInfo0'
    Region=(Zone=LevelInfo'myLevel.LevelInfo0',iLeaf=8,ZoneNumber=1)
    Tag="AlarmLight"
    PhysicsVolume=DefaultPhysicsVolume'myLevel.DefaultPhysicsVolume4'
    Location=(X=-768.299438,Y=-257.261505,Z=53.985233)
    Rotation=(Yaw=24000)
    Skins(1)=Shader'DeusExDeco_EX.Shader.AlarmLightTex2_SH'
    Skins(2)=TexEnvMap'DeusExDeco_EX.Shader.AlarmLightRed_TE'
    RotationRate=(Yaw=120000)
    ColLocation=(X=-768.299438,Y=-257.261505,Z=53.985233)
    bSelected=True
End Actor
Begin Surface
End Surface
End Map
*/

