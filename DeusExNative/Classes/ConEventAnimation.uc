class ConEventAnimation extends ConEvent native transient;


var string EventOwnerName;
var string SeqStr;
var EAnimationMode PlayMode;
var int PlayLength;
var bool bFinishAnim;



// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

var Actor eventOwner;				// Pawn who owns this event
var Name sequence;					// Animation Sequence
var Bool bLoopAnim;					// Loop Animation

// #endif // #ifdef REFACTOR_ME


defaultproperties {
	EventType = ET_Animation
}

