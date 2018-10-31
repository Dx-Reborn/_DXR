//=============================================================================
// MenuChoice_UsePrecaching
//=============================================================================

class MenuChoice_UsePrecaching extends MenuChoice_OnOff;

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
    Hint="Precache textures for faster loading"
    actionText="Use precaching"
    configSetting="ini:Engine.Engine.RenderDevice UsePrecaching"
}
