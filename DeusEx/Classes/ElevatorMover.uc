//=============================================================================
// ElevatorMover.
//=============================================================================
class ElevatorMover extends Mover;

var() bool bFollowKeyframes;
// Lets you move to a specified keyframe

var bool bIsMoving;

event BeginPlay()
{
    Super.BeginPlay();
    bIsMoving = False;
}

function SetSeq(int seqnum)
{
    if (bIsMoving)
        return;

    if (KeyNum != seqnum)
    {
        KeyNum = seqnum;
        GotoState('ElevatorMoverEx', 'Next');
    }
}

//  аронеЁлеватор работает только если им€ стэйта отличаетс€ от имени класса.
// «десь скорее всего аналогично...
auto state() ElevatorMoverEx
{
    event KeyFrameReached()
    {
        if (bFollowKeyframes)
            Super.KeyFrameReached();
    }
//  function InterpolateEnd(actor Other){if (bFollowKeyframes) Super.InterpolateEnd(Other);}

Next:
    bIsMoving = True;
    PlaySound(OpeningSound);
    AmbientSound = MoveAmbientSound;
    InterpolateTo(KeyNum, MoveTime);
    FinishInterpolation();
    AmbientSound = None;
    FinishedOpening();
    bIsMoving = False;
    Stop;
}


defaultproperties
{
     InitialState=ElevatorMoverEx
}
