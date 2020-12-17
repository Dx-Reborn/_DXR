
class MenuChoice_MaxLogLines extends MenuUIChoiceSlider;

/*
function LoadSetting()
{
    SetValue(player.GetMaxLogLines());
}


function SaveSetting()
{
    player.SetMaxLogLines(GetValue());
}

function ResetToDefault()
{
    player.UpdateSensitivity(defaultValue);
}

function SetEnumerators()
{
    local int enumIndex;

    for(enumIndex=1; enumIndex<11;enumIndex++)
        SetEnumeration(enumIndex-1, enumIndex);
}

*/

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     numTicks=6
     startValue=2
     endValue=8.00
     defaultValue=3.00
     Hint="Maximum number of log lines visible on the screen at any given time"
     actionText="Max. Log Lines"
}
