//=============================================================================
// MenuChoice_LowSoundQ
//=============================================================================

class MenuChoice_LowSoundQ extends MenuChoice_OnOff;

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
function bool IntOnClick(GUIComponent Sender)         // The mouse was clicked on this control
{
  if (DXRMenuSound(PageOwner) != none)
      DXRMenuSound(PageOwner).bRestartSoundSys = true;

   super.IntOnClick(Sender);
   return true;
}

function bool IntOnRightClick(GUIComponent Sender)    // Return false to prevent context menu from appearing
{
  if (DXRMenuSound(PageOwner) != none)
      DXRMenuSound(PageOwner).bRestartSoundSys = true;

  super.IntOnRightClick(Sender);
  return true;
}
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=0
    Hint="Lowers quality of sound. May increase performance. This will restart audio subsystem."
    actionText="Low Sound Quality"
    configSetting="ini:Engine.Engine.AudioDevice LowQualitySound"
}
