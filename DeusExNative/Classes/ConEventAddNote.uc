class ConEventAddNote extends ConEvent native transient;


var string NoteText;
var bool      bNoteAdded;			// Used to prevent note from getting added twice


defaultproperties {
	EventType = ET_AddNote
}
