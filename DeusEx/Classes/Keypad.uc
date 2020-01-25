//=============================================================================
// Keypad.
//=============================================================================
class Keypad extends HackableDevices
	abstract;

var() string validCode;
var() sound successSound;
var() sound failureSound;
var() name FailEvent;
var() bool bToggleLock;		// if True, toggle the lock state instead of triggering

// ----------------------------------------------------------------------
// HackAction()
// ----------------------------------------------------------------------

function HackAction(Actor Hacker, bool bHacked)
{
	local DeusExPlayer Player;

	Player = DeusExPlayer(Hacker);

	if (Player != None)
	{
			DeusExPlayerController(Level.GetLocalPlayerController()).ClientOpenMenu("DXRMenu.DXR_KeyPad");
	}
}


defaultproperties
{
     validCode="1234"
     successSound=Sound'DeusExSounds.Generic.Beep2'
     failureSound=Sound'DeusExSounds.Generic.Buzz1'
     bToggleLock=True
     ItemName="Security Keypad"
     Mass=10.000000
     Buoyancy=5.000000
}
