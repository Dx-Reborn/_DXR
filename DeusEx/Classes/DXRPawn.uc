/*
   Базовый класс для всех NPC и игрока (PlayerPawn)
   todo: Здесь будут собраны общие свойства и функции.
*/

class DXRPawn extends pawn;

const CON_BARK_PREFIX = "_Bark";
const BlendCH = 1;
const BlendAlpha = 1.0;
const BlendInTime = 1.0;

//
// look direction - DEUS_EX STM
//
enum ELookDirection
{
	LOOK_Forward,
	LOOK_Left,
	LOOK_Right,
	LOOK_Up,
	LOOK_Down
};

var(Alliances) Name Alliance; // alliance tag
var(Conversation) editconst transient array<ConDialogue> conlist; // Диалоги хранятся здесь.
var(Conversation) String BindName,BarkBindName,FamiliarName,UnfamiliarName;
var(Conversation) float ConStartInterval;     // Amount of time required between two convos.
var	travel   float       LastConEndTime;			// Time when last conversation ended

var(Advanced) bool        bBlockSight;   // True if pawns can't see through this actor.
var(Advanced) bool        bDetectable;   // True if this actor can be detected (by sight, sound, etc).
var(Advanced) bool        bTransient;    // True if this actor should be destroyed when it goes into stasis
var           bool        bIgnore;       // True if this actor should be generally ignored; compliance is voluntary

// DXR: Пока лишь-бы собиралось.
var name	BlendAnimSequence[4];
var float	BlendAnimFrame[4];
var float	BlendAnimRate[4];
var float	BlendTweenRate[4];

var float animTimer[4];		// misc. timers for ambient anims (blink, head, etc.)
                          // DXR: idk how to implement lipsync. Maybe play mouth anims randomly?

var bool bIsSpeaking;
var bool bWasSpeaking;		// were we speaking last frame?  (should we close our mouth?)
var string lastPhoneme, nextPhoneme;
var bool bLipsyncHackActive;

var DeusExGameInfo flagBase;
var DeusExLevelInfo dxLevel;

function DeusExGameInfo getFlagBase()
{
    if(flagBase == none)
    {
        flagBase = DeusExGameInfo(Level.Game);
    }
    return flagBase;
}

// ----------------------------------------------------------------------
// GetLevelInfo()
// ----------------------------------------------------------------------
function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

		if (info != none)
		    DxLevel = info;

	return info;
}

// ----------------------------------------------------------------------
// Loops through the list of conversations and attempts to find
// one that matches the name passed in.
// ----------------------------------------------------------------------
function ConDialogue FindConversationByName(string conName)
{
  local int y;
//  local conDialogue conv;

  for (y=0; y<conList.length; y++)
  {
//    if (conList[y].Name == conName)
    if (caps(conList[y].Name) == caps(conName))
        return conList[y];
//    break;
//    log("found conversationByName="$conName);
//    conv = conList[y];
  }
//  return conv;
}

exec function AddRefCount()
{
	local bool barkPrefix;
	local conDialogue con;
	local int y;

	DecreaseRefCount();

	for (y=0; y<conList.length; y++)
	{
		con = conList[y];
		barkPrefix = (Left(con.Name, Len(con.OwnerName) + 5) == (con.OwnerName $ CON_BARK_PREFIX));

			if (BarkBindName != con.OwnerName || !barkPrefix)
			{
					if (BindName != con.OwnerName)
						continue;
				if (BarkBindName != "")
				{
					if (BarkBindName == "" || barkPrefix)
						continue;
				}
			}
//	 log("Increased refcount for "$con, 'AddRefCount');
	 con.ownerRefCount++;
	}
}

function DecreaseRefCount()
{
	local int y;

	for (y=0; y<conList.length; y++)
	{
     conList[y].ownerRefCount--;
	}
}

//
// Возвращает массив ConDialogue
//
function array<Object> GetConList()
{
   return conList;
}

