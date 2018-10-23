//=============================================================================
// MenuChoice_InvertMouse
//=============================================================================

class MenuChoice_InvertMouse extends MenuChoice_EnabledDisabled;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
//	SetValue(int(!class'PlayerInput'.default.bInvertMouse));
//	SetValue(int(class'PlayerInput'.default.bInvertMouse));
	if (class'PlayerInput'.default.bInvertMouse)
	SetValue(0);
    else
	SetValue(1);

}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	//class'PlayerInput'.default.bInvertMouse = /*!*/bool(GetValue());

	PlayerOwner().InvertMouse(string(!bool(GetValue())));

	class'PlayerInput'.static.StaticSaveConfig();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(!class'PlayerInput'.default.bInvertMouse));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    hint="Inverts the vertical mouse axis so when you push up you look down and vice versa"
    actionText="Invert Mouse"
}
