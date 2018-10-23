//=============================================================================
// Computers.
//=============================================================================
class Computers extends ElectronicDevices
	abstract;

struct sSpecialOptions
{
	var()  string	Text; // localized
	var()  string	TriggerText; // localized
	var() string			userName;
	var() name				TriggerEvent;
	var() name				UnTriggerEvent;
	var() bool				bTriggerOnceOnly;
	var bool				bAlreadyTriggered;
	var() string ButtonToolTip; // New for DXR. Allows to add tooltip for the button.
};
var() sSpecialOptions specialOptions[4];

var class<NetworkTerminal> terminalType;
var NetworkTerminal termwindow;
var bool bOn;
var bool bAnimating;
var bool bLockedOut;				// true if this terminal is locked out
var() float lockoutDelay;			// delay until locked out terminal can be used
var float lockoutTime;				// time when terminal was locked out
var float lastHackTime;				// last time the terminal was hacked
var localized String msgLockedOut;

enum EAccessLevel
{
	AL_Untrained,
	AL_Trained,
	AL_Advanced,
	AL_Master
};

// userlist information
struct sUserInfo
{
	var() string		userName;
	var() string		password;
	var() EAccessLevel	accessLevel;
};

var() sUserInfo userList[8];

// specific location information
var() string nodeName;
var() string titleString;
var() texture titleTexture;

// NEW STUFF!!

enum EComputerNodes
{
	CN_UNATCO, 
	CN_VersaLife,
	CN_QueensTower,
	CN_USNavy,
	CN_MJ12Net,
	CN_PageIndustries,
	CN_Area51,
	CN_Everett,
	CN_NSF,
	CN_NYC,
	CN_China,
	CN_HKNet,
	CN_QuickStop,
	CN_LuckyMoney,
	CN_Illuminati
};

struct sNodeInfo
{
	var() localized string nodeName;
	var() localized string nodeDesc;
	var() string nodeAddress;
	var() Texture nodeTexture;
};

var() EComputerNodes ComputerNode;
var(nodes)   sNodeInfo NodeInfo[20];
var() string TextPackage;

// alarm vars
var float lastAlarmTime;		// last time the alarm was sounded
var int alarmTimeout;			// how long before the alarm silences itself

//
// Alarm functions for when you get caught hacking
//
function BeginAlarm()
{
	AmbientSound = Sound'Klaxon2';
	SoundVolume = 128;
	SoundRadius = 64;
	SoundPitch = 64;
	lastAlarmTime = Level.TimeSeconds;
	class'EventManager'.static.AIStartEvent(self, 'Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));

	// make sure we can't go into stasis while we're alarming
	bStasis = False;
}

function EndAlarm()
{
	AmbientSound = Default.AmbientSound;
	SoundVolume = Default.SoundVolume;
	SoundRadius = Default.SoundRadius;
	SoundPitch = Default.SoundPitch;
	lastAlarmTime = 0;
	class'EventManager'.static.AIEndEvent(self, 'Alarm', EAITYPE_Audio);

	// reset our stasis info
	bStasis = default.bStasis;
}

function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	// shut off the alarm if the timeout has expired
	if (lastAlarmTime != 0)
	{
		if (Level.TimeSeconds - lastAlarmTime >= alarmTimeout)
			EndAlarm();
	}
}

function ChangePlayerVisibility(bool bInviso)
{
	local DeusExPlayer player;

	player = DeusExPlayer(level.GetLocalPlayerController().pawn);
//	if (player != None)
//		player.MakePlayerIgnored(!bInviso);
}

// ----------------------------------------------------------------------
// state On
// ----------------------------------------------------------------------


state On
{
	function Tick(float deltaTime)
	{
		Global.Tick(deltaTime);

		if (bOn)
		{
			if (termwindow == None)
				GotoState('Off');
		}
	}

Begin:
	if (!bOn)
	{
		bAnimating = True;
		PlayAnim('Activate');
		FinishAnim();
		bOn = True;
		bAnimating = False;
		ChangePlayerVisibility(False);
		if (!Invoke())
			GotoState('Off');
	}
}

// ----------------------------------------------------------------------
// state Off
// ----------------------------------------------------------------------

auto state Off
{
Begin:
	if (bOn)
	{
		ChangePlayerVisibility(True);
		bAnimating = True;
		PlayAnim('Deactivate');
		FinishAnim();
		bOn = False;
		bAnimating = False;
		if (bLockedOut)
			BeginAlarm();

		// Resume any datalinks that may have started while we were 
		// in the computers (don't want them to start until we pop back out)
		ResumeDataLinks();
	}
}


function ResumeDataLinks()
{
	local DeusExPlayer player;

	player = DeusExPlayer(level.GetLocalPlayerController().pawn);
	if (player != None)
		player.ResumeDataLinks();
}

