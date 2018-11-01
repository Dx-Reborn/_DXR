//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_UseTripleBuffering extends MenuChoice_OnOff;

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
    defaultValue=1
    Hint="Enables Triple Buffering. Set to Off only if you have less than 128 MBytes of video memory"
    actionText="Use Triple Buffering"
    configSetting="ini:Engine.Engine.RenderDevice DetailTextures"
}
