class ConEventSpeech extends ConEvent native transient;


var() int SpeakerId;
var() string SpeakerName;
var() string SpeakingToName;
var() string Speech;
var() string SoundPath;
var bool bContinued;
var bool bBold;
var ESpeechFont SpeechFont;

var() Actor speaker;				// Actor speaking
var() Actor speakingTo;			// Actor being spoken to


defaultproperties {
	EventType = ET_Speech
}
