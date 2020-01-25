//=============================================================================
// ConHistoryEvent
//=============================================================================
class ConHistoryEvent extends Resource;

var()  String          conSpeaker;         // Speaker
var()  String          speech;             // Speech
var()  string          soundID;            // Sound file associated with speech
var()  ConHistoryEvent next;               // Next event

defaultproperties
{
}
