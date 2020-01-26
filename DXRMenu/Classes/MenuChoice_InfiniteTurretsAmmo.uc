//=============================================================================
// MenuChoice_InfiniteTurretsAmmo
//=============================================================================

class MenuChoice_InfiniteTurretsAmmo extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(!gl.bInfiniteAmmoForTurrets));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    gl.bInfiniteAmmoForTurrets = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
    SetValue(int(!gl.bInfiniteAmmoForTurrets));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="If enabled, turrets will never run out of ammo."
    actionText="Infinite ammo for turrets"
}
