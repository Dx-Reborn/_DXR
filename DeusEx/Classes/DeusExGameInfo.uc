//=============================================================================
// DeusExGameInfo
//=============================================================================

class DeusExGameInfo extends GameInfoExt config;

// Из Reborn: эти данные синхронизируются с DeusExLevelInfo на текущей карте.
var() String								MapName;
var() String								MapAuthor;
var() String								MissionLocation;
var() int										missionNumber;  
var() Bool									bMultiPlayerMap;
var() class<MissionScript>	Script;
var() int										TrueNorth;
var() String								startupMessage[4];		
var() String								ConversationPackage;
var() string                ConversationsPath; // DXR: relative path to your .con files. ..\\Conversations\\ by default.

var bool bKeepSamePlayerStart;
var NanoKeyRingInv KeyRing; // Один наноключ на всю игру. 

function SpawnScript()
{
	local MissionScript scr;
	local bool bFound;

	if ((missionNumber == -2) || (missionNumber == -1))
	DeusExHUD(level.GetLocalPlayerController().myHUD).cubemapmode = true;

	// check to see if this script has already been spawned
	if (Script != None)
	{
		bFound = False;
		foreach AllActors(class'MissionScript', scr)
			bFound = True;

		if (!bFound)
		{
			if (Spawn(Script) == None)
				log("DeusExLevelInfo - WARNING! - Could not spawn mission script '"$Script$"'");
			else
				log("DeusExLevelInfo - Spawned new mission script '"$Script$"'");
		}
		else
			log("DeusExLevelInfo - WARNING! - Already found mission script '"$Script$"'");
	}
}

function PostBeginPlay()
{
  local DeusExLevelInfo A;

	Super.PostBeginPlay();

		foreach AllActors(class'DeusExLevelInfo', A)
    {
        MapName = A.MapName;
        MapAuthor = A.MapAuthor;
        MissionLocation = A.MissionLocation;
        missionNumber = A.missionNumber;
        bMultiPlayerMap = A.bMultiPlayerMap;
        Script = A.Script;
        TrueNorth = A.TrueNorth;
        startupMessage[0] = A.startupMessage[0];
        startupMessage[1] = A.startupMessage[1];
        startupMessage[2] = A.startupMessage[2];
        startupMessage[3] = A.startupMessage[3];
        ConversationPackage = A.ConversationPackage;
    }
}

event DetailChange()
{
   Super.DetailChange();

   log("**************** DetailChange called!");
}

//--- !Скопировано из Reborn

event PostLogin(PlayerController NewPlayer)
{
  log("************* DeusExGameInfo PostLogin");

  // Log player's login.
	if (GameStats!=None)
	{
		GameStats.ConnectEvent(NewPlayer.PlayerReplicationInfo);
		GameStats.GameEvent("NameChange",NewPlayer.PlayerReplicationInfo.playername,NewPlayer.PlayerReplicationInfo);		
	}

	if (NewPlayer.Pawn == None) // Changed by Demiurge (Runtime)
	{
		// start match, or let player enter, immediately
		bRestartLevel = false;	// let player spawn once in levels that must be restarted after every death
		bKeepSamePlayerStart = true;

		if (bWaitingToStartMatch)
		{
				StartMatch();
				log("StartMatch");
		}
		else
			RestartPlayer(newPlayer);
			Log("RestartPlayer");
		bKeepSamePlayerStart = false;
		bRestartLevel = Default.bRestartLevel;
	}

		NewPlayer.ClientSetHUD(class'DeusExHud',none);

		if (NewPlayer.Pawn != None)
		{
			NewPlayer.Pawn.ClientSetRotation(NewPlayer.Pawn.Rotation);
      log("****** PlayerPawn = "$NewPlayer.pawn);
		}

	SpawnScript();
}

