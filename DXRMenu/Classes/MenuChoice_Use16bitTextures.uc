//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_Use16bitTextures extends MenuChoice_OnOff;

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
    Hint="Makes textures look very very bad, without increasing performance."
    actionText="Use 16-bit Textures"
    configSetting="ini:Engine.Engine.RenderDevice Use16bitTextures"
}
