class ConEventAnimation extends ConEvent native transient;


var string EventOwnerName;
var string SeqStr;
var EAnimationMode PlayMode;
var int PlayLength;
var bool bFinishAnim;

var Actor eventOwner;				// Pawn who owns this event
var Name sequence;					// Animation Sequence
var Bool bLoopAnim;					// Loop Animation


defaultproperties {
	EventType = ET_Animation
}
