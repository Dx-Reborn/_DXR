//=============================================================================
// MenuChoice_MenuTranslucency
//=============================================================================

class MenuChoice_MenuTranslucency extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(DeusExPlayer(PlayerOwner().pawn).bMenusTranslucent));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bMenusTranslucent = bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	DeusExPlayer(PlayerOwner().pawn).bMenusTranslucent = bool(defaultValue);
	SetValue(defaultValue);
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	Super.CycleNextValue();
	DeusExPlayer(PlayerOwner().pawn).bMenusTranslucent = bool(GetValue());
	ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	Super.CyclePreviousValue();
	DeusExPlayer(PlayerOwner().pawn).bMenusTranslucent = bool(GetValue());
	ChangeStyle();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="If translucency is enabled, the background will be visible through the menus."
    actionText="Menu Translucency"
}
