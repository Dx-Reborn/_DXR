//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_SuperHighDetailActors extends MenuChoice_OnOff;

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
    Hint="Enables very detailed objects (usually decorations) with 'bSuperHighDetail' flag"
    actionText="Allow Extra Detailed objects"
    configSetting="ini:Engine.Engine.RenderDevice SuperHighDetailActors"
}