function NavigationPoint FindPlayerStart( Controller Player, optional byte InTeam, optional string incomingName )
{
	local NavigationPoint N, BestStart;
	local Teleporter Tel;
	local float BestRating, NewRating;
	local byte Team;

	// always pick StartSpot at start of match
    if ( (Player != None) && (Player.StartSpot != None) && (Level.NetMode == NM_Standalone)
		&& (bKeepSamePlayerStart || bWaitingToStartMatch || ((Player.PlayerReplicationInfo != None) && Player.PlayerReplicationInfo.bWaitingPlayer))  )
	{
		return Player.StartSpot;
	}	

	if ( GameRulesModifiers != None )
	{
		N = GameRulesModifiers.FindPlayerStart(Player,InTeam,incomingName);
		if ( N != None )
		    return N;
	}

	// if incoming start is specified, then just use it
	if( incomingName!="" )
		foreach AllActors( class 'Teleporter', Tel )
			if( string(Tel.Tag)~=incomingName )
				return Tel;

	// use InTeam if player doesn't have a team yet
	if ( (Player != None) && (Player.PlayerReplicationInfo != None) )
	{
		if ( Player.PlayerReplicationInfo.Team != None )
			Team = Player.PlayerReplicationInfo.Team.TeamIndex;
		else
			Team = 0;
	}
	else
		Team = InTeam;

	for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
	{
		NewRating = RatePlayerStart(N,InTeam,Player);
		if ( NewRating > BestRating )
		{
			BestRating = NewRating;
			BestStart = N;
		}
	}
	
	if ( BestStart == None )
	{
		log("Warning - PATHS NOT DEFINED or NO PLAYERSTART");			
		foreach AllActors( class 'NavigationPoint', N )
		{
			NewRating = RatePlayerStart(N,0,Player);
			if ( NewRating > BestRating )
			{
				BestRating = NewRating;
				BestStart = N;	
			}
		}
	}

	return BestStart;
}

//-----------------------------------------------------------------------------------------------------------
function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;
	return info;
}

event PostLoadSavedGame()
{
   InitSavedLevel();
}


event PlayerController Login(string Portal,string Options,out string Error)
{
    local NavigationPoint 	StartSpot;
    local PlayerController 	NewPlayer, TestPlayer;//, PC;
    local string          	InName;//, InAdminName;
    local byte            	InTeam;
//    local bool 							bSpectator, bAdmin;
    local pawn 							TestPawn;
    local DeusExLevelInfo 	DX;

		Options = StripColor(Options);	// Strip out color Codes

    BaseMutator.ModifyLogin(Portal, Options);

    // Get URL options.
    InName     = Left(ParseOption ( Options, "Name"), 20);
    InTeam     = GetIntOption( Options, "Team", 255 ); // default to "no team"

		DX=GetLevelInfo();

	if ( HasOption(Options, "Load"))
	{
		log("Loading Savegame");
    InitSavedLevel(); // Always recreate ObjectPool?
		bIsSaveGame = true;

		// Try to match up to existing unoccupied player in level,
		// for savegames - also needed coop level switching.
		ForEach DynamicActors(class'PlayerController', TestPlayer )
		{
			if ( (TestPlayer.Player==None) && (TestPlayer.PlayerOwnerName~=InName) )
			{
				TestPawn = TestPlayer.Pawn;
				if ( TestPawn != None )
					TestPawn.SetRotation(TestPawn.Controller.Rotation);
				log("FOUND "$TestPlayer@TestPlayer.PlayerReplicationInfo.PlayerName);
				return TestPlayer;
			}
		}
	}

	  // Find a start spot.
    StartSpot = FindPlayerStart( None, InTeam, Portal );

    if( StartSpot == None )
    {
        Error = GameMessageClass.Default.FailedPlaceMessage;
        return None;
    }

    if ( PlayerControllerClass == None )
        PlayerControllerClass = class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, class'Class'));

    NewPlayer = spawn(PlayerControllerClass,,,StartSpot.Location,StartSpot.Rotation);

    // Handle spawn failure.
    if( NewPlayer == None )
    {
        log("Couldn't spawn player controller of class "$PlayerControllerClass);
        Error = GameMessageClass.Default.FailedSpawnMessage;
        return None;
    }

    NewPlayer.StartSpot = StartSpot;

    // Init player's replication info
    NewPlayer.GameReplicationInfo = GameReplicationInfo;

    // Set the player's ID.
    NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;

		newPlayer.StartSpot = StartSpot;

		if (bTestMode)
		TestLevel();

    return newPlayer;
}

