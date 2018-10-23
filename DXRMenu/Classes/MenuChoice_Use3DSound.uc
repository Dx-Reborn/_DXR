//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_Use3DSound extends MenuChoice_OnOff;

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
    Hint="Enables Hardware 3D Sound Support. Sound subsystem will be restarted"
    actionText="3D Sound Support"
    configSetting="ini:Engine.Engine.AudioDevice Use3DSound"
}
