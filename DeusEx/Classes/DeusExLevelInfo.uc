//=============================================================================
// DeusExLevelInfo
//=============================================================================
class DeusExLevelInfo extends Info
                      placeable
                      hideCategories(Actor,Advanced,Display,Sound,Trailer);

#exec Texture Import File=Models\DXLevel.tga  Name=DXLevel Mips=Off MASKED=true ALPHA=true

var() String				MapName;
var() String				MapAuthor;
var() localized String		MissionLocation;
var() int					missionNumber;  // barfy, lowercase "m" due to SHITTY UNREALSCRIPT NAME BUG!
var bool					bMultiPlayerMap;
var() class<MissionScript>	Script;
var() int					TrueNorth;
var() localized String		startupMessage[4];		// printed when the level starts
var String ConversationPackage; // Obsolete, only for compatibility  // DEUS_EX STM -- added so SDK users will be able to use their own convos
var() string ConversationsPath; // DXR: relative path to your .con files. ..\\Conversations\\ by default.
var() string ConAudioPath; // DXR: relative path to your conversations sound files. ..\\Conversations\\Audio\\ by default.

// DXR: Support for dynamic music.
var(DynamicMusic) string AmbientMusic; // Ambient music
var(DynamicMusic) string AmbientMusic2; // Unused, but who knows...
var(DynamicMusic) string CombatMusic; // Someone tries to attack player!
var(DynamicMusic) string ConvoMusic; // For State Conversation (DeusExPlayerController)
var(DynamicMusic) string DeadMusic; // When player is dead!!! 
var(DynamicMusic) string OutroMusic; // When leaving a level

function SpawnScript()
{
	local MissionScript scr;
	local bool bFound;

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

function SetInitialState()
{
	SpawnScript();
}



defaultproperties
{
     DrawScale=0.6
     ConversationPackage="DeusExConversations"
     ConversationsPath="..\\Conversations\\"
     ConAudioPath="..\\Conversations\\Audio\\"
     bAlwaysRelevant=True
     Texture=Texture'DXLevel'
}