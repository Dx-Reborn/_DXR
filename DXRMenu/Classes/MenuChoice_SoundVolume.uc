//=============================================================================
// MenuChoice_SoundVolume
//=============================================================================

class MenuChoice_SoundVolume extends MenuChoice_Volume;

function SliderOnChange(GUIComponent Sender)
{
   super.SliderOnChange(Sender);
   PlayerOwner().pawn.PlaySound(sound'Menu_SoundTest', SLOT_None, btnSlider.value, True);
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	Super.LoadSetting();
//	Player.SetInstantSoundVolume(GetValue());
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
//	Super.CancelSetting();
	LoadSetting();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=0.5
    Hint="Adjusts the Sound Effects volume. Also affects to Ambient Sound volume."
    actionText="Sound Effects Volume"
    configSetting="ini:Engine.Engine.AudioDevice SoundVolume"
}