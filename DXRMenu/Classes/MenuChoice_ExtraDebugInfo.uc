//=============================================================================
// MenuChoice_ExtraDebugInfo
//=============================================================================

class MenuChoice_ExtraDebugInfo extends DXREnumButton;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(!DeusExPlayer(playerOwner().pawn).bExtraDebugInfo));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(playerOwner().pawn).bExtraDebugInfo = !bool(GetValue());
	DeusExPlayer(playerOwner().pawn).SaveConfig();
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(defaultValue);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    enumText(0)="Enabled"
    enumText(1)="Disabled"
    defaultValue=1
    Hint="Can be useful for mod authors."
    actionText="Extra debug info on HUD"
}
