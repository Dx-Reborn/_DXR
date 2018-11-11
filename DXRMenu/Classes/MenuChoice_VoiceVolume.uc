//=============================================================================
// MenuChoice_AmbientVolume
//=============================================================================

class MenuChoice_VoiceVolume extends MenuChoice_Volume;

function SliderOnChange(GUIComponent Sender)
{
   super.SliderOnChange(Sender);

   if (!bSavingChanges)
   {
     class'SoundManager'.static.StopSound(PlayerOwner().pawn, sound'Menu_SpeechTest');
     PlayerOwner().pawn.PlaySound(sound'Menu_SpeechTest', SLOT_None, btnSlider.value, True);
   }
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
    Hint="Adjusts the Speech volume."
    actionText="Speech Volume"
    configSetting="ini:Engine.Engine.AudioDevice VoiceVolume"
}