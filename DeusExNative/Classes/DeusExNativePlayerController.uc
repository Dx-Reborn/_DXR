/*
   Set bWantsLedgeCheck to true, and player will "hold yourself" on ledges. False by default,
   so you can jump off from skyscrapers even when crouched (but for unknown reason, sometimes this will not work).
*/

class DeusExNativePlayerController extends PlayerController native;


var() bool bWantsLedgeCheck;
var private editconst float savedMusicVolume, savedSpeechVolume, savedSoundVolume;

cpptext
{
	virtual UBOOL WantsLedgeCheck() {
		return bWantsLedgeCheck;
	}

	void SetWantsLedgeCheck(UBOOL bWantsLedgeCheck) {
		this->bWantsLedgeCheck = bWantsLedgeCheck;
	}
}

function SetInstantMusicVolume(float vol)
{
  default.savedMusicVolume = float(ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
  ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume"@vol);
}

function RestoreMusicVolume()
{
  ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume"@savedMusicVolume);
}
/*----------------------------------------------------------------------------------------*/
function SetInstantSoundVolume(float vol)
{
  savedSoundVolume = float(ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume"));
  ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume"@vol);
}

function RestoreSoundVolume()
{
  ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume"@savedSoundVolume);
}
/*----------------------------------------------------------------------------------------*/
// SetInstantSpeechVolume was used in DeusEx only once (in Sound Settings dialog).

