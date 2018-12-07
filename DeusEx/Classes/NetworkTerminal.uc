/**/
class NetworkTerminal extends floatingWindow;

var() ComputerUIWindow           winComputer;		// Currently active computer screen
var() HackWin winHack;			// Ice Breaker Hack Window
var() ComputerScreenHackAccounts winHackAccounts; // Hack Accounts Window, used for email
var() ElectronicDevices compOwner;		// what computer owns this window?
var() DeusExPlayer player;

var class<ComputerUIWindow> FirstScreen;	// First screen to push

// Hacking related variables
var float loginTime;			// time that the user logged in
var float detectionTime;		// total time a user may be logged on
var int   skillLevel;			// player's computer skill level (0-3)
var bool  bHacked;				// this computer has been hacked
var bool  bNoHack;				// this computer has been purposely not hacked
var bool  bUsesHackWindow;		// True if Hack Window created by default.
var editconst bool  bTickEnabled;

// Login related variables
var string userName;
var int    userIndex;

// ----------------------------------------------------------------------
// InitWindow()
//
// Initialize the Window
// ----------------------------------------------------------------------
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController, MyOwner);

  player = DeusExPlayer(playerOwner().pawn);
  CreateHackWindow();
  DeusExHUD(PlayerOwner().MyHUD).menuMode = true;
	bTickEnabled = true;

	if (player.DataLinkPlay != none)
	    player.DataLinkPlay.terminal = self;
}

// ----------------------------------------------------------------------
// DestroyWindow()
//
// Destroys the Window
// ----------------------------------------------------------------------
//event DestroyWindow()
event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
	if (compOwner.IsA('Computers'))
	{
		// Keep track of the last time this computer was hacked
		if (bHacked)
			Computers(compOwner).lastHackTime = player.Level.TimeSeconds;

		Computers(compOwner).termWindow = None;
	}
	else if (compOwner.IsA('ATM'))
	{
		// Keep track of the last time this computer was hacked
		if (bHacked)
			ATM(compOwner).lastHackTime = player.Level.TimeSeconds;

		ATM(compOwner).atmWindow = None;
	}

  DeusExHUD(PlayerOwner().MyHUD).menuMode = false;

  if (player.DataLinkPlay != none)
	    player.DataLinkPlay.terminal = none;

	// Now finish destroy us.
	Super.Closed(Sender, bCancelled); // DestroyWindow();
}

// ----------------------------------------------------------------------
// Tick()
//
// Checks to see if the player has died, and if so, gets us the 
// hell out of this screen!!
// ----------------------------------------------------------------------
//function Tick(float deltaTime)
function InternalOnRendered(Canvas u)
{
  if (!bTickEnabled)
  return;

	if ((player != None) && (player.IsInState('Dying')))
	{
		bTickEnabled = false;
		CloseScreen("EXIT");	
	}

	// Update the hack bar detection time
	UpdateHackDetectionTime();
}


// ----------------------------------------------------------------------
// ShowFirstScreen()
// ----------------------------------------------------------------------

function ShowFirstScreen()
{
	ShowScreen(FirstScreen);
}

// ----------------------------------------------------------------------
// ShowScreen()
// ----------------------------------------------------------------------

function ShowScreen(class<ComputerUIWindow> newScreen)
{
	// First close any existing screen
	if (winComputer != None)
	{
//		winComputer.Destroy();
		winComputer.free();
//    winComputer.controller.CloseMenu();
//		winComputer = None;
	}

	// Now invoke the new screen
	if (newScreen != None)
	{
	  winComputer = ComputerUIWindow(DeusExGUIController(controller).OpenMenuEx(""$string(newScreen)));
	  winComputer.SetNetworkTerminal(self);
	  winComputer.SetCompOwner(compOwner);
	}
}

// ----------------------------------------------------------------------
// CloseScreen()
// ----------------------------------------------------------------------

singular function CloseScreen(String action)
{
	// First destroy the current screen
	if (winComputer != None)
	{
//		winComputer.free();//Destroy();
    winComputer.controller.CloseMenu();
//		winComputer = None;
	}

	// Based on the action, proceed!
	if (action == "EXIT")
	{
//	  Controller.CloseMenu();
		Controller.CloseAll(false, true);//root.PopWindow();
		return;
	}

	// If the user is logging in and bypassing the Hack screen,
	// then destroy the Hack window

	if ((action == "LOGIN") && (winHack != None) && (!bHacked))
	{
		CloseHackWindow();
		bNoHack = true;
	}
}

