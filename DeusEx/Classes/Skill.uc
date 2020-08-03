//=============================================================================
// Skill.
//=============================================================================
class Skill extends Actor;

var() editconst string InternalSkillName; // нелокализуемое имя навыка.
var() localized string      SkillName;
var() localized string      Description;
var   Texture               SkillIcon;
var() bool                  bAutomatic;
var() bool                  bConversationBased;
var() int                   Cost[3];
var() float                 LevelValues[4];
var() travel int                CurrentLevel;       // 0 is unskilled, 3 is master
var() class<SkilledTool>    itemNeeded;

// which player am I attached to?
var() DeusExPlayer Player;

// Pointer to next skill
var() travel Skill next;        

// Printable skill level strings
var Localized string skillLevelStrings[4];
var localized string SkillAtMaximum;

/*
   Поскольку в UT2004 обычные акторы путешествовать вместе с игроком не могут
   (движок так просто не умеет), то нужно как-то сохранять уровень навыка.
   Идея пришла ко мне во сне...
*/
function restoreSkillLevel()
{
  if (DeusExGameInfo(Level.Game).CheckFlag("SKL_"$InternalSkillName))
      currentLevel = DeusExGameInfo(Level.Game).GetInt("SKL_"$InternalSkillName);

  log(self@"restoring skill level to"@currentLevel@"...");
}

function SaveSkillLevel()
{
  log(self@"saving skill level (current = "$CurrentLevel$")...");
  DeusExGameInfo(Level.Game).SetInt("SKL_"$InternalSkillName,CurrentLevel,,99);
}

function ResetSkill()
{
  if (DeusExGameInfo(Level.Game).CheckFlag("SKL_"$InternalSkillName))
       DeusExGameInfo(Level.Game).DeleteFlag("SKL_"$InternalSkillName);
}

event SetInitialState()
{
  super.SetInitialState();
  restoreSkillLevel();
}

event PostLoadSavedGame()
{
  restoreSkillLevel();
}

// ----------------------------------------------------------------------
// Use()
// ----------------------------------------------------------------------
function bool Use()
{
    local bool bDoIt;

    bDoIt = True;

    if (itemNeeded != None)
    {
        bDoIt = False;

        if ((Player.inHand != None) && (Player.inHand.Class == itemNeeded))
        {
            SkilledTool(Player.inHand).PlayUseAnim();

            // alert NPCs that I'm messing with stuff
            if (Player.FrobTarget != None)
                if (Player.FrobTarget.bOwned)
                    class'EventManager'.static.AISendEvent(Player.FrobTarget,'MegaFutz', EAITYPE_Visual);

            bDoIt = True;
        }
    }

    return bDoIt;
}

// ----------------------------------------------------------------------
// accessor functions
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// GetCost()
// ----------------------------------------------------------------------

function int GetCost()
{
    return Cost[CurrentLevel];
}

// ----------------------------------------------------------------------
// GetCurrentLevel()
// ----------------------------------------------------------------------

function int GetCurrentLevel()
{
    return CurrentLevel;
}

// ----------------------------------------------------------------------
// GetCurrentLevelString()
//
// Returns a string representation of the current skill level.
// ----------------------------------------------------------------------

function String GetCurrentLevelString()
{
    return skillLevelStrings[currentLevel];
}

// ----------------------------------------------------------------------
// IncLevel()
// ----------------------------------------------------------------------

function bool IncLevel(optional DeusExPlayer usePlayer)
{
    local DeusExPlayer localPlayer;

    // First make sure we're not maxed out
    if (CurrentLevel < 3)
    {
        // If "usePlayer" is passed in, then we want to use this 
        // as the basis for making our calculations, temporarily
        // overriding whatever this skill's player is set to.

        if (usePlayer != None)
            localPlayer = usePlayer;
        else
            localPlayer = Player;

        // Now, if a player is defined, then check to see if there enough
        // skill points available.  If no player is defined, just do it.
        if (localPlayer != None) 
        {
            if ((localPlayer.SkillPointsAvail >= Cost[CurrentLevel]))
            {
                // decrement the cost and increment the current skill level
                localPlayer.SkillPointsAvail -= GetCost();
                CurrentLevel++;
                SaveSkillLevel();
                return True;
            }
        }
        else
        {
            CurrentLevel++;
      SaveSkillLevel();
            return True;
        }
    }

    return False;
}

// ----------------------------------------------------------------------
// DecLevel()
// 
// Decrements a skill level, making sure the skill isn't already at 
// the lowest skill level.  Cost of the skill is optionally added back 
// to the player's SkilPointsAvail variable. 
// ----------------------------------------------------------------------

function bool DecLevel(optional bool bGiveUserPoints,   optional DeusExPlayer usePlayer)
{
    local DeusExPlayer localPlayer;

    // First make sure we're not already at the bottom
    if (CurrentLevel > 0)
    {
        // Decrement the skill level 
        CurrentLevel--;
        SaveSkillLevel();

        // If "usePlayer" is passed in, then we want to use this 
        // as the basis for making our calculations, temporarily
        // overriding whatever this skill's player is set to.

        if (usePlayer != None)
            localPlayer = usePlayer;
        else
            localPlayer = Player;

        // If a player exists and the 'bGiveUserPoints' flag is set, 
        // then add the points to the player
        if (( bGiveUserPoints ) && (localPlayer != None))
            localPlayer.SkillPointsAvail += GetCost();

        return True;
    }

    return False;
}

// ----------------------------------------------------------------------
// CanAffordToUpgrade()
//
// Given the points passed in, checks to see if the skill can be 
// upgraded to the next level.  Will always return False if the 
// skill is already at the maximum level.
// ----------------------------------------------------------------------

function bool CanAffordToUpgrade( int skillPointsAvailable )
{
    if ( CurrentLevel == 3 ) 
        return False;
    else if ( Cost[CurrentLevel] > skillPointsAvailable )
        return False;
    else
        return True;
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------
// Информацию о навыках нужно будет получать через DeusExPlayer(PlayerOwner().pawn)....
function bool UpdateInfo(Object winObject)
{

/*  local PersonaInfoWindow winInfo;

    winInfo = PersonaInfoWindow(winObject);
    if (winInfo == None)
        return False;

    winInfo.Clear();
    winInfo.SetTitle(SkillName);
    winInfo.SetText(Description);*/

    return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    skillLevelStrings(0)="UNTRAINED"
    skillLevelStrings(1)="TRAINED"
    skillLevelStrings(2)="ADVANCED"
    skillLevelStrings(3)="MASTER"
    SkillAtMaximum="Skill at Maximum Level"
    bHidden=True
    bTravel=True
}
