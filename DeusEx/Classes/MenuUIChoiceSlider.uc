//=============================================================================
// MenuUIChoiceSlider
//=============================================================================

class MenuUIChoiceSlider extends DXREnumButton;

// Defaults
var() DXRSlider btnSlider; // pointer to slider

var int numTicks;
var float startValue;
var float endValue;
//var float defaultValue;
var float saveValue;
var bool  bInteger;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
  super.InitComponent(MyController, MyOwner);
/*	bInitializing=True;

	Super.InitWindow();

	CreateSlider();
	SetEnumerators();

	bInitializing=False;*/
}

// ----------------------------------------------------------------------
// CreateSlider()
// ----------------------------------------------------------------------

function InitSlider()
{
/*	btnSlider = MenuUISliderButtonWindow(NewChild(Class'MenuUISliderButtonWindow'));

	btnSlider.SetSelectability(False);
	btnSlider.SetPos(choiceControlPosX, 0);*/
	if (btnSlider != none)
	{
    btnSlider.SetTicks(numTicks, startValue, endValue);
    btnSlider.bIntSlider = bInteger;
    btnSlider.OnChange = SliderOnChange;
    SetEnumerators();
    info.SetText(string(btnSlider.value));

    LoadSetting();
	}
}

function SliderOnChange(GUIComponent Sender)
{
   info.SetText(String(btnSlider.Value));
}

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------
function SetEnumerators();

// ----------------------------------------------------------------------
// SetEnumeration()
// ----------------------------------------------------------------------

function SetEnumeration(int tickPos, coerce string newStr)
{
	if (btnSlider != None)
		btnSlider.SetEnumeration(tickPos, newStr);
}

// ----------------------------------------------------------------------
// SetValue()
// ----------------------------------------------------------------------

function SetValue(float newValue)
{
//	if (btnSlider  != None)

		btnSlider.SetValue(newValue);
		SliderOnChange(btnSlider);

//	if (info != none)
	  info.SetText(string(newValue));

}

// ----------------------------------------------------------------------
// GetValue()
// ----------------------------------------------------------------------

function float GetValue()
{
	if (btnSlider != None)
		return float(btnSlider.GetValueString());
	else
		return 0;
}

// ----------------------------------------------------------------------
// CycleNextValue()
// ----------------------------------------------------------------------

function CycleNextValue()
{
	local float /*int*/ newValue;

	if (btnSlider != None)
	{
		// Get the current slider value and attempt to increment.
		// If at the max go back to the beginning
		// Порой поражаюсь сама себе... /*GetMarkerPosition()*/
		newValue = btnSlider.value + 1;

		if (newValue == btnSlider.GetNumTicks())
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

		newValue = btnSlider.value - 1;

		if (newValue < 0)
			newValue = btnSlider.GetNumTicks() - 1;

		btnSlider.SetValue(newValue);
		SliderOnChange(btnSlider);
	}
}

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	if (configSetting != "")
		SetValue(float(playerOwner().ConsoleCommand("get " $ configSetting)));
	else
		ResetToDefault();
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	if (configSetting != "")
		playerOwner().ConsoleCommand("set " $ configSetting $ " " $ GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	if (configSetting != "")
	{
		playerOwner().ConsoleCommand("set " $ configSetting $ " " $ defaultValue);
		LoadSetting();
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    numTicks=11
    endValue=10.00
    actionText="Slider Choice"
//    bInteger = true
}
