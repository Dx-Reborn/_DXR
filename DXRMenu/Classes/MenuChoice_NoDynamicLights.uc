//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_NoDynamicLights extends MenuChoice_OnOff;

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
    Hint="Disable use of Dynamic Light. Keep in mind that Light Augmentation is Dynamic Light, so it will not work when this option is enabled"
    actionText="Do not use Dynamic Lights"
    configSetting="ini:Engine.Engine.ViewportManager NoDynamicLights"
}
