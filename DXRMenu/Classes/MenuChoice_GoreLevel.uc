//=============================================================================
// MenuChoice_GoreLevel
//=============================================================================

class MenuChoice_GoreLevel extends DXREnumButton;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
/*	// Check for German system and disable this option
	if (player.Level.Game.bVeryLowGore)
		btnAction.EnableWindow(False);
	else*/
		SetValue(int(!playerOwner().Level.Game.bLowGore));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	playerOwner().Level.Game.bLowGore = !bool(GetValue());
	playerOwner().Level.Game.SaveConfig();
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
    enumText(0)="Low"
    enumText(1)="Normal"
    defaultValue=1
    Hint="Setting to low will remove blood from the game"
    actionText="Gore Level"
}
