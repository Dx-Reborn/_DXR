//=============================================================================
// MenuChoice_AdjustBrightness
//=============================================================================

class MenuChoice_AdjustBrightness extends MenuChoice_1_0_Range;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	saveValue = float(playerOwner().ConsoleCommand("get" @ configSetting));

	Super.LoadSetting();
}

// ----------------------------------------------------------------------
// CancelSetting()
// ----------------------------------------------------------------------

function CancelSetting()
{
	playerOwner().ConsoleCommand("set" @ configSetting @ saveValue);
//	playerOwner().ConsoleCommand("FLUSH");
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	Super.ResetToDefault();

//	playerOwner().ConsoleCommand("FLUSH");
}

function SliderOnChange(GUIComponent Sender)
{
   info.SetText(String(btnSlider.Value));
   playerOwner().ConsoleCommand("set" @ configSetting @ GetValue());
//   playerOwner().ConsoleCommand("FLUSH");
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    numTicks=21
    endValue=1.00
    defaultValue=0.80
    actionText="Brightness"
    configSetting="ini:Engine.Engine.ViewportManager Brightness"
}