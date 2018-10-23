//=============================================================================
// MenuChoice_SoundUsePreCache
//=============================================================================

class MenuChoice_SoundUsePreCache extends MenuChoice_OnOff;

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
    Hint="Precache sounds. Usually you don't need to turn this off."
    actionText="Sound PreCache"
    configSetting="ini:Engine.Engine.AudioDevice UsePreCache"
}