// ----------------------------------------------------------------------
// CloseHackWindow()
// ----------------------------------------------------------------------

function CloseHackWindow()
{
	if (winHack != None)
	{
//		winHack.free();//Destroy();
//		winHack = None;
		winHack.controller.CloseMenu();

//		winHackShadow.Destroy();
//		winHackShadow = None;
	}
}

// ----------------------------------------------------------------------
// ForceCloseScreen()
// ----------------------------------------------------------------------

function ForceCloseScreen()
{
	// If a screen is active, tell it to exit
	if (winComputer != None)
		winComputer.CloseScreen(winComputer.escapeAction);
}

// ----------------------------------------------------------------------
// CreateHackWindow()
// ----------------------------------------------------------------------

function CreateHackWindow()
{
	local float hackTime;
	local float skillLevelValue;

	skillLevelValue = player.SkillSystem.GetSkillLevelValue(class'SkillComputer');
	skillLevel      = player.SkillSystem.GetSkillLevel(class'SkillComputer');

	// Check to see if the player is skilled in Hacking before 
	// creating the window
	if ((skillLevel > 0) && (bUsesHackWindow))
	{
		// Base the detection and hack time on the skill level
		hackTime       = detectionTime / (skillLevelValue * 1.5);
		detectionTime *= skillLevelValue;

		// First create the shadow window
		//winHackShadow = ShadowWindow(NewChild(Class'ShadowWindow'));

		winHack = HackWin(DeusExGUIController(Controller).OpenMenuEx("DeusEx.HackWin")); //ComputerScreenHack(NewChild(Class'ComputerScreenHack'));
		winHack.SetNetworkTerminal(Self);
		winHack.SetDetectionTime(detectionTime, hackTime);
	}
}

// ----------------------------------------------------------------------
// CreateHackAccountsWindow()
//
// Create the window used to hack email accounts, but only create it if
// the player hacked into the computer *and* there's more than one 
// account to display
// ----------------------------------------------------------------------

function CreateHackAccountsWindow()
{
	if ((bHacked) && (winHackAccounts == None) && (Computers(compOwner).NumUsers() > 1))
	{
		// First create the shadow window
//		winHackAccountsShadow = ShadowWindow(NewChild(Class'ShadowWindow'));

		winHackAccounts = ComputerScreenHackAccounts(DeusExGUIController(Controller).OpenMenuEx("DeusEx.ComputerScreenHackAccounts"));
		winHackAccounts.SetNetworkTerminal(Self);
		winHackAccounts.SetCompOwner(compOwner);
	}
}

// ----------------------------------------------------------------------
// CloseHackAccountsWindow()
// ----------------------------------------------------------------------

function CloseHackAccountsWindow()
{
	if (winHackAccounts != None)
	{
//		winHackAccounts.free();//Destroy();
//		winHackAccounts = None;
		winHackAccounts.controller.CloseMenu();

//		winHackAccountsShadow.Destroy();
//		winHackAccountsShadow = None;
	}
}

// ----------------------------------------------------------------------
// SetHackButtonToReturn()
// ----------------------------------------------------------------------

function SetHackButtonToReturn()
{
	if ((bHacked) && (winHack != None))
		winHack.SetHackButtonToReturn();
}

// ----------------------------------------------------------------------
// SetCompOwner()
// ----------------------------------------------------------------------

function SetCompOwner(ElectronicDevices newCompOwner)
{
	compOwner = newCompOwner;

	if (winComputer != None)
		winComputer.SetCompOwner(compOwner);

	// Update the hack bar detection time
	UpdateHackDetectionTime();
}

// ----------------------------------------------------------------------
// UpdateHackDetectionTime()
// ----------------------------------------------------------------------

function UpdateHackDetectionTime()
{
	local float diff;
	local float AdetectionTime;

	// If the hack window is active, then we need to update 
	// the detection time
	if ((winHack != None) && (!winhack.bHacking) && (compOwner != None) && (!bHacked))
	{
		AdetectionTime = winHack.GetSaveDetectionTime();

		if (compOwner.IsA('Computers')) 
			diff = player.Level.TimeSeconds - Computers(compOwner).lastHackTime;
		else
			diff = player.Level.TimeSeconds - ATM(compOwner).lastHackTime;

		if (diff < AdetectionTime)
			winHack.UpdateDetectionTime(diff + 0.5);
	}
}

