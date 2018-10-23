//=============================================================================
// MenuChoice_MusicVolume
//=============================================================================

class MenuChoice_MusicVolume extends MenuChoice_Volume;

function SliderOnChange(GUIComponent Sender)
{
   super.SliderOnChange(Sender);
	// Restart music.
/*	if(PlayerOwner().Level.Song != "" && PlayerOwner().Level.Song != "None")
     PlayerOwner().ClientSetMusic(PlayerOwner().Level.Song, MTRAN_Instant);*/
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	Super.LoadSetting();
//	Player.SetInstantSoundVolume(GetValue());
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
	Super.CancelSetting();
	LoadSetting();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1.00
    hint="Adjusts the Music volume."
    actionText="Music Volume"
    configSetting="ini:Engine.Engine.AudioDevice MusicVolume"
}
