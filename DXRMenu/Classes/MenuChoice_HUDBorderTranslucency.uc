//=============================================================================
// MenuChoice_HUDBorderTranslucency
//=============================================================================

class MenuChoice_HUDBorderTranslucency extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(DeusExPlayerController(PlayerOwner()).bHUDBordersTranslucent));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    DeusExPlayerController(PlayerOwner()).bHUDBordersTranslucent = bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
    DeusExPlayerController(PlayerOwner()).bHUDBordersTranslucent = bool(defaultValue);
    SetValue(defaultValue);
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
    Super.CycleNextValue();
    DeusExPlayerController(PlayerOwner()).bHUDBordersTranslucent = bool(GetValue());
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
    Super.CyclePreviousValue();
    DeusExPlayerController(PlayerOwner()).bHUDBordersTranslucent = bool(GetValue());
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
