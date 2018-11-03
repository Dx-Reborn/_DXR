//=============================================================================
// MenuChoice_Subtitles
//=============================================================================

class MenuChoice_Subtitles extends MenuChoice_OnOff;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(int(DeusExPlayer(PlayerOwner().pawn).bSubtitles));
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).bSubtitles = bool(GetValue());
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(int(DeusExPlayer(PlayerOwner().pawn).bSubtitles));
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    Hint="If subtitles are On, conversation dialogue will be displayed on-screen."
    actionText="Subtitles"
}
