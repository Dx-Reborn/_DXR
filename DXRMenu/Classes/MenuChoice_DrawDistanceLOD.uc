//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_DrawDistanceLOD extends DXREnumButton;

var String englishEnumText[10];

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	local float detailFloat; //String detailString;
	local int enumIndex;
	local int detailChoice;

	detailFloat = float(playerOwner().ConsoleCommand("get " $ configSetting));
	detailChoice = 0;

	for (enumIndex=0; enumIndex<arrayCount(enumText); enumIndex++)
	{
		if (float(englishEnumText[enumIndex]) == detailFloat)
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
  playerOwner().Level.UpdateDistanceFogLOD(GetValue());
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=5

    Hint="Less value will increase distance fog, thus incresing performance. 1.0 by default, so in this case distance fog will match with level defaults."
    actionText="Relative fog distance"
    configSetting="ini:Engine.Engine.ViewportManager DrawDistanceLOD"

		EnumText(0)="0.1"
		EnumText(1)="0.2"
		EnumText(2)="0.3"
		EnumText(3)="0.4"
		EnumText(4)="0.5"
		EnumText(5)="0.6"
		EnumText(6)="0.7"
		EnumText(7)="0.8"
		EnumText(8)="0.9"
		EnumText(9)="1.0"

		englishEnumText(0)="0.1"
		englishEnumText(1)="0.2"
		englishEnumText(2)="0.3"
		englishEnumText(3)="0.4"
		englishEnumText(4)="0.5"
		englishEnumText(5)="0.6"
		englishEnumText(6)="0.7"
		englishEnumText(7)="0.8"
		englishEnumText(8)="0.9"
		englishEnumText(9)="1.0"

}
