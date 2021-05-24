//=============================================================================
// DataCube.
// 21/08/2019 -- добавлена возможность вопроизведения аудио файла
// в дополнение к тексту.
//=============================================================================
class DataCube extends InformationDevices;

const FILE_NOT_EXISTS = -1;

enum EDataCubeType
{
    DTC_Regular,
    DTC_Audio
};

var() EDataCubeType DataCubeType;
var() string PathToAudioFile; // Path to .MP3 file
var transient Sound AudioLog; // Decode mp3 to USound
var localized String AudioLogSentMessage;
var localized String AudioLogMessageFailed;

function frob(Actor frobber, inventory FrobWith)
{
   local bool bMessageDecoded;
   local HUDOverlay_AudioLog aLog;

   Super.frob(frobber, FrobWith);

   if (DataCubeType == DTC_Audio)
     if ((PathToAudioFile != "") && (class'FileManager'.static.FileSize(PathToAudioFile) != FILE_NOT_EXISTS) && (DeusExPlayer(Frobber) != None))
     {
        bMessageDecoded = class'SoundManager'.static.LoadSound(PathToAudioFile, AudioLog, Outer);
        if (bMessageDecoded)
        {
           DeusExPlayer(frobber).ClientMessage(AudioLogSentMessage);
           DeusExPlayer(frobber).PlaySound(AudioLog,SLOT_Interface);
           aLog = spawn(class'HUDOverlay_AudioLog');
           aLog.SetTimer(AudioLog.Duration + 1.0, false);
        }
        else
        {
          DeusExPlayer(frobber).ClientMessage(AudioLogMessageFailed);
          return;
        }
     }
}

defaultproperties
{
    bAddToVault=True
    bInvincible=True
    bCanBeBase=True
    ItemName="DataCube"
//    Mesh=Mesh'DeusExItems.DataCube'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DeusExStaticMeshes0.Datacube_HD'
    CollisionRadius=7.00
    CollisionHeight=2.00 //1.270000
    Mass=2.000000
    Buoyancy=3.000000
    AudioLogSentMessage="Sound message has been downloaded."
    AudioLogMessageFailed="Sound message is broken!"
}



