//=============================================================================
// MenuChoice_AlwaysRun
//=============================================================================

class MenuChoice_AlwaysRun extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
//	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bAlwaysRun));
		if (class'DeusExPlayer'.default.bAlwaysRun)
	SetValue(0);
    else
	SetValue(1);

}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bAlwaysRun = !bool(GetValue());
	class'DeusExPlayer'.static.StaticSaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!DeusExPlayer(PlayerOwner().pawn).bAlwaysRun));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    hint="If set to Enabled, the player will always run"
    actionText="Always Run"
}
