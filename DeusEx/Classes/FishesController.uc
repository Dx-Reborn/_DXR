class FishesController extends AnimalController;

state Wandering
{
    event bool NotifyHitWall(vector HitNormal, actor HitWall)
    {
        local rotator dir;
        local float   elasticity;
        local float   minVel, maxHVel;
        local vector  tempVect;

        if (Fishes(pawn).Physics == PHYS_Swimming)
        {
            if (Fishes(pawn).bumpTimer > 0)
                return true;

            Fishes(pawn).bumpTimer = 0.5;

            if (Fishes(pawn).bStayHorizontal)
                HitNormal = Normal(HitNormal*vect(1,1,0));
            elasticity = 1.0;
            Fishes(pawn).Velocity = elasticity*((Fishes(pawn).Velocity dot HitNormal) * HitNormal * (-2.0) + Fishes(pawn).Velocity);
            dir = Rotator(Velocity);

            if (Fishes(pawn).bStayHorizontal)
                dir.Pitch = 0;

            Fishes(pawn).SetRotation(dir);
            Fishes(pawn).DesiredRotation = dir;
            Fishes(pawn).Acceleration = Vector(dir)*Fishes(pawn).AccelRate;
        }
        else
        {
            elasticity = 0.3;
            Fishes(pawn).Velocity = elasticity*((Fishes(pawn).Velocity dot HitNormal) * HitNormal * (-2.0) + Fishes(pawn).Velocity);
            minVel  = 100;
            maxHVel = 20;
            Fishes(pawn).Velocity += VRand()*5 * vect(1,1,0);
            tempVect = Fishes(pawn).Velocity * vect(1,1,0);

            if (VSize(tempVect) > maxHVel)
                Fishes(pawn).Velocity = Normal(tempVect)*maxHVel + vect(0,0,1)*Fishes(pawn).Velocity.Z;

            if (VSize(Fishes(pawn).Velocity) < minVel)
                Fishes(pawn).Velocity = Normal(Fishes(pawn).Velocity)*minVel*(FRand()*0.2+1);

            dir = Rotator(VRand());
            Fishes(pawn).SetRotation(dir);
            Fishes(pawn).DesiredRotation = dir;
        }
        Fishes(pawn).forwardTimer = -1;
        GotoState('Wandering', 'Moving');
    }

    event bool NotifyPhysicsVolumeChange(PhysicsVolume newZone)
    {
        local Rotator newRotation;
        if (NewZone.bWaterVolume && !Pawn.PhysicsVolume.bWaterVolume)
        {
            if (!Fishes(pawn).bStayHorizontal)
            {
                newRotation = Fishes(pawn).Rotation;
                newRotation.Pitch = -1500;
                Fishes(pawn).SetRotation(newRotation);
                Fishes(pawn).DesiredRotation = newRotation;
                Fishes(pawn).leaderTimer = 1.0;
                GotoState('Wandering', 'Moving');
            }
        }
        return true;
    }

    event Tick(float deltatime)
    {
        Super.Tick(deltatime);
        Fishes(pawn).leaderTimer  -= deltaTime;
        Fishes(pawn).forwardTimer -= deltaTime;
        Fishes(pawn).bumpTimer    -= deltaTime;

        if (Fishes(pawn).leaderTimer < -2.0)
            Fishes(pawn).ResetLeaderTimer();

        if (Fishes(pawn).bumpTimer < 0)
            Fishes(pawn).bumpTimer = 0;

        if (Fishes(pawn).abortTimer >= 0)
            Fishes(pawn).abortTimer += deltaTime;

        if (Fishes(pawn).abortTimer > 8.0)
        {
            Fishes(pawn).abortTimer = -1;
            GotoState('Wandering', 'Moving');
        }
        if (Fishes(pawn).PhysicsVolume.bWaterVolume)
            Fishes(pawn).breatheTimer = 0;
        else
        {
            Fishes(pawn).breatheTimer += deltaTime;
            if (Fishes(pawn).breatheTimer > 8)
            {
                Fishes(pawn).TakeDamage(5, None, Location, vect(0,0,0), class'DM_Drowned');
                Fishes(pawn).breatheTimer = 6;
            }
        }
    }

    function vector PickDirection(bool bForward)
    {
        local Actor         nearbyActor;
        local Fishes        nearbyFish;
        local PawnGenerator genOwner;
        local vector        cumVector;
        local rotator       rot;
        local float         dist;
        local vector        centerVector;

        if (bForward || Fishes(pawn).IsNearHome(Fishes(pawn).Location))
            cumVector = Fishes(pawn).Velocity;
        else
            cumVector = (Fishes(pawn).homeLoc - Fishes(pawn).Location)*20;
        if ((Fishes(pawn).leaderTimer > 0) && !bForward && Fishes(pawn).bFlock)
        {
            genOwner = PawnGenerator(Fishes(pawn).Owner);
            if (genOwner == None)
            {
                foreach Fishes(pawn).RadiusActors(Class, nearbyActor, 300)
                {
                    nearbyFish = Fishes(nearbyActor);
                    if ((nearbyFish != None) && (nearbyFish != self) && nearbyFish.bFlock && (PawnGenerator(nearbyFish.Owner) == None))
                        cumVector += nearbyFish.Velocity;
                }
            }
            else
            {
                cumVector += genOwner.SumVelocities - Fishes(pawn).Velocity;
                centerVector = (genOwner.FlockCenter - Fishes(pawn).Location);
                dist = VSize(centerVector);
                if ((dist > genOwner.Radius) && (dist < genOwner.Radius*4))
                    cumVector += centerVector*2;
            }
        }
        if (cumVector == vect(0,0,0))
            cumVector = Vector(Rotation);
        rot = Rotator(cumVector);

        if (Fishes(pawn).bStayHorizontal)
            rot.Pitch = 0;

        if (!bForward)
        {
            if ((Fishes(pawn).leaderTimer > 1.2) && Fishes(pawn).bFlock)
            {
                rot.Yaw += Rand(8192)-4096;
                if (!Fishes(pawn).bStayHorizontal)
                    rot.Pitch += Rand(3000)-1500;
            }
            return vector(rot)*200+Fishes(pawn).Location;
        }
        else
            return vector(rot)*50+Fishes(pawn).Location;
    }

    function BeginState()
    {
        Super.BeginState();
        Fishes(pawn).BlockReactions();
        Fishes(pawn).abortTimer = -1;
    }

    function EndState()
    {
        Super.EndState();
        Fishes(pawn).bBounce = False;
    }

Begin:
    Fishes(pawn).bBounce = True;
    Fishes(pawn).destPoint = None;
    MoveTo(pawn.Location + Vector(pawn.Rotation) * (pawn.CollisionRadius + 5),,true);

Init:
    Fishes(pawn).bAcceptBump = false;
    Fishes(pawn).TweenToWalking(0.15);
    WaitForLanding();
    FinishAnim();

Wander:
    Fishes(pawn).PlayWalking();

Moving:
    Fishes(pawn).abortTimer = 0;
    if (Fishes(pawn).forwardTimer < 0)
    {
        MoveTo(PickDirection(true),,true);
        Fishes(pawn).ResetForwardTimer();
    }
    else
        TurnTo(PickDirection(false));
    Fishes(pawn).abortTimer = -1;
    Sleep(0.0);
    Goto('Moving');

ContinueWander:
ContinueFromDoor:
    Fishes(pawn).PlayWalking();
    Goto('Wander');
}


defaultproperties
{
     MinHitWall=0.000000
     RotationRate=(Pitch=6000,Yaw=25000)
}