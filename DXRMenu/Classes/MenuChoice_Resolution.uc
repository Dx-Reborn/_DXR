//=============================================================================
// MenuChoice_Resolution
//=============================================================================

class MenuChoice_Resolution extends DXREnumButton;

var string CurrentRes;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
  local string currentResX, currentResY;

	Super.Initcomponent(MyController, MyOwner);

	currentResX = PlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager FullscreenViewportX");
	currentResY = PlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager FullscreenViewportY");

	currentRes = currentResX$"x"$currentResY;
}


// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	local int choiceIndex;
	local int currentChoice;

	currentChoice = 0;

	for(choiceIndex=0; choiceIndex<arrayCount(enumText); choiceIndex++)
	{
		if (enumText[choiceIndex] == "")	
			break;

		if (enumText[choiceIndex] ~= CurrentRes)// == CurrentRes)
		{
			currentChoice = choiceIndex;
			break;
		}
	}

	SetValue(currentChoice);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	local String resText, resX, resY;

	// Only attempt to change resolutions if the resolution has 
	// actually changed.
	resText = enumText[GetValue()];
  Divide(resText, "x", resX, resY);

	if (resText != playerOwner().ConsoleCommand("GetCurrentRes"))
	{
		playerOwner().ConsoleCommand("SetRes " $ resText$"f"); // f = FullScrenn, w = window size
    PlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager FullscreenViewportX "$resX);
    PlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager FullscreenViewportY "$resY);
	}
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	// Reset to the current resolution
	LoadSetting();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
  Hint="Change the video resolution for FullScreen mode"
  actionText="FullScreen Resolution"

	EnumText(0)="800x600"
	EnumText(1)="1024x768"
	EnumText(2)="1152x864"
	EnumText(3)="1280x720"
	EnumText(4)="1280x768"
	EnumText(5)="1280x800"
	EnumText(6)="1280x960"
	EnumText(7)="1280x1024"
	EnumText(8)="1360x768"
	EnumText(9)="1360x1024"
	EnumText(10)="1366x768"
	EnumText(11)="1440x900"
	EnumText(12)="1600x900"
	EnumText(13)="1680x1050"
	EnumText(14)="1920x1080"
}
