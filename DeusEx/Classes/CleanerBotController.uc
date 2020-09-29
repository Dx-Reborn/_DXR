/*
   Controller for CleanerBot.
*/

class CleanerBotController extends RobotController;

state Wandering
{
    ignores EnemyNotVisible;

    function SetFall()
    {
        StartFalling('Wandering', 'ContinueWander');
    }

    event bool NotifyBump(actor bumper)
    {
        if (CleanerBot(Pawn).bAcceptBump)
        {
            // If we get bumped by another actor while we wait, start wandering again
            CleanerBot(Pawn).bAcceptBump = false;
            CleanerBot(Pawn).Disable('AnimEnd');
            GotoState('Wandering', 'Wander');
        }

        // Handle conversations, if need be
        Global.NotifyBump(bumper);
        return false; // Когда true, Pawn не получает события Bump()
    }

    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        if (pawn.Physics == PHYS_Falling)
            return true;

        Global.HitWall(HitNormal, Wall);
        CheckOpenDoor(HitNormal, Wall);
        return true;
    }

    function rotator RotationDir(CleanerBot.ECleanDirection cleanDir)
    {
        local rotator rot;

        rot = rot(0,0,0);
        if      (cleanDir == CLEANDIR_North)
            rot.Yaw = 0;
        else if (cleanDir == CLEANDIR_South)
            rot.Yaw = 32768;
        else if (cleanDir == CLEANDIR_East)
            rot.Yaw = 16384;
        else if (cleanDir == CLEANDIR_West)
            rot.Yaw = 49152;

        return (rot);
    }

    function CleanerBot.ECleanDirection GetReverseDirection(CleanerBot.ECleanDirection cleanDir)
    {
        if (cleanDir == CLEANDIR_North)
                 cleanDir = CLEANDIR_South;
        else if (cleanDir == CLEANDIR_South)
            cleanDir = CLEANDIR_North;
        else if (cleanDir == CLEANDIR_East)
            cleanDir = CLEANDIR_West;
        else if (cleanDir == CLEANDIR_West)
            cleanDir = CLEANDIR_East;

        return (cleanDir);
    }

    function PickDestination()
    {
        local Rotator rot;
        local float   minorMagnitude, majorMagnitude;
        local float   minDist;

        MoveTarget = None;
        CleanerBot(Pawn).destPoint = None;

        minorMagnitude = 256;
        majorMagnitude = pawn.CollisionRadius*2;
        minDist        = 24;

        rot = RotationDir(CleanerBot(Pawn).minorDir);

        if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, minorMagnitude, CleanerBot(Pawn).destLoc))
        {
            CleanerBot(Pawn).minorDir = GetReverseDirection(CleanerBot(Pawn).minorDir);
            rot = RotationDir(CleanerBot(Pawn).majorDir);

            if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, majorMagnitude, CleanerBot(Pawn).destLoc))
            {
                CleanerBot(Pawn).majorDir = GetReverseDirection(CleanerBot(Pawn).majorDir);
                rot = RotationDir(CleanerBot(Pawn).minorDir);

                if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, minorMagnitude, CleanerBot(Pawn).destLoc))
                {
                    CleanerBot(Pawn).minorDir = GetReverseDirection(CleanerBot(Pawn).minorDir);
                    rot = RotationDir(CleanerBot(Pawn).majorDir);
                    if (!AIDirectionReachable(pawn.Location, rot.Yaw, rot.Pitch, minDist, majorMagnitude, CleanerBot(Pawn).destLoc))
                    {
                        CleanerBot(Pawn).majorDir = GetReverseDirection(CleanerBot(Pawn).majorDir);
                        CleanerBot(Pawn).destLoc = pawn.Location;  // give up
                    }
                }
            }
        }
    }

Begin:
    CleanerBot(Pawn).destPoint = None;

GoHome:
    CleanerBot(Pawn).bAcceptBump = false;
    CleanerBot(Pawn).TweenToWalking(0.15);
    WaitForLanding();
    FinishAnim();
    CleanerBot(Pawn).PlayWalking();

Wander:
    PickDestination();

Moving:
    // Move from pathnode to pathnode until we get where we're going
    CleanerBot(Pawn).PlayWalking();
    MoveTo(CleanerBot(Pawn).destLoc,,true);
//  MoveTo(destLoc, GetWalkingSpeed());

Pausing:
    if (CleanerBot(Pawn).destLoc == pawn.Location)
        Sleep(1.0);
    Goto('Wander');

ContinueWander:
ContinueFromDoor:
    FinishAnim();
    CleanerBot(Pawn).PlayWalking();
    Goto('Wander');
}
