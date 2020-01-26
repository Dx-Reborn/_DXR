//=============================================================================
// MenuChoice_WeaponSounds
//=============================================================================

class MenuChoice_WeaponSounds extends MenuChoice_OnOff;


function LoadSetting()
{
    SetValue(int(gl.bUseAltWeaponsSounds));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    gl.bUseAltWeaponsSounds = bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
    SetValue(int(gl.bUseAltWeaponsSounds));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=0
    Hint="Use external weapons sounds presets. Otherwise default sounds will be used."
    actionText="Allow custom weapon sounds"
}
