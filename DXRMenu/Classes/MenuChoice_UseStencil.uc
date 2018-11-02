//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_UseStencil extends MenuChoice_OnOff;

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
    Hint="This option can partially solve problem with reflective surfaces (mirrors)"
    actionText="UseStencil"
    configSetting="ini:Engine.Engine.RenderDevice UseStencil"
}
