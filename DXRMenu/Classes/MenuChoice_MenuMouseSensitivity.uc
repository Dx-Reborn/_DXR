//=============================================================================
// MenuChoice_MenuMouseSensitivity
//=============================================================================

class MenuChoice_MenuMouseSensitivity extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	saveValue = Controller.MenuMouseSens;
	SetValue(Controller.MenuMouseSens);
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
    Controller.MenuMouseSens = saveValue;
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
  Controller.MenuMouseSens = defaultValue;
	SetValue(Controller.MenuMouseSens);
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	local int enumIndex;

	for(enumIndex=1;enumIndex<11;enumIndex++)
		SetEnumeration(enumIndex-1, enumIndex);
}

// ----------------------------------------------------------------------
// Update the Mouse Sensitivity value
// ----------------------------------------------------------------------

function SliderOnChange(GUIComponent Sender)
{
   info.SetText(String(btnSlider.Value));
   Controller.MenuMouseSens = GetValue();
}

function SaveSetting()
{
   Controller.MenuMouseSens = GetValue();
   Controller.SaveConfig();
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    numTicks=10
    startValue=1.00
    endValue=6.0
    defaultValue=1.25
    hint="Modifies the mouse sensitivity for Interface (menus and dialogs)"
    actionText="Mouse Sensitivity (Interface)"
}
