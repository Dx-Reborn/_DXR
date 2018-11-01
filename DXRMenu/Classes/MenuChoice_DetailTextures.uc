//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_DetailTextures extends MenuChoice_OnOff;

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
    Hint="Enables additional detail layer for some textures."
    actionText="Detailed textures"
    configSetting="ini:Engine.Engine.RenderDevice DetailTextures"
}