// ----------------------------------------------------------------------
// SetLoginInfo()
// ----------------------------------------------------------------------

function SetLoginInfo(String newUserName, Int newUserIndex)
{
	userName  = newUserName;
	userIndex = newUserIndex;
}

// ----------------------------------------------------------------------
// ChangeAccount()
// ----------------------------------------------------------------------

function ChangeAccount(int newUserIndex)
{
	userIndex = newUserIndex;

	if (compOwner != None)
		userName  = Computers(compOwner).GetUserName(userIndex);

	// Notify the computer window
	if (winComputer != None)
		winComputer.ChangeAccount();
}

// ----------------------------------------------------------------------
// GetUserName()
// ----------------------------------------------------------------------

function String GetUserName()
{
	return userName;
}

// ----------------------------------------------------------------------
// GetUserIndex()
// ----------------------------------------------------------------------

function int GetUserIndex()
{
	return userIndex;
}

// ----------------------------------------------------------------------
// SetSkillLevel()
// ----------------------------------------------------------------------

function SetSkillLevel(int newSkillLevel)
{
	skillLevel = newSkillLevel;
}

// ----------------------------------------------------------------------
// GetSkillLevel()
// ----------------------------------------------------------------------

function int GetSkillLevel()
{
	return skillLevel;
}

// ----------------------------------------------------------------------
// ComputerHacked()
//
// Computer was hacked, allow user to login
// ----------------------------------------------------------------------

function ComputerHacked()
{
	bHacked = True;

	// Use the first login
	userIndex = 0;
	
	if (compOwner.IsA('Computers'))
		userName  = Computers(compOwner).GetUserName(userIndex);
	
	CloseScreen("LOGIN");
}

// ----------------------------------------------------------------------
// HackDetected()
// ----------------------------------------------------------------------

function HackDetected(optional bool bDamageOnly)
{
	if (compOwner.IsA('Computers'))
	{
		Computers(compOwner).bLockedOut = True;
		Computers(compOwner).lockoutTime = player.Level.TimeSeconds;
	}
	else
	{
		ATM(compOwner).bLockedOut = True;
		ATM(compOwner).lockoutTime = player.Level.TimeSeconds;
	}

	// Shock the crap out of the player (drain BE and play a sound)
	// Highly skilled players take less damage
	player.TakeDamage(200 - 50 * skillLevel, None, vect(0,0,0), vect(0,0,0), class'DM_EMP');
	player.PlaySound(sound'ProdFire');

	if (!bDamageOnly)
		CloseScreen("EXIT");
}

// ----------------------------------------------------------------------
// AreSpecialOptionsAvailable()
// ----------------------------------------------------------------------

function bool AreSpecialOptionsAvailable(optional bool bCheckActivated)
{
	local int i;
	local bool bOK;

	bOK = False;
	for (i=0; i<ArrayCount(Computers(compOwner).specialOptions); i++)
	{
		if (Computers(compOwner).specialOptions[i].Text != "")
		{
			if ((Computers(compOwner).specialOptions[i].userName == "") || (Caps(Computers(compOwner).specialOptions[i].userName) == userName))
			{
				// Also check if the "bCheckActivated" bool is set, in which case we also 
				// want to make sure the item hasn't already been triggered.

				if (!((bCheckActivated) && (Computers(compOwner).specialOptions[i].bAlreadyTriggered)))
				{
					bOK = True;
					break;
				}
			}
		}
	}
	return bOK;
}

function AddSystemMenu();

function bool OnCanClose(optional Bool bCancelled)
{
    /*if (bCancelled) return true
    else*/ return false;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    detectionTime=15.00
    bUsesHackWindow=true
    OnRendered=InternalOnRendered
    bAllowedAsLast=true

		DefaultHeight=0
		DefaultWidth=0
		MaxPageHeight=0
		MaxPageWidth=0
		MinPageHeight=0
		MinPageWidth=0
    bResizeWidthAllowed=false
    bResizeHeightAllowed=false

}
