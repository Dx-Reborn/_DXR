class RatController extends AnimalController;

// Ripped right out of ScriptedPawn and modified -- need to make this generic?
state Wandering
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling('Wandering', 'ContinueWander');
    }

    event bool NotifyBump(actor bumper)
    {
        if (Rat(pawn).bAcceptBump)
        {
            // If we get bumped by another actor while we wait, start wandering again
            Rat(pawn).bAcceptBump = False;
            Rat(pawn).Disable('AnimEnd');
            Rat(pawn).GotoState('Wandering', 'Wander');
        }
        // Handle conversations, if need be
        Global.Bump(bumper);
        return true;
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;
        Global.NotifyHitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return true;
    }

/*    function BeginState()
    {
        Super.BeginState();
    }

    function EndState()
    {
        Super.EndState();
    }*/

    function PickDestination()
    {
        local float   magnitude;
        local int     iterations;
        local bool    bSuccess;
        local Rotator rot;

        MoveTarget = None;
        Rat(pawn).destPoint  = None;
        iterations = 4;  // try up to 4 different directions
        while (iterations > 0)
        {
            // How far will we go?
            magnitude = (170*FRand()+80) * (FRand()*0.2+0.9); // 80-250, +/-10%

            // Choose our destination, based on whether we have a home base
            if (!Rat(pawn).bUseHome)
                bSuccess = AIPickRandomDestination(40, magnitude, 0, 0, 0, 0, 1,FRand() * 0.4+0.35, Rat(pawn).destLoc);
            else
            {
                if (magnitude > Rat(pawn).HomeExtent)
                    magnitude = Rat(pawn).HomeExtent * (FRand()*0.2+0.9);
                rot = Rotator(Rat(pawn).HomeLoc - pawn.Location);

                bSuccess = AIPickRandomDestination(50, magnitude, rot.Yaw, 0.25, rot.Pitch, 0.25, 1, FRand()*0.4+0.35, Rat(pawn).destLoc);
            }

            // Success?  Break out of the iteration loop
            if (bSuccess)
                if (IsNearHome(Rat(pawn).destLoc))
                    break;

            // We failed -- try again
            iterations--;
        }

        // If we got a destination, go there
        if (iterations <= 0)
            Rat(pawn).destLoc = pawn.Location;
    }

Begin:
    Rat(pawn).destPoint = None;

GoHome:
    Rat(pawn).bAcceptBump = false;
    Rat(pawn).TweenToWalking(0.15);
    WaitForLanding();
    Rat(pawn).FinishAnim();
    Rat(pawn).PlayWalking();

Wander:
    PickDestination();

Moving:
    // Move from pathnode to pathnode until we get where we're going
    Rat(pawn).PlayWalking();
    MoveTo(Rat(pawn).destLoc,,true);// GetWalkingSpeed());

Pausing:
    if (FRand() < 0.35)
        Goto('Wander');

    pawn.Acceleration = vect(0, 0, 0);
    Rat(pawn).PlayTurning();

    // Turn in the direction dictated by the WanderPoint, if there is one
    Rat(pawn).Enable('AnimEnd');
    Rat(pawn).TweenToWaiting(0.2);
    Rat(pawn).bAcceptBump = True;
    Rat(pawn).PlayScanningSound();
    Rat(pawn).sleepTime = FRand()*1+0.75;
    Sleep(Rat(pawn).sleepTime);
    Rat(pawn).Disable('AnimEnd');
    Rat(pawn).bAcceptBump = False;
    Rat(pawn).FinishAnim();
    Goto('Wander');

ContinueWander:
ContinueFromDoor:
    Rat(pawn).FinishAnim();
    Rat(pawn).PlayWalking();
    Goto('Wander');
}
