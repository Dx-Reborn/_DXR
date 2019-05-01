class ConEventAddNote extends ConEvent native transient;


var string NoteText;

// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var bool      bNoteAdded;			// Used to prevent note from getting added twice

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_AddNote
}
