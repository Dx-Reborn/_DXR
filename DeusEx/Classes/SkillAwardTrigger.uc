//=============================================================================
// SkillAwardTrigger.
//=============================================================================
class SkillAwardTrigger extends DeusExTrigger;

// Gives the player skill points when touched or triggered
// Set bCollideActors to False to make it triggered

var() int skillPointsAdded;
var() localized String awardMessage;

function Trigger(Actor Other, Pawn Instigator)
{
	local PlayerController player;

	Super.Trigger(Other, Instigator);

	player = Level.GetLocalPlayerController();

	if (player != None)
	{
		Human(player.pawn).SkillPointsAdd(skillPointsAdded);
		Human(player.pawn).ClientMessage(awardMessage);
	}
}

function Touch(Actor Other)
{
	local PlayerController player;

	Super.Touch(Other);

	if (IsRelevant(Other))
	{
		player = Level.GetLocalPlayerController();

		if (player != None)
		{
			Human(player.pawn).SkillPointsAdd(skillPointsAdded);
			Human(player.pawn).ClientMessage(awardMessage);
		}
	}
}

defaultproperties
{
    skillPointsAdded=10
    awardMessage="DEFAULT SKILL AWARD MESSAGE - REPORT THIS AS A BUG"
    bTriggerOnceOnly=True
}
