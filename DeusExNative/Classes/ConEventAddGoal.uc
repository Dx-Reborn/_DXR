class ConEventAddGoal extends ConEvent native transient;


var string GoalNameString;
var string GoalText;
var bool bGoalCompleted;
var bool bPrimaryGoal;


defaultproperties {
	EventType = ET_AddGoal
}
