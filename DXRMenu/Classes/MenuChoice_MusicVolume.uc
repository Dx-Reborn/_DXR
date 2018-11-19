//=============================================================================
// MenuChoice_MusicVolume
//=============================================================================

class MenuChoice_MusicVolume extends MenuChoice_Volume;
/*
function SliderOnChange(GUIComponent Sender)
{
   super.SliderOnChange(Sender);
   PlayerControllerExt(PlayerOwner()).SetInstantMusicVolume(GetValue());
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	 Super.LoadSetting();
   PlayerControllerExt(PlayerOwner()).SetInstantMusicVolume(GetValue());
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
   Super.CancelSetting();
   PlayerControllerExt(PlayerOwner()).RestoreMusicVolume();
//   LoadSetting();
}
  */
// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1.00
    hint="Adjusts the Music volume."
    actionText="Music Volume"
    configSetting="ini:Engine.Engine.AudioDevice MusicVolume"
}
