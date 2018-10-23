//=============================================================================
// MenuChoice_EffectsChannels
//=============================================================================

class MenuChoice_EffectsChannels extends MenuUIChoiceSlider;

// ----------------------------------------------------------------------
// SetEnumerators()
// ----------------------------------------------------------------------

function SetEnumerators()
{
	local int enumIndex;
	local int counter;

	counter = 0;

	for(enumIndex=4;enumIndex<33;enumIndex++)
	{
		SetEnumeration(counter, enumIndex);
		counter++;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    numTicks=32
    startValue=4.00
    endValue=32.00
    defaultValue=32.00
    Hint="Number of sound effects channels"
    actionText="Effects Channels"
    configSetting="ini:Engine.Engine.AudioDevice Channels"
    bInteger=true
}
