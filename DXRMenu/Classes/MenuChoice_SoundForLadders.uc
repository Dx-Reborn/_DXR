/*

*/
class MenuChoice_SoundForLadders extends MenuChoice_OnOff;


function LoadSetting()
{
    SetValue(int(DeusExPlayer(PlayerOwner().pawn).bSoundsForLadderVolumes));
}

function SaveSetting()
{
    DeusExPlayer(PlayerOwner().pawn).bSoundsForLadderVolumes = bool(GetValue());
}

function ResetToDefault()
{
    DeusExPlayer(PlayerOwner().pawn).bSoundsForLadderVolumes = bool(defaultValue);
    SetValue(defaultValue);
    ChangeStyle();
}

function CycleNextValue()
{
    Super.CycleNextValue();
    DeusExPlayer(PlayerOwner().pawn).bSoundsForLadderVolumes = bool(GetValue());
    ChangeStyle();
}

function CyclePreviousValue()
{
    Super.CyclePreviousValue();
    DeusExPlayer(PlayerOwner().pawn).bSoundsForLadderVolumes = bool(GetValue());
    ChangeStyle();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Step sounds for ladders. If you want to climb ladders silently, turn this off (does not affects gameplay at all)"
    actionText="Use sounds for ladders"
}
