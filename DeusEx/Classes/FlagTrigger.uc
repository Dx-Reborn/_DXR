//=============================================================================
// FlagTrigger.
//=============================================================================
class FlagTrigger extends DeusExTrigger;

var() name flagName;
var() bool flagValue;
var() bool bSetFlag;
var() bool bTrigger;
var() bool bWhileStandingOnly;
var() int flagExpiration;

function Pawn GetPlayerPawn()
{
    return Level.GetLocalPlayerController().Pawn;
}


function Touch(Actor Other)
{
	local DeusExPlayer player;

	if (IsRelevant(Other))
	{
		player = DeusExPlayer(GetPlayerPawn());
		if (player != None)
		{
			if (bSetFlag)
			{
				if (flagExpiration == -1)
					player.getFlagBase().SetBool(flagName, flagValue);
				else
					player.getFlagBase().SetBool(flagName, flagValue,, flagExpiration);
			}

			if (bTrigger)
				if (player.getFlagBase().GetBool(flagName) == flagValue)
					Super.Touch(Other);
		}
	}
}

function UnTouch(Actor Other)
{
	local DeusExPlayer player;

	if (bWhileStandingOnly)
	{
		if (IsRelevant(Other))
		{
			player = DeusExPlayer(GetPlayerPawn());
			if (player != None)
			{
				if (bTrigger)
					if (player.getFlagBase().GetBool(flagName) == flagValue)
						Super.UnTouch(Other);

				if (bSetFlag)
				{
					if (flagExpiration == -1)
						player.getFlagBase().SetBool(flagName, !flagValue);
					else
						player.getFlagBase().SetBool(flagName, !flagValue,, flagExpiration);
				}
			}
		}
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	local DeusExPlayer player;
	local Actor A;

	player = DeusExPlayer(GetPlayerPawn());
	if (player != None)
	{
		if (bSetFlag)
		{
			if (flagExpiration == -1)
				player.getFlagBase().SetBool(flagName, flagValue);
			else
				player.getFlagBase().SetBool(flagName, flagValue,, flagExpiration);
		}

		if (bTrigger)
			if (player.getFlagBase().GetBool(flagName) == flagValue)
			{
				if (Event != '')
					foreach AllActors(class 'Actor', A, Event)
						A.Trigger(player, Instigator);

				Super.Trigger(Other, Instigator);
			}
	}
}

function UnTrigger(Actor Other, Pawn Instigator)
{
	local DeusExPlayer player;
	local Actor A;

	if (bWhileStandingOnly)
	{
		player = DeusExPlayer(GetPlayerPawn());
		if (player != None)
		{
			if (bTrigger)
				if (player.getFlagBase().GetBool(flagName) == flagValue)
				{
					if (Event != '')
						foreach AllActors(class 'Actor', A, Event)
							A.UnTrigger(player, Instigator);

					Super.UnTrigger(Other, Instigator);
				}

			if (bSetFlag)
			{
				if (flagExpiration == -1)
					player.getFlagBase().SetBool(flagName, !flagValue);
				else
					player.getFlagBase().SetBool(flagName, !flagValue,, flagExpiration);
			}
		}
	}
}


defaultproperties
{
     flagValue=True
     bSetFlag=True
     flagExpiration=-1
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
     texture=S_FlagTrigger
     drawscale=0.5
}
