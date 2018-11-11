//=============================================================================
// MenuChoice_DefaultSoundDriver
//=============================================================================

class MenuChoice_DefaultSoundDriver extends MenuChoice_OnOff;

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
    defaultValue=1
    Hint="Use system installed OpenAL driver. You can download latest OpenAl driver at _zîhttps://www.openal.org/downloads/"
    actionText="Default Sound Driver"
    configSetting="ini:Engine.Engine.AudioDevice UseDefaultDriver"
}