class ConEventJump extends ConEvent native transient;


var string JumpLabel;
var int ConId;

// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var ConDialogue JumpCon;

// #endif // #ifdef REFACTOR_ME


defaultproperties {
	EventType = ET_Jump
}
