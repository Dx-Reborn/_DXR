class ConEventMoveCamera extends ConEvent native transient;


var ECameraType CameraType;
var ECameraPosition CameraPosition;
var ECameraTransition CameraTransition;
var Vector CameraOffset;
var Rotator Rotation;
var float HeightModifier;
var float CenterModifier;
var float DistanceMultiplier;


// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

// Actor, used with CT_Actor camera type
var Actor cameraActor;						// Actor who owns this event
var String cameraActorName;					// Text name

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_MoveCamera
}
