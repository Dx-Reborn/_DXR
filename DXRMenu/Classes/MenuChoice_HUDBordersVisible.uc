//=============================================================================
// MenuChoice_HUDBordersVisible
//=============================================================================

class MenuChoice_HUDBordersVisible extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(DeusExPlayer(PlayerOwner().pawn).bHUDBordersVisible));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersVisible = bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersVisible = bool(defaultValue);
	SetValue(defaultValue);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	Super.CycleNextValue();
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersVisible = bool(GetValue());
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	Super.CyclePreviousValue();
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersVisible = bool(GetValue());
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Determines whether the HUD Borders are displayed"
    actionText="HUD Borders Visible"
}
