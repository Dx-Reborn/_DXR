//=============================================================================
// MenuChoice_UseStencil
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
    Hint="Keep it turned On, so reflective surfaces (mirrors) will work correctly."
    actionText="UseStencil"
    configSetting="ini:Engine.Engine.RenderDevice UseStencil"
}
