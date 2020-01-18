//=============================================================================
// MenuChoice_SoundCompatMode.uc
//=============================================================================

class MenuChoice_SoundCompatMode extends MenuChoice_OnOff;

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
    Hint="If you have problems with sound, try to use this mode."
    actionText="Compatibility Mode"
    configSetting="ini:Engine.Engine.AudioDevice CompatibilityMode"
}