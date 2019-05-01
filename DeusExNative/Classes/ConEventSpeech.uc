class ConEventSpeech extends ConEvent native transient;


var() int SpeakerId;
var() string SpeakerName;
var() string SpeakingToName;
var() string Speech;
var() string SoundPath;
var bool bContinued;
var bool bBold;
var ESpeechFont SpeechFont;


// #ifdef REFACTOR_ME
// TODO: ���������� REFACTOR_ME-����� �� �������� � ������ ��������, ����� ������� � ������ ��� ������ � ��������� � DeusEx.u

var() Actor speaker;			// Actor speaking
var() Actor speakingTo;			// Actor being spoken to

// #endif // #ifdef REFACTOR_ME

defaultproperties {
	EventType = ET_Speech
}
