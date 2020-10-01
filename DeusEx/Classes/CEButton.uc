//=============================================================================
// CEButton. A Button that gets rid of the need of CESequenceTriggers.
// Put the Tag of the CaroneElevator in Event, and set the SeqNum, meaning
// the "keyframe" this button should send the elevator to
//=============================================================================
class CEButton extends Button1a;

var(CEButton) int nSeqNum;

function Frob(Actor Frobber, Inventory frobWith)
{
    local CaroneElevator CE;

    Super.Frob(Frobber, frobWith);

    foreach AllActors(class 'CaroneElevator', CE, Event)
    {
        CE.SetSeq(nSeqNum);
    }
}
defaultproperties
{
}
