class ConEventTransferObject extends ConEvent native transient;


var string ObjectName;
var int TransferCount;
var string FromName;
var string ToName;
var string FailLabel;



// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

var Class<Inventory> giveObject;		// Object to transfer
var Actor  FromActor;					// Actor transfering from
var Actor ToActor;						// Actor transfering to

// #endif // #ifdef REFACTOR_ME


defaultproperties {
	EventType = ET_TransferObject
}
