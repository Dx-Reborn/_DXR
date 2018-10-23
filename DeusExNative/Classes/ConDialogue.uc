class ConDialogue extends ConBase native transient
		dependson(Times);


var int Id;
var string Name;
var string Description;
var Times.FileTime CreatedOn;
var string CreatedBy;
var Times.FileTime LastModifiedOn;
var string LastModifiedBy;
var string OwnerName;
var string Notes;
var bool bDataLinkCon;
var bool bDisplayOnce;
var bool bFirstPerson;
var bool bNonInteractive;
var bool bRandomCamera;
var bool bCanBeInterrupted;
var bool bCannotBeInterrupted;
var bool bInvokeBump;
var bool bInvokeFrob;
var bool bInvokeSight;
var bool bInvokeRadius;
var int InvokeRadius;
var() Array<ConFlagRef> FlagRefList;
var() Array<ConEvent> EventList;

var float lastPlayedTime;		// Time when conversation last played (ended).
var int	  ownerRefCount;		// Number of owners this conversation has
var int   radiusDistance;		// Distance from PC needed to invoke conversation, 0 = Frob
var int   currentIndex;

var() array<int> foundIndexes;
var() array<String> foundLabels;


// Подхватить следующее событие исходя из переданного.
function ConEvent GetNextEvent(ConEvent StartFrom)
{
   local int i;
   local ConEvent next;

   for (i=0; i<EventList.length; i++)
   {
      if (EventList[i] == StartFrom)
          break;
   }
   next = EventList[i + 1];
   log(self$" found match: "$StartFrom$", next one is "$next,'NextEvent');

 return next;

//   return next;
/*   currentIndex += 1;

   if (currentIndex >= EventList.length)
       currentIndex = EventList.length -1;

   return EventList[currentIndex];
*/
}

// ----------------------------------------------------------------------
// Searches this conversation for a label and returns it.  If it can't
// find a matching label then it returns None.
// ----------------------------------------------------------------------
function ConEvent GetEventFromLabel(String searchLabel)
{
  local int i;
  local ConEvent currentEvent;

  for (i=0; i<EventList.length; i++)
  {
        if (Caps(searchLabel) == Caps(EventList[i].Label))
        break;
        currentEvent = EventList[i +1];
        currentIndex = i;
  }
//  log(self@" currentEvent="$currentEvent);
  if (currentEvent != none)
      return currentEvent;
    else 
  return EventList[currentIndex]; // Нету? Подхватить последнее.
}

// ----------------------------------------------------------------------
// Checks to see if all the actors doing speaking in the conversation
// actually exist.
// ----------------------------------------------------------------------
function bool CheckActors(optional bool bLogActors)
{
//  local ConEvent event;
	local ConEventSpeech eventSpeech;
	local bool bActorsValid;
	local int i;

	log(self$" checking actors...");

	bActorsValid = true;

  for (i=0; i<EventList.length; i++)
	{
		eventSpeech = ConEventSpeech(EventList[i]);
		//log("eventSpeech ="$eventSpeech);
		if (eventSpeech != None)
		{
		   if (bLogActors)
		   {
				log("======================== SEPARATOR =======================================================");
				log("eventSpeech.speaker="$eventSpeech.speaker);
				log("eventSpeech.speakerName="$eventSpeech.speakerName);
				log("eventSpeech.speakingTo="$eventSpeech.speakingTo);
				log("eventSpeech.speakingToName="$eventSpeech.speakingToName);
				log("========================!SEPARATOR =======================================================");
			 }	

			if ((eventSpeech.speaker == None) || (eventSpeech.speakingTo == None))
			{
				bActorsValid = False;

				if (bLogActors)
				{
					if (eventSpeech.speaker == None)
						log("  SpeakingActor   =" @ eventSpeech.speakerName);
					if (eventSpeech.speakingTo == None)
						log("  SpeakingToActor =" @ eventSpeech.speakingToName);
				}
				else
				{
					break;
				}			
			}
		}
	}
	log("checkActors actors are valid? "$bActorsValid);
	return bActorsValid;
}

// ----------------------------------------------------------------------
// Checks to see how far all the actors are away from each other 
// to make sure it's reasonable to start a conversation.
// Ignore the player in these checks.
// ----------------------------------------------------------------------
function bool CheckActorDistances(Actor player)
{
//	local ConEvent event;
	local ConEventSpeech eventSpeech;
	local int  i;
	local int  dist;
	local bool bDistanceValid;

	bDistanceValid = True;

	// First fill up our array of actors
  for (i=0; i<EventList.length; i++)
	{
		eventSpeech = ConEventSpeech(EventList[i]);
		if (eventSpeech != None)
		{
			// Check the distance between the two actors
			if ((eventSpeech.speaker != None) && (eventSpeech.speaker != player) && (eventSpeech.speakingTo != None) && (eventSpeech.speakingTo != player))
			{
				dist = VSize(eventSpeech.speaker.Location - eventSpeech.speakingTo.Location);

				if (dist > 300)
				{
					bDistanceValid = False;
					break;
				}
			}
		}
	}
	return bDistanceValid;
}

// ----------------------------------------------------------------------
// Looks for the first Speech event in this conversation and returns
// the speaker and speakingTo actors.  This is used to setup the first
// camera event
// ----------------------------------------------------------------------
function GetFirstSpeechActors(out Actor firstSpeaker, out Actor firstSpeakingTo)
{
//	local ConEvent conEvent;
	local int i;

	firstSpeaker    = None;
	firstSpeakingTo = None;

  for (i=0; i<EventList.length; i++)
	{	
		if (ConEventSpeech(EventList[i]) != None)
		{
			firstSpeaker    = ConEventSpeech(EventList[i]).speaker;
			firstSpeakingTo = ConEventSpeech(EventList[i]).speakingTo;
			break;
		}
	}
}

function String GetFirstSpeakerDisplayName(optional String startLabel)
{
	local ConEvent conEvent;
	local ConDialogue con;
	local String SpeakerName;
	local int i;

	if (startLabel != "")
		conEvent = GetEventFromLabel(startLabel);
	else
	{
   for (i=0; i<EventList.length; i++)
   {
		// Follow any jump events
		if (ConEventJump(EventList[i]) != None)
		{
			if (ConEventJump(EventList[i]).jumpCon != None)
			{
				con = ConEventJump(EventList[i]).jumpCon;
				speakerName = con.GetFirstSpeakerDisplayName(ConEventJump(EventList[i]).jumpLabel);
				break;
			}
		}
		// If this is a speech event, grab the name and quit.
		if (ConEventSpeech(EventList[i]) != None)
		{	
			speakerName = ConEventSpeech(EventList[i]).speakerName;
			break;
		}
	 }
	}
	return speakerName;
}

// ----------------------------------------------------------------------
// Looks to see if the actor passed in is even involved in this
// conversation.  Returns True if the actor has a speaking part.
// ----------------------------------------------------------------------
function bool IsSpeakingActor(Actor speakingActor)
{
	local bool bSpeaking;
	local ConEventSpeech eventSpeech;
//	local ConEvent event;
	local int i;

//	while(event != None)
  for (i=0; i<EventList.length; i++)
	{
		eventSpeech = ConEventSpeech(EventList[i]);
		if (eventSpeech != None)
		{
			if ((eventSpeech.speakerName == speakingActor.GetBindName()) || (eventSpeech.speakingToName == speakingActor.GetBindName()))
			{
				bSpeaking = True;
				break;
			}
		}
	}

	return bSpeaking;
}



defaultproperties
{
  currentIndex=0
}

