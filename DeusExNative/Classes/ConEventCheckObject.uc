class ConEventCheckObject extends ConEvent native transient;


var string ObjectName;
var string FailLabel;


// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

var class<Inventory> checkObject;		// Object to check for

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_CheckObject
}
