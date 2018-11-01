//=============================================================================
// MenuChoice_LowMedHigh
// Base class for texture details options.
//=============================================================================

class MenuChoice_LowMedHigh extends DXREnumButton;

var String englishEnumText[9];

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	local String detailString;
	local int enumIndex;
	local int detailChoice;

	detailString = playerOwner().ConsoleCommand("get " $ configSetting);
	detailChoice = 0;

	for (enumIndex=0; enumIndex<arrayCount(enumText); enumIndex++)
	{
		if (englishEnumText[enumIndex] ~= detailString)
		{
			detailChoice = enumIndex;
			break;
		}	
	}
	SetValue(detailChoice);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	playerOwner().ConsoleCommand("set " $ configSetting $ " " $ englishEnumText[GetValue()]);
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
		EnumText(0)="UltraLow"
		EnumText(1)="VeryLow"
		EnumText(2)="Low"
		EnumText(3)="Lower"
		EnumText(4)="Normal"
		EnumText(5)="Higher"
		EnumText(6)="High"
		EnumText(7)="VeryHigh"
		EnumText(8)="UltraHigh"

		englishEnumText(0)="UltraLow"
		englishEnumText(1)="VeryLow"
		englishEnumText(2)="Low"
		englishEnumText(3)="Lower"
		englishEnumText(4)="Normal"
		englishEnumText(5)="Higher"
		englishEnumText(6)="High"
		englishEnumText(7)="VeryHigh"
		englishEnumText(8)="UltraHigh"
}
