//=============================================================================
// MenuChoice_DrawDistanceLOD
// В некоторых модах на STALKER графические опции подсвечены разными цветами,
// в зависимости от влияния на производительность. Здесь использована эта идея.
//=============================================================================

class MenuChoice_DetailTexMipBias extends DXREnumButton;

var String englishEnumText[21];

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
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1.0

    Hint="Values less than 0 will add fake 'sharpness' to extra detail layer of textures, but will decrease performance, and vice versa."
    actionText="Detail Textures Mip Bias"
    configSetting="ini:Engine.Engine.RenderDevice DetailTexMipBias"

		EnumText(0)="-1.0"
		EnumText(1)="-0.9"
		EnumText(2)="-0.8"
		EnumText(3)="-0.7"
		EnumText(4)="-0.6"
		EnumText(5)="-0.5"
		EnumText(6)="-0.4"
		EnumText(7)="-0.3"
		EnumText(8)="-0.2"
		EnumText(9)="-0.1"
		EnumText(10)="0.0"
    EnumText(11)="0.1"
    EnumText(12)="0.2"
    EnumText(13)="0.3"
    EnumText(14)="0.4"
    EnumText(15)="0.5"
    EnumText(16)="0.6"
    EnumText(17)="0.7"
    EnumText(18)="0.8"
    EnumText(19)="0.9"
    EnumText(20)="1.0"

		englishEnumText(0)="-1.000000"
		englishEnumText(1)="-0.900000"
		englishEnumText(2)="-0.800000"
		englishEnumText(3)="-0.700000"
		englishEnumText(4)="-0.600000"
		englishEnumText(5)="-0.500000"
		englishEnumText(6)="-0.400000"
		englishEnumText(7)="-0.300000"
		englishEnumText(8)="-0.200000"
		englishEnumText(9)="-0.100000"
		englishEnumText(10)="0.000000"
    englishEnumText(11)="0.100000"
    englishEnumText(12)="0.200000"
    englishEnumText(13)="0.300000"
    englishEnumText(14)="0.400000"
    englishEnumText(15)="0.500000"
    englishEnumText(16)="0.600000"
    englishEnumText(17)="0.700000"
    englishEnumText(18)="0.800000"
    englishEnumText(19)="0.900000"
    englishEnumText(20)="1.000000"

}
