class ConEventTrade extends ConEvent native transient;


var string EventOwnerName;


// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

var Actor eventOwner;				// Actor who initiates Trade

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_Trade
}
