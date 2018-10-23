//=============================================================================
// MenuChoice_LowSoundQ
//=============================================================================

class MenuChoice_LowSoundQ extends MenuChoice_OnOff;

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
    defaultValue=0
    Hint="Lowers quality of sound. May increase performance. This will restart audio subsystem."
    actionText="Low Sound Quality"
    configSetting="ini:Engine.Engine.AudioDevice LowQualitySound"
}
