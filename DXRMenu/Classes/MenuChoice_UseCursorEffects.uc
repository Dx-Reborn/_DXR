//=============================================================================
// MenuChoice_UseCursorEffects
//=============================================================================

class MenuChoice_UseCursorEffects extends MenuChoice_OnOff;


function LoadSetting()
{
	SetValue(int(!gl.bUseCursorEffects));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	gl.bUseCursorEffects = !bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!gl.bUseCursorEffects));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Use effects to display text for descriptions and other text contents. Otherwise display whole text instantly."
    actionText="Text follows cursor"
}
