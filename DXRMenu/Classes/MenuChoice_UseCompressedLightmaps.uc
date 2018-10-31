//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_UseCompressedLightmaps extends MenuChoice_OnOff;

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
    Hint="ToDo: Explain what is this?"
    actionText="Use compressed light maps"
//    configSetting="ini:Engine.Engine.RenderDevice UseCompressedLightmaps"
}
