//=============================================================================
// MenuChoice_MouseSensitivity
//=============================================================================

class MenuChoice_MouseSensitivity extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	saveValue = class'PlayerInput'.default.MouseSensitivity;
	SetValue(class'PlayerInput'.default.MouseSensitivity);
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
    class'PlayerInput'.default.MouseSensitivity = saveValue;
    playerOwner().SetSensitivity(saveValue);
//	player.UpdateSensitivity(saveValue);
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
log("MenuChoice_MouseSensitivy::ResetToDefaults()----------------------");
log("  devaultValue = "$  defaultValue);

//	player.UpdateSensitivity(defaultValue);
  playerOwner().SetSensitivity(defaultValue);
	SetValue(class'PlayerInput'.default.MouseSensitivity);
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
   playerOwner().SetSensitivity(saveValue);
//   class'PlayerInput'.default.MouseSensitivity = GetValue();
     log(class'PlayerInput'.default.MouseSensitivity @ GetValue());
}

function SaveSetting()
{
//  class'PlayerInput'.default.MouseSensitivity = GetValue();
  playerOwner().SetSensitivity(GetValue());
	class'PlayerInput'.static.StaticSaveConfig();
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    numTicks=10
    startValue=1.00
    endValue=25.0
    defaultValue=3.00
    hint="Modifies the mouse sensitivity"
    actionText="Mouse Sensitivity (In-Game)"
}
