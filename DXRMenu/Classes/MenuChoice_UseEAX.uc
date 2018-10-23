//=============================================================================
// MenuChoice_SoundCompatMode.uc
//=============================================================================

class MenuChoice_UseEAX extends MenuChoice_OnOff;

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
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=0
    Hint="Environmental Audio Extensions for Creative Sound Cards"
    actionText="EAX Mode"
    configSetting="ini:Engine.Engine.AudioDevice UseEAX"
}