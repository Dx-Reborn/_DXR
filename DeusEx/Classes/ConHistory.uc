//=============================================================================
// ConHistory
//=============================================================================
class ConHistory extends Resource;

var() String         conOwnerName;        // String name of conversation owner
var() String         strLocation;         // String description of location
var() String         strDescription;      // Conversation Description
var() int            ConId;
var() Bool            bInfoLink;          // True if InfoLink
var() ConHistoryEvent firstEvent;         // First Conversation History Event
var() ConHistoryEvent lastEvent;          // Last Event
var() ConHistory      next;               // Pointer to next ConHistory

// -------------------------------------------------------------------------
// AddEvent()
// -------------------------------------------------------------------------

function AddEvent(ConHistoryEvent newEvent)
{
    if (newEvent != None)
    {
        // Add to our list of events for this history object
        if (firstEvent == None)
            firstEvent = newEvent;

        if (lastEvent != None)
            lastEvent.next = newEvent;

        lastEvent = newEvent;
    }
}

// -------------------------------------------------------------------------
// -------------------------------------------------------------------------

defaultproperties
{
}
