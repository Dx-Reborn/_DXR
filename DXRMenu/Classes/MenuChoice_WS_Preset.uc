class MenuChoice_WS_Preset extends MenuChoice_ThemeColor;

var int currentPreset;

function LoadSetting()
{
    // Populate the enums!
    PopulateThemes(1);
    currentPreset = gl.WS_Preset;
    SetValueFromString(class'DXRWeaponSoundManager'.static.GetSoundsSetName(currentPreset));
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
    gl.WS_PresetString = enumText[GetValue()];
    gl.WS_Preset = GetValue();
}

function PopulateThemes(int mode)
{
  local array<string> presets;
  local int i;

  presets = class'DXRWeaponSoundManager'.static.GetAllWeaponSoundSets();

  for (i=0; i<presets.length; i++)
  {
    EnumText[i] = presets[i];
  }
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
  Hint="Pick a preset of weapons sounds. To use default sounds, disable the ''Allow custom weapon sounds'' option"
  actionText="Preset of weapons sounds"
}
