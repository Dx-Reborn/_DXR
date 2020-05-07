//=============================================================================
// ConPlayBark
//=============================================================================
class ConPlayBark extends Actor;

var ConDialogue con;
var int currentIndex;

// ----------------------------------------------------------------------
// SetConversation()
// ----------------------------------------------------------------------

function SetConversation(ConDialogue newCon)
{
    con = newCon;
}

// ----------------------------------------------------------------------
// GetBarkSpeech()
// ----------------------------------------------------------------------

function ConEventSpeech GetBarkSpeech()
{
    local ConEvent myevent;
    local ConEventSpeech outSpeech;
    local int i;

    // Abort if we don't have a valid conversation
    if (con == None)
        return None;

    // Default return value
    outSpeech = None;

    // Loop through the events until we hit some speech
//  myevent = con.eventList;
    
  for (i=0; i<con.EventList.length; i++) // while(myevent != None)
    {
      currentIndex = i;
        switch(con.EventList[i].eventType) //myevent.eventType)
        {
            case ET_Speech:
                outSpeech = ConEventSpeech(con.EventList[i]);//.conSpeech;
                myevent = None;
                break;
            
            case ET_Jump:
                myevent = ProcessEventJump(ConEventJump(con.EventList[i]));
                break;

            case ET_Random:
                myevent = ProcessEventRandomLabel(ConEventRandom(con.EventList[i]));
                break;

            case ET_End:
                myevent = None;
                break;

            default:
                myevent = con.GetNextEvent(myevent);//myevent.nextEvent;
                break;
        }
    }
    return outSpeech;
}

// ----------------------------------------------------------------------
// ProcessEventJump()
// ----------------------------------------------------------------------

function ConEvent ProcessEventJump(ConEventJump aevent)
{
    local ConEvent nextEvent;

    // Check to see if the jump label is empty.  If so, then we just want
    // to fall through to the next event.  This can happen when jump
    // events get inserted during the import process.  ConEdit will not
    // allow the user to create events like this. 

    if (aevent.jumpLabel == "")
    {
        nextEvent = con.GetNextEvent(aevent);//aevent.nextEvent;
    }
    else
    {
        if ((aevent.jumpCon != None) && (aevent.jumpCon != con))
            nextEvent = None;           // not yet supported
        else
            nextEvent = con.GetEventFromLabel(aevent.jumpLabel);
    }

    return nextEvent;
}

// ----------------------------------------------------------------------
// ProcessEventRandomLabel()
// ----------------------------------------------------------------------

function ConEvent ProcessEventRandomLabel(ConEventRandom aevent)
{
    local String nextLabel;
    local DeusExGlobals gl;

    gl = class'DeusExGlobals'.static.GetGlobals();

    // Pick a random label
    nextLabel = gl.GetRandomLabel(aevent);

    return con.GetEventFromLabel(nextLabel);
}

defaultproperties
{
  //bHidden=false
  bHidden=true
}
