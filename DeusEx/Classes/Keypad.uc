//=============================================================================
// Keypad.
//=============================================================================
class Keypad extends HackableDevices
    abstract;

const MAX_STATE_MATERIALS = 4;
const LIGHTING_THRESHOLD = 0.1;
const RESET_LAMP_DELAY = 2.0;

var() string validCode;
var() sound successSound;
var() sound failureSound;
var() name FailEvent;
var() bool bToggleLock;     // if True, toggle the lock state instead of triggering
var material StateLamps[MAX_STATE_MATERIALS]; // Лампочки -- серый при бездействии, желтый во время ввода, красный при ошибке, зеленый если верный код.

var float StateResetTimer;
var bool bStateResetTimerEnabled;


event PostBeginPlay()
{
   Super.PostBeginPlay();
   SetLampColor(0);
}

function SetLampColor(int aColor)
{
   if ((DrawType == DT_StaticMesh) && (StaticMesh != None))
   {
       Skins[1] = StateLamps[aColor];
   }
}

function HackAction(Actor Hacker, bool bHacked)
{
    local DeusExPlayer Player;

    Player = DeusExPlayer(Hacker);

    if (Player != None)
    {
        //DeusExPlayerController(Level.GetLocalPlayerController()).ClientOpenMenu("DXRMenu.DXR_KeyPad");
        DeusExPlayerController(Player.Controller).ClientOpenMenu("DXRMenu.DXR_KeyPad");
        bStateResetTimerEnabled = false;
        SetLampColor(1);
    }
}

event Tick(float dt)
{
   Super.Tick(dt);

   if ((DrawType == DT_StaticMesh) && (StaticMesh != None))
   {
       if ((Skins.Length > 0) && (Skins[0].IsA('Shader')))
       {
          if (class'DeusExPawn'.static.AiVisibility(self, false) < LIGHTING_THRESHOLD)
              Shader(Skins[0]).Specular = None;
          else
              Shader(Skins[0]).Specular = TexEnvMap'DXR_CubeMaps.Shaders.BlurryTexEnvMap4';
       }

       if (bStateResetTimerEnabled == true)
       {
           StateResetTimer += dt;
           if (StateResetTimer > RESET_LAMP_DELAY)
           {
               StateResetTimer  = 0;
               SetLampColor(0);
           }
       }
   }
}



defaultproperties
{
     StateLamps[0]=Shader'DeusExStaticMeshes0.Plastic.KP_Gray_SH'
     StateLamps[1]=Shader'DeusExStaticMeshes0.Plastic.KP_Yellow_SH'
     StateLamps[2]=Shader'DeusExStaticMeshes0.Plastic.KP_Red_SH'
     StateLamps[3]=Shader'DeusExStaticMeshes0.Plastic.KP_Green_SH'

     validCode="1234"
     successSound=Sound'DeusExSounds.Generic.Beep2'
     failureSound=Sound'DeusExSounds.Generic.Buzz1'
     bToggleLock=True
     ItemName="Security Keypad"
     Mass=10.000000
     Buoyancy=5.000000
}




