//=============================================================================
// MenuChoice_ObjectNames
//=============================================================================

class MenuChoice_ObjectNames extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bObjectNames));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bObjectNames = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bObjectNames));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    Hint="If enabled, the name of the selected object in the world will be printed"
    actionText="Object Names"
}
