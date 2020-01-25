//
//--Для реорганизации--
//

class DeusExTrigger extends Trigger
													abstract;


function Touch(actor Other)
{
	local int i;
	local actor A;
	local bool  restoreGroup;  // DEUS_EX CNN

	if(IsRelevant(Other))
	{
		Other = FindInstigator(Other);

		if (ReTriggerDelay > 0)
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		TriggerEvent(Event, self, Other.Instigator);
		if(Event != '')
			foreach AllActors(class 'Actor', A, Event)
			{
				// DEUS_EX CNN
				// If the triggering actor doesn't have a group, then
				// we copy the trigger's group into the group of the triggerer
				// This will make LogicTriggers work correctly and won't
				// affect anything else
				if (Other.Group == '')
				{
					Other.Group = Group;
					restoreGroup = True;
				}
				else
					restoreGroup = False;

				A.Trigger( Other, Other.Instigator );

				// DEUS_EX CNN
				if (restoreGroup)
					Other.Group = '';
			}
		if ((Pawn(Other) != None) && (Pawn(Other).Controller != None))
		{
			for ( i=0;i<4;i++ )
				if ( Pawn(Other).Controller.GoalList[i] == self )
				{
					Pawn(Other).Controller.GoalList[i] = None;
					break;
				}
		}	
				
		if( (Message != "") && (Other.Instigator != None) )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage(Message);

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

function DeusExGameInfo getFlagBase()
{
  return DeusExGameInfo(Level.Game);
}
