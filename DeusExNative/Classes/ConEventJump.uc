class ConEventJump extends ConEvent native transient;


var string JumpLabel;
var int ConId;

// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

var ConDialogue JumpCon;

// #endif // #ifdef REFACTOR_ME


defaultproperties {
	EventType = ET_Jump
}
