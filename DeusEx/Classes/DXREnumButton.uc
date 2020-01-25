/* Адаптация из оригинала */

class DXREnumButton extends GUIButton;

var() DXRChoiceInfo Info; // EditBox для вывода значения.
var() localized String enumText[40];
var() int    currentEnum;
var() int    currentValue;
var /*int*/ float    defaultValue;
var localized String configSetting;
var localized String actionText;
var localized String FalseTrue[2];

var transient bool bSavingChanges, bReloadSound;

var transient DeusExGlobals gl;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    Super.InitComponent(MyController, MyOwner);
    Caption = actionText;

    gl = class'DeusExGlobals'.static.GetGlobals();
}


function bool IntOnClick(GUIComponent Sender)         // The mouse was clicked on this control
{
	CycleNextValue();
  return true;
}

function bool IntOnRightClick(GUIComponent Sender)    // Return false to prevent context menu from appearing
{
  CyclePreviousValue();
  return true;
}

function CycleNextValue()
{
	local int newValue;

	// Cycle to the next value, but make sure we don't exceed the 
	// bounds of the enumText array.  If we do, start back at the 
	// bottom.

	newValue = GetValue() + 1;

	if (newValue == arrayCount(enumText))
		newValue = 0;
	else if (enumText[newValue] == "")
		newValue = 0;

	SetValue(newValue);
}

function CyclePreviousValue()
{
	local int newValue;

	// Cycle to the next value, but make sure we don't exceed the 
	// bounds of the enumText array.  If we do, start back at the 
	// bottom.

	newValue = GetValue() - 1;

	if (newValue < 0)
	{
		newValue = arrayCount(enumText) - 1;

		while((enumText[newValue] == "") && (newValue > 0))
			newValue--;	
	}

	SetValue(newValue);
}

function SetValue(float newValue)
{
	currentValue = newValue;
	UpdateInfoButton();
}

function float GetValue()
{
	return currentValue;
}

function UpdateInfoButton()
{
	Info.SetText(enumText[currentValue]);
}


function LoadSetting()
{
	if (configSetting != "")
		SetValue(int(playerOwner().ConsoleCommand("get " $ configSetting)));
	else
		ResetToDefault();
}

function LoadSettingBool()
{
	local String boolString;

	boolString = playerOwner().ConsoleCommand("get " $ configSetting);

	if (boolString == "True")
		setValue(1);
	else
		setValue(0);
}

function SaveSetting()
{
	if (configSetting != "")
		playerOwner().ConsoleCommand("set " $ configSetting $ " " $ GetValue());
}

function SaveSettingBool()
{
	playerOwner().ConsoleCommand("set " $ configSetting $ " " $ bool(GetValue()));
}

function ResetToDefault()
{
	if (configSetting != "")
	{
		playerOwner().ConsoleCommand("set " $ configSetting $ " " $ defaultValue);
		LoadSetting();
	}
}

function CancelSetting();
function ChangeStyle();


defaultproperties
{
  OnClick=IntOnClick
  OnRightClick=IntOnRightClick
	StyleName="STY_DXR_MediumButton"
  actionText="Choice"
  FalseTrue(0)="False"
  FalseTrue(1)="True"
	bBoundToParent=true
	bAutoShrink=false
	WinHeight=21
	WinWidth=144
}
