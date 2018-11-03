//=============================================================================
// MenuChoice_HUDAugDisplay
//=============================================================================

class MenuChoice_HUDAugDisplay extends DXREnumButton;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(DeusExPlayer(PlayerOwner().pawn).bHUDShowAllAugs));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bHUDShowAllAugs = bool(GetValue());
	DeusExPlayer(PlayerOwner().pawn).AugmentationSystem.RefreshAugDisplay();
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
    enumText(0)="Active"
    enumText(1)="All Augs"
    defaultValue=1
    Hint="This setting determines which Augmentations are displayed in the HUD."
    actionText="HUD Augmentation Display"
}
