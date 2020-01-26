//=============================================================================
// MenuChoice_DelayedExplosions
//=============================================================================

class MenuChoice_DelayedExplosions extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(!gl.bDelayedDecoExplosions));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    gl.bDelayedDecoExplosions = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
    SetValue(int(!gl.bDelayedDecoExplosions));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=0
    Hint="If enabled, some explosions will be delayed."
    actionText="Delayed explosions"
}
