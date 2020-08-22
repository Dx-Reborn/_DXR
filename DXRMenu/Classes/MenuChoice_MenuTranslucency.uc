//=============================================================================
// MenuChoice_MenuTranslucency
//=============================================================================

class MenuChoice_MenuTranslucency extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(DeusExPlayerController(PlayerOwner()).bMenusTranslucent));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    DeusExPlayerController(PlayerOwner()).bMenusTranslucent = bool(GetValue());
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
    DeusExPlayerController(PlayerOwner()).bMenusTranslucent = bool(defaultValue);
    SetValue(defaultValue);
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
    Super.CycleNextValue();
    DeusExPlayerController(PlayerOwner()).bMenusTranslucent = bool(GetValue());
    ChangeStyle();
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
    Super.CyclePreviousValue();
    DeusExPlayerController(PlayerOwner()).bMenusTranslucent = bool(GetValue());
    ChangeStyle();
}

// ----------------------------------------------------------------------
function ChangeStyle()
{
  local DxWindowTemplate dx;

     foreach AllObjects(class'DxWindowTemplate',dx)
         dx.ApplyTheme();
}

// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="If translucency is enabled, the background will be visible through the menus."
    actionText="Menu Translucency"
}
