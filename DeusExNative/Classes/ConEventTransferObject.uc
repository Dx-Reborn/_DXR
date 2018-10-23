class ConEventTransferObject extends ConEvent native transient;


var string ObjectName;
var int TransferCount;
var string FromName;
var string ToName;
var string FailLabel;

var Class<Inventory> giveObject;		// Object to transfer
var Actor  FromActor;					// Actor transfering from
var Actor ToActor;						// Actor transfering to


defaultproperties {
	EventType = ET_TransferObject
}