function bool Invoke()
{
//	local DeusExRootWindow root;
	local DeusExPlayerController player;

	if (termwindow != None)
		return false; // Окно все еще отправляет указатель на себя.

	player = DeusExPlayerController(level.GetLocalPlayerController());
	if (player != None)
	{
//	    player.ClientOpenMenu(terminalType);

			termwindow = NetworkTerminal(player.OpenMenuEx("DeusEx."$string(terminalType)));//  (root.InvokeUIScreen(terminalType, True));
			if (termwindow != None)
			{
				termWindow.SetCompOwner(Self);
				termWindow.ShowFirstScreen();
			}
	}

	return True;
}

function Frob(Actor Frobber, Inventory frobWith)
{
	local DeusExPlayer player;
	local float elapsed, delay;

	Super.Frob(Frobber, frobWith);

	player = DeusExPlayer(level.GetLocalPlayerController().pawn);
	if (player != None)
	{
		if (bLockedOut)
		{
			// computer skill shortens the lockout duration
			delay = lockoutDelay / player.SkillSystem.GetSkillLevelValue(class'SkillComputer');

			elapsed = Level.TimeSeconds - lockoutTime;
			if (elapsed < delay)
				player.ClientMessage(Sprintf(msgLockedOut, Int(delay - elapsed)));
			else
				bLockedOut = False;
		}
		if (!bAnimating && !bLockedOut)
			GotoState('On');
	}
}

function int NumUsers()
{
	local int i;

	for (i=0; i<ArrayCount(userList); i++)
		if (userList[i].userName == "")
			break;

	return i;
}

function string GetUserName(int userIndex)
{
	if ((userIndex >= 0) && (userIndex < ArrayCount(userList)))
		return userList[userIndex].userName;

	return "ERR";
}

function string GetPassword(int userIndex)
{
	if ((userIndex >= 0) && (userIndex < ArrayCount(userList)))
		return userList[userIndex].password;

	return "ERR";
}

function int GetAccessLevel(int userIndex)
{
	if ((userIndex >= 0) && (userIndex < ArrayCount(userList)))
		return Int(userList[userIndex].accessLevel);

	return 0;
}

function String GetNodeName()
{
	return nodeInfo[Int(ComputerNode)].nodeName;
}

function String GetNodeDesc()
{
	return nodeInfo[Int(ComputerNode)].nodeDesc;
}

function String GetNodeAddress()
{
	return nodeInfo[Int(ComputerNode)].nodeAddress;
}

function Texture GetNodeTexture()
{
	return nodeInfo[Int(ComputerNode)].nodeTexture;
}

function PreBeginPlay()
{
  super.PreBeginPlay();
  funcA();
}


/* UCC сходит с ума, если это поместить в defprops! У меня даже подходящих эмоций нет! */
function funcA()
{
    NodeInfo[0].nodeName="UNATCO";
    NodeInfo[0].nodeDesc="UNATCO";
    NodeInfo[0].nodeAddress="UN//UNATCO//RESTRICTED//923.128.6430";
    NodeInfo[0].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoUNATCO';

    NodeInfo[1].nodeName="VersaLife";
    NodeInfo[1].nodeDesc="VersaLife";
    NodeInfo[1].nodeAddress="VERSALIFECORP//GLOBAL//3939.39.8";
    NodeInfo[1].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoVersaLife';

    NodeInfo[2].nodeName="Queens Tower";
    NodeInfo[2].nodeDesc="Queens Tower Luxury Suites";
    NodeInfo[2].nodeAddress="QT_UTIL//LOCAL//673.9845.09531";
    NodeInfo[2].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoQueensTower';

    NodeInfo[3].nodeName="USN";
    NodeInfo[3].nodeDesc="United States Navy";
    NodeInfo[3].nodeAddress="USGOV//MIL//USN//GLOBAL//0001";
    NodeInfo[3].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoUSNavy';

    NodeInfo[4].nodeName="MJ12Net";
    NodeInfo[4].nodeDesc="Majestic 12 Net";
    NodeInfo[4].nodeAddress="MAJESTIC//GLOBAL//12.12.12";
    NodeInfo[4].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoMJ12';

    NodeInfo[5].nodeName="Page Industries";
    NodeInfo[5].nodeDesc="Page Industries";
    NodeInfo[5].nodeAddress="PAGEIND//USERWEB//NODE.34@778";
    NodeInfo[5].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoPage';

    NodeInfo[6].nodeName="X-51 SecureNet";
    NodeInfo[6].nodeDesc="X-51 SecureNet";
    NodeInfo[6].nodeAddress="X51//SECURENET//NODE.938@893";
    NodeInfo[6].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoArea51';

    NodeInfo[7].nodeName="Everett Enterprises";
    NodeInfo[7].nodeDesc="Everett Enterprises";
    NodeInfo[7].nodeAddress="EE//INTSYS.TT//0232.98//TERMINAL";
    NodeInfo[7].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoEverettEnt';

    NodeInfo[8].nodeName="NSF";
    NodeInfo[8].nodeDesc="NSF";
    NodeInfo[8].nodeAddress="HUB//RESISTANCE.7654//NSFNODES";
    NodeInfo[8].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoNSF';

    NodeInfo[9].nodeName="NYComm";
    NodeInfo[9].nodeDesc="NYC Communications";
    NodeInfo[9].nodeAddress="USA//DOMESTIC//NYCCOM.USERS.PUB";
    NodeInfo[9].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoNYComm';

    NodeInfo[10].nodeName="PRChina";
    NodeInfo[10].nodeDesc="Peoples Republic of China";
    NodeInfo[10].nodeAddress="PRC//GOV//RESTRICTED.HK.562";
    NodeInfo[10].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoPRChina';

    NodeInfo[11].nodeName="HKNet";
    NodeInfo[11].nodeDesc="HK Net";
    NodeInfo[11].nodeAddress="PUB//HKNET//USERS.ACCTS.20435//2";
    NodeInfo[11].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoHKNet';

    NodeInfo[12].nodeName="Quick Stop";
    NodeInfo[12].nodeDesc="Quick Stop";
    NodeInfo[12].nodeAddress="PUB//HKNET//QUICKSTOPINT//NODE98";
    NodeInfo[12].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoQuickStop';

    NodeInfo[13].nodeName="Lucky Money";
    NodeInfo[13].nodeDesc="Lucky Money Club";
    NodeInfo[13].nodeAddress="PUB//HKNET//LUCKYMONEY/BUSSYS.294";
    NodeInfo[13].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoLuckyMoney';

    NodeInfo[14].nodeName="IIS";
    NodeInfo[14].nodeDesc="Illuminati Information Systems";
    NodeInfo[14].nodeAddress="SECURE//IIS.INFTRANS.SYS//UEU";
    NodeInfo[14].nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoIlluminati';
}


