//=============================================================================
// 0 = Pause game, 1 = Set gamespeed to 0.1, 2 = Do nothing (RealTime)
//=============================================================================

class MenuChoice_PlayerInterfaceMode extends DXREnumButton;

// ----------------------------------------------------------------------
// LoadSetting()
// ----------------------------------------------------------------------

function LoadSetting()
{
	SetValue(DeusExPlayer(playerOwner().pawn).InterfaceMode);
}

// ----------------------------------------------------------------------
// SaveSetting()
// ----------------------------------------------------------------------

function SaveSetting()
{
	DeusExPlayer(playerOwner().pawn).InterfaceMode = GetValue();
	DeusExPlayer(playerOwner().pawn).SaveConfig();
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
    enumText(0)="Pause"
    enumText(1)="Slowdown"
    enumText(2)="Realtime"
    defaultValue=0
    Hint="When one of PlayerManagement screens is opened (Inventory, Notes, etc.), set the game into corresponding state. Pause: Pause game. Slowdown: reduce game speed for 10 times. Realtime: do nothing, so all game events will work as usually."
    actionText="PlayerManagement interface mode"
}
