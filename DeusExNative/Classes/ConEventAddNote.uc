class ConEventAddNote extends ConEvent native transient;


var string NoteText;

// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

var bool      bNoteAdded;			// Used to prevent note from getting added twice

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_AddNote
}
