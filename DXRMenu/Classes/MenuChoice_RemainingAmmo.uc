//=============================================================================
// MenuChoice_GoreLevel
//=============================================================================

class MenuChoice_RemainingAmmo extends DXREnumButton;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(DeusExPlayer(playerOwner().pawn).RemainingAmmoMode);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(playerOwner().pawn).RemainingAmmoMode = GetValue();
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
    enumText(0)="As clips"
    enumText(1)="As amount"
    defaultValue=0
    Hint="Displays rounds instead of clips remaining."
    actionText="Display remaining ammo"
}
