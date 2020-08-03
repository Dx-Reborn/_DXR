class FlyController extends AnimalController;

state Wandering
{
    event bool NotifyHitWall(vector HitNormal, actor HitWall)
    {
        local float   elasticity;

        elasticity = 0.3;
        pawn.Velocity = elasticity*((Velocity dot HitNormal) * HitNormal * (-2.0) + pawn.Velocity);
        pawn.DesiredRotation = pawn.Rotation;

        return true;
    }

    event Tick(float deltaTime)
    {
        Super.Tick(deltatime);
    }

    function vector PickDirection()
    {
        local vector  dirVector;
        local rotator rot;

        if (!Fly(pawn).IsNearHome(pawn.Location))
            dirVector = Normal(Fly(pawn).homeLoc - Fly(pawn).Location) * Fly(pawn).AirSpeed*4;
        else
            dirVector = Fly(pawn).Velocity;
        dirVector += VRand() * Fly(pawn).AirSpeed*2;
        dirVector = Normal(dirVector);
        rot = Rotator(dirVector);
        if (VSize(Fly(pawn).Velocity) < Fly(pawn).AirSpeed*0.5)
        {
            Fly(pawn).Acceleration = dirVector * Fly(pawn).AirSpeed;
            Fly(pawn).SetRotation(rot);
        }
        return vector(rot) * 200 + Fly(pawn).Location;
    }

    function BeginState()
    {
        Super.BeginState();
        Fly(pawn).BlockReactions();
        Fly(pawn).Acceleration = vector(pawn.Rotation) * pawn.AccelRate;
    }

Begin:
    Fly(pawn).bBounce = True;
    Fly(pawn).destPoint = None;
    MoveTo(pawn.Location + Vector(pawn.Rotation) * (pawn.CollisionRadius + 5),,true);

Init:
    Fly(pawn).bAcceptBump = false;
    Fly(pawn).TweenToWalking(0.15);
    WaitForLanding();
    FinishAnim();

Wander:
    Fly(pawn).PlayWalking();

Moving:
    TurnTo(PickDirection());
    Sleep(0.0);
    Goto('Moving');

ContinueWander:
ContinueFromDoor:
    Fly(pawn).PlayWalking();
    Goto('Wander');
}
