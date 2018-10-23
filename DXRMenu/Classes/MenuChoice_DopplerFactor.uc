//=============================================================================
// MenuChoice_AmbientVolume
//=============================================================================

class MenuChoice_DopplerFactor extends MenuChoice_Volume;

function SliderOnChange(GUIComponent Sender)
{
   super.SliderOnChange(Sender);
//   PlayerOwner().pawn.PlaySound(sound'Menu_SoundTest', SLOT_None, btnSlider.value, True);
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
    Hint="Amount of Doppler factor effect"
    actionText="Doppler Factor"
    configSetting="ini:Engine.Engine.AudioDevice DopplerFactor"
}