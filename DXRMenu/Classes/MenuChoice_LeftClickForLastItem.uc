//=============================================================================
// MenuChoice_LeftClickForLastItem
//=============================================================================

class MenuChoice_LeftClickForLastItem extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bLeftClickForLastItem));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bLeftClickForLastItem = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bLeftClickForLastItem));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    Hint="If enabled, and currently nothing in hand, you can bring up last inventory item using Left Mouse Button."
    actionText="Left Click For Last Inventory Item"
}
