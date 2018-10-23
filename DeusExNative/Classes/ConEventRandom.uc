class ConEventRandom extends ConEvent native transient;


var() Array<string> Labels;
var bool bCycleEvents;
var bool bCycleOnce;
var bool bCycleRandom;

var int  cycleIndex;
var bool bLabelsCycled;


defaultproperties {
	EventType = ET_Random
}
