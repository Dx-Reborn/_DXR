//=============================================================================
// MenuChoice_HUDTranslucency
//=============================================================================

class MenuChoice_HUDTranslucency extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(DeusExPlayerController(PlayerOwner()).bHUDBackgroundTranslucent));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    DeusExPlayerController(PlayerOwner()).bHUDBackgroundTranslucent = bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
    DeusExPlayerController(PlayerOwner()).bHUDBackgroundTranslucent = bool(defaultValue);
    SetValue(defaultValue);
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
    Super.CycleNextValue();
    DeusExPlayerController(PlayerOwner()).bHUDBackgroundTranslucent = bool(GetValue());
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
    Super.CyclePreviousValue();
    DeusExPlayerController(PlayerOwner()).bHUDBackgroundTranslucent = bool(GetValue());
    ChangeStyle();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="If translucency is enabled, the background will be visible through the in-game HUD and User-Interface screens."
    actionText="HUD Background Translucency"
}