defaultproperties
{
     bOn=True
     lockoutDelay=30.000000
     lastHackTime=-9999.000000
     msgLockedOut="Terminal is locked out for %d more seconds"
     nodeName="UNATCO"
     titleString="United Nations Anti-Terrorist Coalition (UNATCO)"
     titleTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoUNATCO'
     TextPackage="DeusExText"
/* Ну вот что тебе не так?!!   NodeInfo(0)=(nodeName="UNATCO",nodeDesc="",nodeAddress="UN//UNATCO//RESTRICTED//923.128.6430",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoUNATCO'),
    NodeInfo(1)=(nodeName="VersaLife",nodeDesc="VersaLife",nodeAddress="VERSALIFECORP//GLOBAL//3939.39.8",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoVersaLife'),
    NodeInfo(2)=(nodeName="Queens Tower",nodeDesc="Queens Tower Luxury Suites",nodeAddress="QT_UTIL//LOCAL//673.9845.09531",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoQueensTower'),
    NodeInfo(3)=(nodeName="USN",nodeDesc="United States Navy",nodeAddress="USGOV//MIL//USN//GLOBAL//0001",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoUSNavy'),
    NodeInfo(4)=(nodeName="MJ12Net",nodeDesc="Majestic 12 Net",nodeAddress="MAJESTIC//GLOBAL//12.12.12",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoMJ12'),
    NodeInfo(5)=(nodeName="Page Industries",nodeDesc="Page Industries",nodeAddress="PAGEIND//USERWEB//NODE.34@778",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoPage'),
    NodeInfo(6)=(nodeName="X-51 SecureNet",nodeDesc="X-51 SecureNet",nodeAddress="X51//SECURENET//NODE.938@893",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoArea51'),
    NodeInfo(7)=(nodeName="Everett Enterprises",nodeDesc="Everett Enterprises",nodeAddress="EE//INTSYS.TT//0232.98//TERMINAL",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoEverettEnt'),
    NodeInfo(8)=(nodeName="NSF",nodeDesc="NSF",nodeAddress="HUB//RESISTANCE.7654//NSFNODES",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoNSF'),
    NodeInfo(9)=(nodeName="NYComm",nodeDesc="NYC Communications",nodeAddress="USA//DOMESTIC//NYCCOM.USERS.PUB",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoNYComm'),
    NodeInfo(10)=(nodeName="PRChina",nodeDesc="Peoples Republic of China",nodeAddress="PRC//GOV//RESTRICTED.HK.562",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoPRChina'),
    NodeInfo(11)=(nodeName="HKNet",nodeDesc="HK Net",nodeAddress="PUB//HKNET//USERS.ACCTS.20435//2",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoHKNet'),
    NodeInfo(12)=(nodeName="Quick Stop",nodeDesc="Quick Stop",nodeAddress="PUB//HKNET//QUICKSTOPINT//NODE98",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoQuickStop'),
    NodeInfo(13)=(nodeName="Lucky Money",nodeDesc="Lucky Money Club",nodeAddress="PUB//HKNET//LUCKYMONEY/BUSSYS.294",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoLuckyMoney'),
    NodeInfo(14)=(nodeName="IIS",nodeDesc="Illuminati Information Systems",nodeAddress="SECURE//IIS.INFTRANS.SYS//UEU",nodeTexture=Texture'DeusExUI.UserInterface.ComputerLogonLogoIlluminati'),*/
     alarmTimeout=30
//     CompInUseMsg="The computer is already in use by %s."
     Mass=20.000000
     Buoyancy=5.000000
}
