//=============================================================================
// MenuChoice_Hitmarker
//=============================================================================

class MenuChoice_Hitmarker extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(!gl.bHitMarkerOn));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    gl.bHitMarkerOn = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
    SetValue(int(!gl.bHitMarkerOn));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Render an additional rotating indicator if enemy got some damage from PlayerPawn."
    actionText="HitMarker"
}
