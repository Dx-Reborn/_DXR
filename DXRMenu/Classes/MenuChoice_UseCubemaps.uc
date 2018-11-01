//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_UseCubemaps extends MenuChoice_OnOff;

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
    Hint="Enables cubemaps (usually shiny surfaces (not mirrors))"
    actionText="Use CubeMaps"
    configSetting="ini:Engine.Engine.RenderDevice UseCubemaps"
}
