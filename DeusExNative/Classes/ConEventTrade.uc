class ConEventTrade extends ConEvent native transient;


var Actor eventOwner;				// Actor who initiates Trade
var string EventOwnerName;


defaultproperties {
	EventType = ET_Trade
}
