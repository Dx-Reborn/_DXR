//=============================================================================
// MenuChoice_LevelOfAnisotropy
//=============================================================================

class MenuChoice_LevelOfAnisotropy extends DXREnumButton;

var String englishEnumText[4];

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	local int detailFloat; //String detailString;
	local int enumIndex;
	local int detailChoice;

	detailFloat = int(playerOwner().ConsoleCommand("get " $ configSetting));
	detailChoice = 0;

	for (enumIndex=0; enumIndex<arrayCount(enumText); enumIndex++)
	{
		if (int(englishEnumText[enumIndex]) == detailFloat)
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
    defaultValue=1.0
   // From Wikipedia
    Hint="Like bilinear and trilinear filtering, anisotropic filtering eliminates aliasing effects, but improves on these other techniques by reducing blur and preserving detail at extreme viewing angles."
    actionText="Level Of Anisotropy"
    configSetting="ini:Engine.Engine.RenderDevice LevelOfAnisotropy"

		EnumText(0)="2"
		EnumText(1)="4"
		EnumText(2)="8"
		EnumText(3)="16"

		englishEnumText(0)="2"
		englishEnumText(1)="4"
		englishEnumText(2)="8"
		englishEnumText(3)="16"
}
