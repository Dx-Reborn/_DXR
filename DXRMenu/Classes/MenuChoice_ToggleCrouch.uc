//=============================================================================
// MenuChoice_ToggleCrouch
//=============================================================================

class MenuChoice_ToggleCrouch extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bToggleCrouch));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    class'DeusExPlayer'.default.bToggleCrouch = !bool(GetValue());
    DeusExPlayer(PlayerOwner().pawn).bToggleCrouch = !bool(GetValue());
    class'DeusExPlayer'.static.StaticSaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
    SetValue(int(DeusExPlayer(PlayerOwner().pawn).bToggleCrouch));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    hint="If set to Enabled, the crouch key will act as a toggle"
    actionText="Toggle Crouch"
}