function ConBindEvents()
{
	local DeusExLevelInfo dxInfo;

	foreach AllActors(class'DeusExLevelInfo', dxInfo)
	{
		if (dxInfo != none)
			break;
	}
	if (dxInfo != none)
	{
	   RegisterConFiles(dxinfo.ConversationsPath);
     LoadConsForMission(dxinfo.missionNumber);
     AddRefCount();
	}
	else
		log("DeusExLevelInfo not found! Failed to register conversations.");
}

// Регистрация *.con файлов
function RegisterConFiles(string Path)
{
  local array<byte> bt;
  local array<string> conFiles;
  local int f, res;

  conFiles = class'FileManager'.static.FindFiles(Path$"*.con", true, false);

  if (conFiles.length == 0)
     {
       log("ERROR -- No *.con files found !");
       return;
     }

  for (f=0; f<conFiles.length; f++)
  {
    bt = class'DXUtil'.static.GetFileAsArray(Path$conFiles[f]);
    res = class'ConversationManager'.static.RegisterConFile(Path$conFiles[f],bt);
  }
}

function LoadConsForMission(int mission)
{
//  class'ConversationManager'.static.LoadConversations(mission, conList);
  local int convos, barks;

  if (bindName != "")
    convos = class'ConversationManager'.static.GetConversations(conList, mission, bindName, "");
//    log(convos);


  if (barkBindName != "")
    barks = class'ConversationManager'.static.GetConversations(conList, mission, BarkbindName, "");
//    log(barks);
}


function PostBeginPlay()
{
  super.PostBeginPlay();
  ConBindEvents();
}

event PostLoadSavedGame()
{
  Super.PostLoadSavedGame();
	ConBindEvents();
}

//
// lip synching support - DEUS_EX CNN
//
//AnimBlendParams(int Stage, optional float BlendAlpha, optional float InTime, optional float OutTime, optional name BoneName, optional bool bGlobalPose);
//AnimBlendParams(1, 1.0, 0.0, 0.0, 'bone_shell');
//DX: PlayBlendAnim( name Sequence, optional float Rate, optional float TweenTime, optional int BlendSlot );
//DX: TweenBlendAnim( name Sequence, float Time, optional int BlendSlot );

function LipSynch(float deltaTime)
{
	local name animseq;
//	local float rnd;
	local float tweentime;

	// update the animation timers that we are using
	animTimer[0] += deltaTime;
	animTimer[1] += deltaTime;
	animTimer[2] += deltaTime;

	if (bIsSpeaking)
	{
		// if our framerate is high enough (>20fps), tween the lips smoothly
		if (Level.TimeSeconds - animTimer[3]  < 0.05)
			tweentime = 0.1;
		else
			tweentime = 0.0;

		// the last animTimer slot is used to check framerate
		animTimer[3] = Level.TimeSeconds;

		// from The Nameless Mod SDK. 
		if (bLipsyncHackActive)// || (nextPhoneme == "" && bUseLipsyncHack))
		{
			switch(rand(8))
			{
			case 0:
				nextPhoneme="A";
				break;
			case 1:
				nextPhoneme="E";
				break;
			case 2:
				nextPhoneme="F";
				break;
			case 3:
				nextPhoneme="M";
				break;
			case 4:
				nextPhoneme="O";
				break;
			case 5:
				nextPhoneme="T";
				break;
			case 6:
				nextPhoneme="U";
				break;
			case 7:
				nextPhoneme="X";
				break;
			}
		}

		if (nextPhoneme == "A")
			animseq = 'MouthA';
		else if (nextPhoneme == "E")
			animseq = 'MouthE';
		else if (nextPhoneme == "F")
			animseq = 'MouthF';
		else if (nextPhoneme == "M")
			animseq = 'MouthM';
		else if (nextPhoneme == "O")
			animseq = 'MouthO';
		else if (nextPhoneme == "T")
			animseq = 'MouthT';
		else if (nextPhoneme == "U")
			animseq = 'MouthU';
		else if (nextPhoneme == "X")
			animseq = 'MouthClosed';

		if (animseq != '')
		{
			if (lastPhoneme != nextPhoneme)
			{
       // PlayAnim(name Sequence,optional float Rate,optional float TweenTime,optional int Channel)
				lastPhoneme = nextPhoneme;
//        AnimBlendParams(BlendCH, BlendAlpha,BlendInTime,,, false);
//				TweenAnim(animseq, tweentime);
        PlayAnim(animseq, 1.0, tweentime, BlendCH);
//        PlayAnim(animseq,1.0,tweentime,1);
			}
		}
	}
	else if (bWasSpeaking)
	{
		bWasSpeaking = False;
		                            //303
//    AnimBlendParams(1, 1.0,0.0,,'303', true);//, optional float InTime, optional float OutTime, optional name BoneName, optional bool bGlobalPose);
//    AnimBlendParams(BlendCH, BlendAlpha,BlendInTime,,, false);
//		TweenAnim('MouthClosed', tweentime, BlendCH);
//		PlayAnim('MouthClosed', 1.0, tweentime, BlendCH);
//    PlayAnim('MouthClosed',1.0,tweentime);
//		TweenAnim('MouthClosed', tweentime);
	}

	// blink randomly
	if (animTimer[0] > 2.0)
	{
		animTimer[0] = 0;
		if (FRand() < 0.4)
		{
//      AnimBlendParams(0, 0.1);
//      AnimBlendParams(BlendCH, BlendAlpha,BlendInTime,,,false);
//			PlayAnim('Blink', 1.0, tweentime);
//			PlayBlendAnim('Blink', 1.0, 0.1, 1);
		}
	}
//	LoopHeadConvoAnim();
//	LoopBaseConvoAnim();
}

