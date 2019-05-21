//=============================================================================
// MenuChoice_DrawDistanceLOD
// ¬ некоторых модах на STALKER графические опции подсвечены разными цветами,
// в зависимости от вли€ни€ на производительность. «десь использована эта иде€.
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
    defaultValue=1.0

    Hint="Value less than 1.0 will increase distance fog, thus increasing performance. 1.0 by default, so in this case distance fog will match with level defaults.|Keep in mind that at lower values, some far objects can become invisible, since fog will hide them."
    actionText="Relative fog distance"
    configSetting="ini:Engine.Engine.ViewportManager DrawDistanceLOD"

		EnumText(0)="_€_0.1" // ѕодсветка зеленым
		EnumText(1)="_€_0.2"
		EnumText(2)="_€_0.3"
		EnumText(3)="_€_0.4"
		EnumText(4)="€€_0.5" // ∆елтый
		EnumText(5)="€€_0.6"
		EnumText(6)="€€_0.7"
		EnumText(7)="€€_0.8"
		EnumText(8)="€0.9"
		EnumText(9)="€1.0" //  расный

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
