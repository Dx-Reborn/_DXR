/*
   Sets a goal as completed when touched or triggered
   Set bCollideActors to False to make it triggered
*/

class GoalCompleteTrigger extends DeusExTrigger;

var() name goalName;

function PlayerPawn GetPlayerPawn()
{
   local PlayerPawn pl;

   pl = PlayerPawn(Level.GetLocalPlayerController().Pawn);
   if (pl != None)
       return pl;
}

function Trigger(Actor Other, Pawn Instigator)
{
    local Name goal;
    local DeusExPlayer player;

    Super.Trigger(Other, Instigator);

    player = DeusExPlayer(GetPlayerPawn());

    if (player != None)
    {
        // First check to see if this goal exists
        goal = player.FindGoal(goalName);

        if (goal != 'None')
            player.GoalCompleted(goalName);
    }
}

event Touch(Actor Other)
{
    local Name goal;
    local DeusExPlayer player;

    Super.Touch(Other);

    if (IsRelevant(Other))
    {
        player = DeusExPlayer(GetPlayerPawn());

        if (player != None)
        {
            // First check to see if this goal exists
            goal = player.FindGoal(goalName);

            if (goal != 'None')
                player.GoalCompleted(goalName);
        }
    }
}


defaultproperties
{
     bTriggerOnceOnly=True
     Texture=texture'DXRMenuImg.S_GoalCompleteTrigger'
     DrawScale=0.50
}
