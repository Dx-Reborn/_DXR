//=============================================================================
// MenuChoice_BurnStaticObjects
//=============================================================================

class MenuChoice_BurnStaticObjects extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
    SetValue(int(!gl.bBurnStaticObjects));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
    gl.bBurnStaticObjects = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
    SetValue(int(!gl.bBurnStaticObjects));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="If enabled, static objects (like walls, floor, ceiling, some decorations, etc.) hit by flamethrower will continue burning for some time. This does not affect decorations and pawns."
    actionText="Burn static objects"
}