//
// PlayTurnHead - DEUS_EX STM
//

function bool PlayTurnHead(ELookDirection dir, float rate, float tweentime)
{
	local name lookName;
	local bool bSuccess;

	if (dir == LOOK_Left)
		lookName = 'HeadLeft';
	else if (dir == LOOK_Right)
		lookName = 'HeadRight';
	else if (dir == LOOK_Up)
		lookName = 'HeadUp';
	else if (dir == LOOK_Down)
		lookName = 'HeadDown';
	else
		lookName = 'Still';

	bSuccess = false;
	if (BlendAnimSequence[3] != lookName)
	{
		if (animTimer[1] > 0.00)
		{
			animTimer[1] = 0;
			if (BlendAnimSequence[3] == '')
				BlendAnimSequence[3] = 'Still';

//        AnimBlendParams(0, 0.1);
   	    PlayAnim(lookName, rate, tweentime);
//			PlayBlendAnim(lookName, rate, tweentime, 3);
			bSuccess = true;
		}
	}

	return (bSuccess);
}

//
// LoopHeadConvoAnim - DEUS_EX STM
//

function LoopHeadConvoAnim()
{
	local float rnd;

	rnd = FRand();

	// move head randomly (only while not speaking)
	if (!bIsSpeaking && (animTimer[1] > 0.5))
	{
		if (rnd < 0.01)
			PlayTurnHead(LOOK_Left, 1.0, 2.0);
		else if (rnd < 0.02)
			PlayTurnHead(LOOK_Right, 1.0, 2.0);
		else
			PlayTurnHead(LOOK_Forward, 1.0, 1.0);
	}
}

//
// LoopBaseConvoAnim - DEUS_EX CNN
//

function LoopBaseConvoAnim()
{
	local float rnd;

	rnd = FRand();

	// move arms randomly
	if (bIsSpeaking)
	{
		if (animTimer[2] > 2.5)
		{
			animTimer[2] = 0;
			if (rnd < 0.1)
				PlayAnim('GestureLeft', 0.35, 0.4);
			else if (rnd < 0.2)
				PlayAnim('GestureRight', 0.35, 0.4);
			else if (rnd < 0.3)
				PlayAnim('GestureBoth', 0.35, 0.4);
		}
	}

	// if we're not playing an animation, loop the breathe
	if (!IsAnimating())
		LoopAnim('BreatheLight',, 0.4);
}




defaultproperties
{
   ConStartInterval=5.00
   bLipsyncHackActive=true
   AmbientSoundScaling=+0.5
}