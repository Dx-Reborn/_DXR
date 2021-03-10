//=============================================================================
// CageLight.
//=============================================================================
class CageLight extends DeusExDecoration;

enum ESkinColor
{
    SC_1,
    SC_2,
    SC_3,
    SC_4,
    SC_5,
    SC_6
};

var() ESkinColor SkinColor;
var() bool bOn;
var material LightSkins[6];

function Trigger(Actor Other, Pawn Instigator)
{
    Super.Trigger(Other, Instigator);

    if (!bOn)
    {
        bOn = True;
        //LightType = LT_Steady;
        bUnlit = True;
    }
    else
    {
        bOn = False;
        //LightType = LT_None;
        bUnlit = False;
    }
}

event BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
        case SC_1:  Skins[1] = LightSkins[0];
        case SC_2:  Skins[1] = LightSkins[1];
        case SC_3:  Skins[1] = LightSkins[2];
        case SC_4:  Skins[1] = LightSkins[3];
        case SC_5:  Skins[1] = LightSkins[4];
        case SC_6:  Skins[1] = LightSkins[5];
    }
}

event PostBeginPlay()
{
    Super.PostBeginPlay();

    if (!bOn)
        LightType = LT_None;
}



defaultproperties
{
     LightSkins[0] = Shader'DeusExStaticMeshes0.Plastic.KP_White_SH'; break; // Белый
     LightSkins[1] = Shader'DeusExStaticMeshes0.Plastic.KP_Yellow_SH'; break; // Жёлтый
     LightSkins[2] = Shader'DeusExStaticMeshes0.Plastic.KP_Red_SH'; break; // Красный
     LightSkins[3] = Shader'DeusExStaticMeshes0.Plastic.KP_Blue_SH'; break; // Синий
     LightSkins[4] = Shader'DeusExStaticMeshes0.Plastic.KP_Yellow_SH'; break; // o5 жёлтый?
     LightSkins[5] = Shader'DeusExStaticMeshes0.Plastic.KP_Red_SH'; break; // o5 красный?

     bOn=True
     HitPoints=5
     bInvincible=True
     FragType=Class'DeusEx.GlassFragment'
     bHighlight=False
     bCanBeBase=True
     ItemName="Light Fixture"
     bPushable=False
     Physics=PHYS_None
//     mesh=mesh'DeusExDeco.CageLight'
     ScaleGlow=2.000000
     CollisionRadius=17.139999
     CollisionHeight=17.139999
     LightType=LT_Steady
     LightBrightness=255
     LightHue=32
     LightSaturation=224
//     LightRadius=8
     LightRadius=0
     Mass=20.000000
     Buoyancy=10.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.CageLight_HD'
}


/*  Original version      case SC_1:  Skins[0] = Texture'CageLightTex1'; break; // Белый
        case SC_2:  Skins[0] = Texture'CageLightTex2'; break; // Жёлтый
        case SC_3:  Skins[0] = Texture'CageLightTex3'; break; // Красный
        case SC_4:  Skins[0] = Texture'CageLightTex4'; break; // Синий
        case SC_5:  Skins[0] = Texture'CageLightTex5'; break; // o5 жёлтый?
        case SC_6:  Skins[0] = Texture'CageLightTex6'; break; // o5 красный?*/

