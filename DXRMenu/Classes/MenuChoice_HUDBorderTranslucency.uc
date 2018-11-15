//=============================================================================
// MenuChoice_HUDBorderTranslucency
//=============================================================================

class MenuChoice_HUDBorderTranslucency extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(DeusExPlayer(PlayerOwner().pawn).bHUDBordersTranslucent));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersTranslucent = bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersTranslucent = bool(defaultValue);
	SetValue(defaultValue);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	Super.CycleNextValue();
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersTranslucent = bool(GetValue());
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	Super.CyclePreviousValue();
	DeusExPlayer(PlayerOwner().pawn).bHUDBordersTranslucent = bool(GetValue());
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="If translucency is enabled, the HUD borders will be translucent"
    actionText="HUD Borders Translucency"
}
