class MenuChoice_FS_Preset extends MenuChoice_ThemeColor;

var int currentPreset;

function LoadSetting()
{
    // Populate the enums!
    PopulateThemes(1);
    currentPreset = gl.FS_Preset;
    SetValueFromString(class'DXRFootStepManager'.static.GetSoundsSetName(currentPreset));
}

function SaveSetting()
{
  ChangeStyle();
  class'DeusExGlobals'.static.StaticSaveConfig();
}

function CycleNextValue()
{
    Super.CycleNextValue();
    ChangeStyle();
}

function CyclePreviousValue()
{
    Super.CyclePreviousValue();
    ChangeStyle();
}

function ChangeStyle()
{
    gl.FS_PresetString = enumText[GetValue()];
    gl.FS_Preset = GetValue();
}

function PopulateThemes(int mode)
{
  local array<string> presets;
  local int i;

  presets = class'DXRFootStepManager'.static.GetAllSoundSets();

  for (i=0; i<presets.length; i++)
  {
    EnumText[i] = presets[i];
  }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
  Hint=""
  actionText="Preset of footstepping sounds"
}
