//=============================================================================
// MenuChoice_UIBackground
//=============================================================================

class MenuChoice_UIBackground extends DXREnumButton;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(DeusExPlayer(PlayerOwner().pawn).UIBackground);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(PlayerOwner().pawn).UIBackground = GetValue();

/*	if (player.UIBackground == 1)
		DeusExRootWindow(player.rootWindow).Hide();

	DeusExRootWindow(player.rootWindow).ShowSnapshot();

	if (player.UIBackground == 1)
		DeusExRootWindow(player.rootWindow).Show();*/
}

// ----------------------------------------------------------------------
// ResetToDefault()
// ----------------------------------------------------------------------

function ResetToDefault()
{
	SetValue(defaultValue);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    enumText(0)="Render 3D"
    enumText(1)="Snapshot"
    enumText(2)="Black"
    Hint="Determines what is displayed under menus and 2D screens.  Render 3D is good for fast machines, followed by Snapshot and then Black."
    actionText="UI/Menu Background"
}
