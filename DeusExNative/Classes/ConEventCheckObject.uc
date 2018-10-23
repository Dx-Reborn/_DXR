class ConEventCheckObject extends ConEvent native transient;


var string ObjectName;
var string FailLabel;

var class<Inventory> checkObject;		// Object to check for


defaultproperties {
	EventType = ET_CheckObject
}
