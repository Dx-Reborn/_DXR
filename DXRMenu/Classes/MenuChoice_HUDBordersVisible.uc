//=============================================================================
// MenuChoice_HUDBordersVisible
//=============================================================================

class MenuChoice_HUDBordersVisible extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(DeusExPlayerController(PlayerOwner()).bHUDBordersVisible));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    DeusExPlayerController(PlayerOwner()).bHUDBordersVisible = bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
    DeusExPlayerController(PlayerOwner()).bHUDBordersVisible = bool(defaultValue);
    SetValue(defaultValue);
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
    Super.CycleNextValue();
    DeusExPlayerController(PlayerOwner()).bHUDBordersVisible = bool(GetValue());
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
    Super.CyclePreviousValue();
    DeusExPlayerController(PlayerOwner()).bHUDBordersVisible = bool(GetValue());
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
