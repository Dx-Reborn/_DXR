//=============================================================================
// SkillManager
//=============================================================================
class SkillManager extends Actor;

// which player am I attached to?
var() DeusExPlayer Player;
var() class<Skill> skillClasses[15];
var() travel Skill FirstSkill;		// Pointer to first Skill

var localized string NoToolMessage;
var localized string NoSkillMessage;
var localized string SuccessMessage;
var localized string YourSkillLevelAt;

// ----------------------------------------------------------------------
// CreateSkills()
// ----------------------------------------------------------------------

function CreateSkills(DeusExPlayer newPlayer)
{
	local int skillIndex;
	local Skill aSkill;
	local Skill lastSkill;

	FirstSkill = None;
	LastSkill  = None;

	player = newPlayer;

	for(skillIndex=0; skillIndex<arrayCount(skillClasses); skillIndex++)
	{
		if (skillClasses[skillIndex] != None)
		{
			aSkill = Spawn(skillClasses[skillIndex], Self);
			aSkill.Player = player;

			// Manage our linked list
			if (aSkill != None)
			{
				if (FirstSkill == None)
				{
					FirstSkill = aSkill;
				}
				else
				{
					LastSkill.next = aSkill;
				}

				LastSkill  = aSkill;
			}
		}
	}
}

// ----------------------------------------------------------------------
// IsSkilled()
// ----------------------------------------------------------------------

function bool IsSkilled(class SkillClass, int TestLevel)
{
	local Skill aSkill;

	aSkill = GetSkillFromClass(SkillClass);

	if (aSkill != None)
	{
		if (aSkill.Use())
		{
			if (aSkill.CurrentLevel >= TestLevel)
			{
				Player.ClientMessage(SuccessMessage);
				return True;
			}
			else
				Player.ClientMessage(Sprintf(NoSkillMessage, aSkill.SkillName, GetItemName(String(aSkill.itemNeeded))));
		}
		else
			Player.ClientMessage(Sprintf(NoToolMessage, GetItemName(String(aSkill.itemNeeded))));
	}

	return False;
}

// ----------------------------------------------------------------------
// accessor functions
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
// GetSkillFromClass()
// ----------------------------------------------------------------------

function Skill GetSkillFromClass(class SkillClass)
{
	local Skill aSkill;

	aSkill = FirstSkill;
	while(aSkill != None)
	{
		if (aSkill.Class == SkillClass)
			break;

		aSkill = aSkill.next;
	}

	return aSkill;
}

// ----------------------------------------------------------------------
// GetSkillLevelValue()
//
// takes a class instead of being called by actual skill
// ----------------------------------------------------------------------

function float GetSkillLevelValue(class SkillClass)
{
	local Skill aSkill;
	local float retval;

	retval = 0;

	aSkill = GetSkillFromClass(SkillClass);

	if (aSkill != None)
		retval = aSkill.LevelValues[aSkill.CurrentLevel];

	return retval;
}

// ----------------------------------------------------------------------
// GetSkillLevel()
//
// takes a class instead of being called by actual skill
// ----------------------------------------------------------------------

function float GetSkillLevel(class SkillClass)
{
	local Skill aSkill;
	local float retval;

	retval = 0;

	aSkill = GetSkillFromClass(SkillClass);

	if (aSkill != None)
		retval = aSkill.CurrentLevel;

	return retval;
}

// ----------------------------------------------------------------------
// AddSkill()
// ----------------------------------------------------------------------

function AddSkill(Skill aNewSkill)
{
	if (aNewSkill.IncLevel())
		Player.ClientMessage(Sprintf(YourSkillLevelAt, aNewSkill.SkillName, aNewSkill.CurrentLevel));
}

// ----------------------------------------------------------------------
// SetPlayer()
//
// Kind of a hack, until we figure out why the player doesn't get set 
// correctly initially.
// ----------------------------------------------------------------------

function SetPlayer(DeusExPlayer newPlayer)
{
	local Skill aSkill;

	Player = newPlayer;

	aSkill = FirstSkill;
	while(aSkill != None)
	{
		aSkill.player = newPlayer;
		aSkill = aSkill.next;
	}
}

// ----------------------------------------------------------------------
// AddAllSkills()
// ----------------------------------------------------------------------

function AddAllSkills()
{
	local Skill aSkill;
	local int levelIndex;

	aSkill = FirstSkill;
	while(aSkill != None)
	{
		for (levelIndex=0; levelIndex<3; levelIndex++)
			AddSkill(aSkill);

		aSkill = aSkill.next;
	}
}

// ----------------------------------------------------------------------
// ResetSkills()
// ----------------------------------------------------------------------

function ResetSkills()
{
	local Skill aSkill;

	aSkill = FirstSkill;
	while(aSkill != None)
	{
		aSkill.CurrentLevel = aSkill.Default.CurrentLevel;
		aSkill = aSkill.next;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    skillClasses(0)=Class'SkillComputer'
    skillClasses(1)=Class'SkillTech'
    skillClasses(2)=Class'SkillEnviro'
    skillClasses(3)=Class'SkillLockpicking'
    skillClasses(4)=Class'SkillMedicine'
    skillClasses(5)=Class'SkillSwimming'
    skillClasses(6)=Class'SkillDemolition'
    skillClasses(7)=Class'SkillWeaponHeavy'
    skillClasses(8)=Class'SkillWeaponLowTech'
    skillClasses(9)=Class'SkillWeaponPistol'
    skillClasses(10)=Class'SkillWeaponRifle'
    NoToolMessage="You need the %s"
    NoSkillMessage="%s skill level insufficient to use the %s"
    SuccessMessage="Success!"
    YourSkillLevelAt="Your skill level at %s is now %d"
    bHidden=True
    bTravel=True
}