function Logout(Controller Exiting)
{
    local bool bMessage;

    log("****** DeusExGameInfo: LogOut called!!!");
    bMessage = true;
    if (PlayerController(Exiting) != None)
    {
      if (AccessControl != None && AccessControl.AdminLogout(PlayerController(Exiting)))
			 AccessControl.AdminExited( PlayerController(Exiting) );
        if (PlayerController(Exiting).PlayerReplicationInfo.bOnlySpectator)
        {
            bMessage = false;
                 NumSpectators--;
        }
        else
        {
            NumPlayers--;
        }
    }
    if( bMessage && (Level.NetMode==NM_DedicatedServer || Level.NetMode==NM_ListenServer) )
        BroadcastLocalizedMessage(GameMessageClass, 4, Exiting.PlayerReplicationInfo);

	if(VotingHandler != None)
		VotingHandler.PlayerExit(Exiting);

	if (GameStats!=None)
		GameStats.DisconnectEvent(Exiting.PlayerReplicationInfo);

    //notify mutators that a player exited
    NotifyLogout(Exiting);
}      

function NotifyLogout(Controller Exiting)
{
	local Controller C;
	local PlayerController PC;
//	local DeusExLevelInfo DX;

//	DX = GetLevelInfo();
 	BaseMutator.NotifyLogout(Exiting);

	if (PlayerController(Exiting) != None && Exiting.PlayerReplicationInfo != None)
	{
		for (C = Level.ControllerList; C != None; C = C.NextController)
		{
			PC = PlayerController(C);
			if ( PC != None && PC.ChatManager != None )
				PC.ChatManager.UnTrackPlayer(Exiting.PlayerReplicationInfo.PlayerID);
		}
	}
}

function DestroyShadows()
{
/*	local ShadowProjector S;

	foreach AllActors(class'ShadowProjector', S)
	{
		If (s!=none)
		{
			s.Destroy();
			s = none;
		}
	}*/
}

function int ReduceDamage(int Damage, pawn injured, pawn instigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType)
{
//	Super.ReduceDamage(Damage, injured,  instigatedBy,  HitLocation,  Momentum,  DamageType);
//	log(self@damage);
	return damage;
}

event PostTravel(DeusExPlayer PlayerPawn)
{

}

/*-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------*/

/* Here you can put data from DeusExGlobals to UnrealPackage.
   Data from DeusExGlobals will be lost when you exit game.*/
function SavePlayerData()
{
  local DeusExGlobals gl;
  local DeusExGlobalsMirror mr;

  DeletePackage("DXRPlayerData");

  gl = class'DeusExGlobals'.static.GetGlobals();

  mr = CreateDataObject(class'DeusExGlobalsMirror', "PlayerData", "DXRPlayerData");
  mr.Notes = gl.Notes;
  mr.myConHistory = gl.myConHistory;
  mr.mySavedAugs = gl.mySavedAugs;
  mr.goals = gl.goals;

  // Присвоить данные к копии DeusExGlobals и сохранить их в файл.
  SavePackage("DXRPlayerData");
}

/* Here you can add data you want to restore */
function RestorePlayerData(string path)
{
  local DeusExGlobals gl;
  local object mr, mr2;

  gl = class'DeusExGlobals'.static.GetGlobals();
  mr2 = class'PackageManager'.static.LoadUnrealPackage(path$"\\DXRPlayerData.uvx", 0x0000);
  mr = mr2.DynamicLoadObject("DXRPlayerData.PlayerData", class'DeusExGlobalsMirror');
  // Присвоить данные из пакета
  gl.Notes = DeusExGlobalsMirror(mr).Notes;
  gl.myConHistory = DeusExGlobalsMirror(mr).myConHistory;
  gl.mySavedAugs = DeusExGlobalsMirror(mr).mySavedAugs;
  gl.goals = DeusExGlobalsMirror(mr).goals;
  class'PackageManager'.static.unloadUnrealPackage(mr2);
}



defaultproperties
{
    bHiddenEd=false
    bHidden=true //false
    ConversationPackage="DeusExConversations"
    Texture=Texture'Engine.S_ZoneInfo'
    bAlwaysRelevant=True
    HUDType="DeusEx.DeusExHUD"
    ScoreBoardType=""
    PlayerControllerClassName="DeusEx.DeusExPlayerController"
    DefaultPlayerName="JC Denton"
    GameName="Deus Ex Reborn"
    DefaultPlayerClassName="DeusEx.JCDentonMale"
		bTeamGame=false
	 	bEnableStatLogging=true
	 bDelayedStart=false
//    bRestartLevel=false
    bAllowVehicles=false
}
