//=============================================================================
// MenuChoice_WeaponAutoReload
//=============================================================================

class MenuChoice_WeaponAutoReload extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bAutoReload));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bAutoReload = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bAutoReload));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    Hint="If enabled, weapons will automatically reload when their ammo is depleted."
    actionText="Weapon Auto-Reload"
}
