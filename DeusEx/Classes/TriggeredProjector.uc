class TriggeredProjector extends Projector;

var() bool bInitiallyOn;
var   bool bIsOn;

event PostBeginPlay()
{
    AttachProjector();
    if (bProjectActor)
        SetCollision(True,False,False);

    bIsOn = bInitiallyOn;

    if (!bIsOn)
    {
       DetachProjector(true);
       DetachAllActors();
    }
}


function Trigger(actor Other,pawn Instigator)
{
    bIsOn = !bIsOn;
    if (bIsOn)
    {
       AttachProjector();
       ReattachAllActors();
    }
    else
    {
       DetachProjector(true);
       DetachAllActors();
    }
}

function DetachAllActors()
{
    local actor A;

    foreach TouchingActors(class'Actor',A)
    {
       DetachActor(A);
    }
}

function ReattachAllActors()
{
    local actor A;

    foreach TouchingActors(class'Actor',A)
    {
       AttachActor(A);
    }
}

event Touch(Actor Other)
{
    if (bIsOn)
        AttachActor(Other);
}

event Untouch(Actor Other)
{
    DetachActor(Other);
}


defaultproperties
{

}

