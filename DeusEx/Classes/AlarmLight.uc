/*
   AlarmLight.
   23/10/2020: Now using Projectors to create light spots.

   ToDo: maybe use tracing to limit projector's MaxTraceDistance, so it won't shine through everything when using bProjectOnBackFaces = true?
*/

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
var() bool bOldStyle; // DXR: ������ �����, ����� � ���������.
var LightProjector proj;

function ResetScaleGlow();

event Destroyed()
{
    Super.Destroyed();

    if (proj != None)
        proj.Destroy();
}

function createProjector()
{
    proj = spawn(class'LightProjector', self, '', location + vect(0,0,4), rotation);
    proj.bProjectOnBackFaces = !bOldStyle;
    proj.FOV = 30;
    proj.MaxTraceDistance = 600;
    proj.SetBase(self);
}

function SetLightColor(ESkinColor color)
{
    switch (SkinColor)
    {
        case SC_Red:
                            Skins[0]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightTex1_SH", class'Material', false));
                            Skins[1]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightTex2_SH", class'Material', false));
                            Skins[2]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightRed_TE", class'Material', false));
                            if (proj != None)
                                proj.ProjTexture = texture(DynamicLoadObject("DeusExDeco.Skins.AlarmLightTex2", class'texture', false));
                            break;
        case SC_Green:      
                            Skins[1]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightTex3_SH", class'Material', false));
                            Skins[2]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightGreen_TE", class'Material', false)); 
                            if (proj != None)
                                proj.ProjTexture = texture(DynamicLoadObject("DeusExDeco.Skins.AlarmLightTex4", class'texture', false));
                            break;
        case SC_Blue:       
                            Skins[1]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightTex4_SH", class'Material', false));
                            Skins[2]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightBlue_TE", class'Material', false));
                            if (proj != None)
                                proj.ProjTexture = texture(DynamicLoadObject("DeusExDeco.Skins.AlarmLightTex6", class'texture', false));
                            break;
        case SC_Amber:      
                            Skins[1]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightTex5_SH", class'Material', false));
                            Skins[2]=Material(DynamicLoadObject("DeusExDeco_EX.Shader.AlarmLightAmber_TE", class'Material', false));
                            if (proj != None)
                                proj.ProjTexture = texture(DynamicLoadObject("DeusExDeco.Skins.AlarmLightTex8", class'texture', false));
                            break;
    }
}

event BeginPlay()
{
    Super.BeginPlay();

    createProjector();
    SetLightColor(SkinColor);

    if (!bIsOn)
    {
        Skins[1] = Texture'BlackMaskTex';
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
        bFixedRotationDir = False;
    }
    Super.UnTrigger(Other, Instigator);
}


defaultproperties
{
     bOldStyle=true
     bIsOn=True
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Alarm Light"
     bPushable=False
     Physics=PHYS_Rotating
     Texture=Texture'DeusExDeco.Skins.AlarmLightTex3'
     mesh=mesh'DeusExDeco.AlarmLight'
     CollisionRadius=4.000000
     CollisionHeight=6.140000
     bFixedRotationDir=True
     Mass=20.000000
     Buoyancy=15.000000
     RotationRate=(Yaw=98304)

     Skins[0]=Shader'DeusExDeco_EX.Shader.AlarmLightTex1_SH'
     Skins[1]=Shader'DeusExDeco_EX.Shader.AlarmLightTex2_SH'
     Skins[2]=TexEnvMap'DeusExDeco_EX.Shader.AlarmLightRed_TE'

     bShouldBeAlwaysUpdated=true

//     AmbientSound=Sound'STALKER_Sounds.Ambient.lamp_squeaks_2'
}

