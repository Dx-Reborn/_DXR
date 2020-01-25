//=============================================================================
// OrdersTrigger.
//=============================================================================
class OrdersTrigger extends DeusExTrigger;

var() name Orders;
var() name ordersTag;

//
// Send an NPC on a patrol route
//

function Trigger(Actor Other, Pawn Instigator)
{
	if (StartPatrolling())
	{
		Super.Trigger(Other, Instigator);
		if (bTriggerOnceOnly)
			Destroy();
	}
}

singular function Touch(Actor Other)
{
	if (!IsRelevant(Other))
		return;

	if (StartPatrolling())
		if (bTriggerOnceOnly)
			Destroy();
}

function bool StartPatrolling()
{
	local ScriptedPawn P;

	// find the target NPC to start on the patrol route
	if (Event != '')
	{
		foreach AllActors (class'ScriptedPawn', P, Event)
		{
			P.SetOrders(Orders, ordersTag, true);
			log("SetOrders from trigger: "$Orders$", ordersTag="$ordersTag);
		}
  }
	return True;
}


defaultproperties
{
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
     texture=S_OrdersTrigger
     drawscale=0.5
}
