//=============================================================================
// MissionScript.
// 24/07/2017: скрипт спавнитс€ через PostLogin в DeusExGameInfo, класс
// объ€влен как Transient.
//=============================================================================
class MissionScript extends Info
    transient
    abstract;

//
// State machine for each mission
// All flags set by this mission controller script should be
// prefixed with MS_ for consistency
//

var float checkTime;
var DeusExPlayer Player;
var transient DeusExGameInfo flags; // transient дл€ безопасности
var string localURL;
var DeusExLevelInfo dxInfo;

var bool bFirstFrame;

// ----------------------------------------------------------------------
// PostPostBeginPlay()
//
// Set the timer
// ----------------------------------------------------------------------
event SetInitialState()
{
    // start the script
    SetTimer(checkTime, True);
}

// ----------------------------------------------------------------------
// InitStateMachine()
//
// Get the player's flag base, get the map name, and set the player
// ----------------------------------------------------------------------
function InitStateMachine()
{
    local DeusExLevelInfo info;

    Player = DeusExPlayer(Level.GetLocalPlayerController().Pawn);

    foreach AllActors(class'DeusExLevelInfo', info)
        dxInfo = info;

    if (Player != None)
    {
        flags = DeusExGameInfo(Level.Game);

        // Get the mission number by extracting it from the
        // DeusExLevelInfo and then delete any expired flags.
        //
        // Also set the default mission expiration so flags
        // expire in the next mission unless explicitly set
        // differently when the flag is created.

        if (flags != None)
        {
            // Don't delete expired flags if we just loaded
            // a savegame
            if (flags.GetBool('PlayerTraveling'))
                flags.DeleteExpiredFlags(dxInfo.MissionNumber);

            flags.SetDefaultExpiration(dxInfo.MissionNumber + 1);

            localURL = Caps(dxInfo.mapName);

            log("**** InitStateMachine() -"@player@"started mission state machine for"@localURL);
        }
        else
        {
            log("**** InitStateMachine() - flagBase not set - mission state machine NOT initialized!");
        }
    }
    else
    {
        log("**** InitStateMachine() - player not set - mission state machine NOT initialized!");
    }
//  RandomizePathNodesCost();
}




// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------
function FirstFrame()
{
    local hudOverlay_StartupMessage StartUp;
    local string flagName;
    local ScriptedPawn P;
    local int i;

    flags.DeleteFlag('PlayerTraveling', FLAG_Bool);

    // Check to see which NPCs should be dead from prevous missions
    foreach AllActors(class'ScriptedPawn', P)
    {
        if (P.bImportant)
        {
            flagName = P.BindName$"_Dead";
            if (flags.GetBool(flagName))
                P.Destroy();
        }
    }

    // print the mission startup text only once per map
    flagName = "M"$Caps(dxInfo.mapName)$"_StartupText";
    if (!flags.GetBool(flagName) && (dxInfo.startupMessage[0] != ""))
    {
        StartUp = Spawn(class'hudOverlay_StartupMessage', self);
        StartUp.message = "";
        DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).AddHudOverlay(StartUp);

        for (i=0; i<ArrayCount(dxInfo.startupMessage); i++)
          StartUp.message $= dxInfo.StartUpMessage[i] $"|";

          StartUp.StartMessage();
            //StartUp.StartUpMessage[i] = dxInfo.startupMessage[i];
            flags.SetBool(flagName, True);
    }

    flagName = "M"$dxInfo.MissionNumber$"MissionStart";
    if (!flags.GetBool(flagName))
    {
        // Remove completed Primary goals and all Secondary goals
        Player.ResetGoals();

        // Remove any Conversation History.
        Player.ResetConversationHistory();

        // Set this flag so we only get in here once per mission.
        flags.SetBool(flagName, True);
    }
}


// ----------------------------------------------------------------------
// PreTravel()
// 
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------
function PreTravel()
{
    // turn off the timer
    SetTimer(0, False);
    Log("PreTravel() : Timer STOPPED");

    // zero the flags so FirstFrame() gets executed at load
    flags = None;
}



// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------
event Timer()
{
    // make sure our flags are initialized correctly
    if (flags == None)
    {
        InitStateMachine();

        // Don't want to do this if the user just loaded a savegame
        if ((player != None) && (flags.GetBool('PlayerTraveling')))
        {
            FirstFrame();
        }

        if(bFirstFrame == false)
        {
            FirstFrame();
            bFirstFrame = true;
        }
    }
}

// ----------------------------------------------------------------------
// GetPatrolPoint()
// Y|y: Fixed to actually do something
// ----------------------------------------------------------------------
function PatrolPoint GetPatrolPoint(Name patrolTag, optional bool bRandom)
{
    local PatrolPoint aPoint;

    aPoint = None;

    while(aPoint == None)
    {
        foreach AllActors(class'PatrolPoint', aPoint, patrolTag)
        {
            if (bRandom)
            {
                if(FRand() < 0.5)
                    break;
            }
            else
                break;
        }
    }
    return aPoint;
}

// ----------------------------------------------------------------------
// GetSpawnPoint()
// Y|y: Fixed to actually do something
// ----------------------------------------------------------------------
function SpawnPoint GetSpawnPoint(Name spawnTag, optional bool bRandom)
{
    local SpawnPoint aPoint;

    aPoint = None;

    while(aPoint == None)
    {
        foreach AllActors(class'SpawnPoint', aPoint, spawnTag)
        {
            if (bRandom)
            {
                if(FRand() < 0.5)
                    break;
            }
            else
                break;
        }
    }
    return aPoint;
}

function RandomizePathNodesCost()
{
    local NavigationPoint N;

    for (N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint)
         if (N.IsA('PathNode'))
             N.ExtraCost += Rand(5000);
}

function DeusExGameInfo getFlagBase()
{
  return DeusExGameInfo(Level.Game);
}

function DeusExPlayer getPlayerPawn()
{
  return DeusExPlayer(level.GetLocalPlayerController().pawn);
}

function DeusExPlayerController getPlayer()
{
  return DeusExPlayerController(level.GetLocalPlayerController());
}



defaultproperties
{
     checkTime=1.000000
     localURL="NOTHING"
}
