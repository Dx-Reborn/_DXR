//=============================================================================
// Keypad.
//=============================================================================
class Keypad extends HackableDevices
    abstract;

var() string validCode;
var() sound successSound;
var() sound failureSound;
var() name FailEvent;
var() bool bToggleLock;     // if True, toggle the lock state instead of triggering
var material StateLamps[4]; // Лампочки -- серый при бездействии, желтый во время ввода, красный при ошибке, зеленый если верный код.

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
        SetLampColor(1);
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




