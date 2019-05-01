class ConEventAnimation extends ConEvent native transient;


var string EventOwnerName;
var string SeqStr;
var EAnimationMode PlayMode;
var int PlayLength;
var bool bFinishAnim;



// #ifdef REFACTOR_ME
// TODO: Содержимое REFACTOR_ME-блока не хранится в файлах диалогов, лучше вынести в классы для работы с диалогами в DeusEx.u

var Actor eventOwner;				// Pawn who owns this event
var Name sequence;					// Animation Sequence
var Bool bLoopAnim;					// Loop Animation

// #endif // #ifdef REFACTOR_ME


defaultproperties {
	EventType = ET_Animation
}

