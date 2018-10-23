//=============================================================================
// MenuChoice_DefaultSoundDriver
//=============================================================================

class MenuChoice_DefaultSoundDriver extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	LoadSettingBool();
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	SaveSettingBool();
	PlayerOwner().ConsoleCommand("SOUND_REBOOT");
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Use system installed OpenAL driver"
    actionText="Default Sound Driver"
    configSetting="ini:Engine.Engine.AudioDevice UseDefaultDriver"
}