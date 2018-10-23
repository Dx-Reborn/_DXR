/**/

class MenuChoice_1_0_Range extends MenuUIChoiceSlider;

function CycleNextValue()
{
	local float newValue;

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
