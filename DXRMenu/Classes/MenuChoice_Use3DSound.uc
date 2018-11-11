//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_Use3DSound extends MenuChoice_OnOff;

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
    Hint="Enables Hardware 3D Sound Support. Sound subsystem will be restarted"
    actionText="3D Sound Support"
    configSetting="ini:Engine.Engine.AudioDevice Use3DSound"
}
