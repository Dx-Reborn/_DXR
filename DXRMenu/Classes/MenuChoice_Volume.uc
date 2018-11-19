//=============================================================================
// MenuChoice_Volume
//=============================================================================

class MenuChoice_Volume extends MenuUIChoiceSlider;

var localized String VolumeOffText;
var localized String VolumeMaxText;

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	// The first sliders use the same enumerations
	SetEnumeration(0, VolumeOffText);
	SetEnumeration(1, "0.1");
	SetEnumeration(2, "0.2");
	SetEnumeration(3, "0.3");
	SetEnumeration(4, "0.4");
	SetEnumeration(5, "0.5");
	SetEnumeration(6, "0.6");
	SetEnumeration(7, "0.7");
	SetEnumeration(8, "0.8");
	SetEnumeration(9, "0.9");
	SetEnumeration(10, "1.0");
	SetEnumeration(11, VolumeMaxText);
}

function CycleNextValue()
{
	local float /*int*/ newValue;

	if (btnSlider != None)
	{
		// Get the current slider value and attempt to increment.
		// If at the max go back to the beginning
		newValue = btnSlider.value + 0.1;

		if (newValue == btnSlider.value)
			newValue = 0;

		btnSlider.SetValue(newValue);
		SliderOnChange(btnSlider);
	}
}

// ----------------------------------------------------------------------
// CyclePreviousValue()
// ----------------------------------------------------------------------

function CyclePreviousValue()
{
	local float newValue;

	if (btnSlider != None)
	{
		// Get the current slider value and attempt to increment.
		// If at the max go back to the beginning
		newValue = btnSlider.value - 0.1;

		if (newValue <= 0)
			newValue = btnSlider.Value - 0.1;

		btnSlider.SetValue(newValue);
		SliderOnChange(btnSlider);
	}
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    VolumeOffText="OFF"
    VolumeMaxText="MAX"
    numTicks=12//  11
    startValue=0.00
    endValue=1.00
}
