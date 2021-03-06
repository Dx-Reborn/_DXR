//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_LowQualityTerrain extends MenuChoice_OnOff;

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
    Hint="Use low quality of terrain"
    actionText="Low Quality of Terrain"
    configSetting="ini:Engine.Engine.RenderDevice LowQualityTerrain"
}
