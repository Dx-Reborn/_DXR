//=============================================================================
// MenuChoice_Crosshairs
//=============================================================================

class MenuChoice_Crosshairs extends MenuChoice_VisibleHidden;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bCrosshairVisible));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bCrosshairVisible = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bCrosshairVisible));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    Hint="Toggles Crosshairs visibility."
    actionText="Crosshairs"
}
