/*

*/
class BirdController extends AnimalController;

state Wandering
{
    function BeginState()
    {
        Super.BeginState();
//      AISetEventCallback('LoudNoise', 'HeardNoise');
    }

    function EndState()
    {
        Super.EndState();
//      AIClearEventCallback('LoudNoise');
    }

//    function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, name damageType)
    function NotifyTakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class <damageType> damageType)
    {
        Global.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);

        if ((DamageType == class'DM_EMP') || (DamageType == class'DM_NanoVirus'))
            return;

        if (pawn.health <= 0)
            return;
        enemy = instigatedBy;
        if (Enemy != None)
            LastSeenPos = Enemy.Location;
        //SetNextState('Flying', 'Begin');
        //GotoState('TakingHit');
        bird(pawn).MakeFrightened();
        GotoState('Flying');
    }

    function PickDestination()
    {
        local int   iterations;
        local float magnitude;

        magnitude  = (bird(pawn).wanderlust*300+100) * (FRand()*0.2+0.9); // 100-400, +/-10%
        iterations = 5;  // try up to 5 different directions

        if (!AIPickRandomDestination(30, magnitude, 0, 0, 0, 0, iterations, FRand()*0.4+0.35, bird(pawn).destLoc))
            bird(pawn).destLoc = bird(pawn).Location;
    }

    function HeardNoise(Name eventName, DeusExPawn.EAIEventState state, DeusExPawn.XAIParams params)
    {
        bird(pawn).FleeFromPawn(Pawn(params.bestActor));
    }

    event Tick(float deltaSeconds)
    {
        Super.Tick(deltaSeconds);

        bird(pawn).lastCheck += deltaSeconds;
        if (bird(pawn).lastCheck > 0.5)
        {
            bird(pawn).lastCheck = 0;
            if (FRand() < 0.1)
            {
                if (bird(pawn).IsA('Pigeon'))  // hack!
                    bird(pawn).PlaySound(Sound'PigeonCoo', SLOT_Misc);
                else if (bird(pawn).IsA('Seagull'))  // hack!
                    bird(pawn).PlaySound(Sound'SeagullCry', SLOT_Misc);
            }
        }
    }
}


state Flying
{
    event bool NotifyHitWall(vector HitNormal, actor Wall)
    {
        local Vector  newVector;
        local Rotator newRotator;

        if (bird(pawn).hitTimer > 0)
            return true;

        bird(pawn).hitTimer = 0.5;
        Disable('NotifyHitWall');

        newVector    = (bird(pawn).Velocity dot HitNormal) * HitNormal * (-2.0) + bird(pawn).Velocity;
        newRotator   = Rotator(newVector);

        bird(pawn).SetRotation(newRotator);
        bird(pawn).DesiredRotation = newRotator;

        bird(pawn).Acceleration = vect(0, 0, 0);
        bird(pawn).Velocity     = newVector;
        if (VSize(bird(pawn).Velocity) < 0.01)
            bird(pawn).Velocity = Vector(bird(pawn).Rotation);

        bird(pawn).destLoc = bird(pawn).Location + 80*bird(pawn).Velocity/VSize(bird(pawn).Velocity);
        GotoState('Flying', 'KeepGoing');

        return true;
    }

    event Tick(float deltaSeconds)
    {
        local float rate;

        Global.Tick(deltaSeconds);

        if (bird(pawn).hitTimer > 0)
        {
            bird(pawn).hitTimer -= deltaSeconds;
            if (bird(pawn).hitTimer < 0)
            {
                bird(pawn).hitTimer = 0;
                Enable('NotifyHitWall');
            }
        }
        bird(pawn).stuck += deltaSeconds;

        if (bird(pawn).Physics == PHYS_Flying)
        {
            rate = FClamp(bird(pawn).Acceleration.Z+250, 0, 500)/500 + 0.5;
//          AnimRate = initialRate*rate;
        }
//      else if (bird(pawn).Physics == PHYS_Falling)
//          AnimRate = initialRate*0.1;
    }

/*  function HeardNoise(Name eventName, EAIEventState state, XAIParams params)
    {
        MakeFrightened();
    }*/

    function bool ReadyToLand()
    {
        local Pawn fearPawn;

        fearPawn = bird(pawn).FrightenedByPawn();
        if (fearPawn != None)
        {
            bird(pawn).MakeFrightened();
            return false;
        }
        else if (bird(pawn).fright > 0)
            return false;
        else if (FRand() <= bird(pawn).LikesFlying)
            return false;
        else
            return true;
    }

    function CheckStuck()
    {
        if (bird(pawn).stuck > 10.0)
            GotoState('Flying', 'Drop');
    }

    function bool CheckDestination(vector dest, out float magnitude, float minDist)
    {
        local bool retval;
        local float dist;

        retval = False;
        dist = magnitude;
        while (dist > minDist)
        {
            if (PointReachable(bird(pawn).Location+(dest*dist)))
                break;
            dist *= 0.5;
        }
        if (dist > minDist)
        {
            magnitude = dist;
            retval    = True;
        }

        return (retval);
    }

    function PickDestination()
    {
        local vector dest;
        local float  magnitude;
        local int    iterations;
        local bool   bValid;

        iterations = 4;
        while (iterations > 0)
        {
            //magnitude = 800+(FRand()*100-50);
            magnitude = 1200+(FRand()*200-100);
            dest = VRand();
            bValid = CheckDestination(dest, magnitude, 100);
            if (!bValid && (dest.Z != 0))
            {
                dest.Z = -dest.Z;
                bValid = CheckDestination(dest, magnitude, 100);
            }
            if (bValid)
                break;

            iterations--;
        }
        if (iterations > 0)
        {
            bird(pawn).destLoc = bird(pawn).Location + (dest*magnitude);
            bird(pawn).stuck = 0;
        }
        else
        {
            if (VSize(Velocity) > 0.001)
                bird(pawn).destLoc = 40*bird(pawn).Velocity/VSize(bird(pawn).Velocity);
            else
                bird(pawn).destLoc = bird(pawn).Velocity;
            if (bird(pawn).stuck > 5.0)
                bird(pawn).destLoc += VRand()*((bird(pawn).stuck-5.0)*3.0);
            bird(pawn).destLoc += bird(pawn).Location;
        }
    }

    function PickInitialDestination()
    {
        local vector  dest;
        local rotator rot;
        local float   magnitude;

        //magnitude = 200 + (FRand()*50-25);
        magnitude = 300 + (FRand()*100-50);
        rot.yaw = bird(pawn).Rotation.yaw;
        //rot.pitch = 8192+(Rand(6000)-3000);
        rot.pitch = 10000+(Rand(6000)-3000);
        rot.roll = 0;
        dest = Vector(rot);
        if (CheckDestination(dest, magnitude, 20))
            bird(pawn).destLoc = bird(pawn).Location + (dest*magnitude);
        else
            bird(pawn).destLoc = bird(pawn).Location + vect(0, 0, 100);
    }

    function bool PickFinalDestination()
    {
        local Actor  landActor;
        local vector hitLoc;
        local vector hitNorm;
        local vector endPoint;
        local vector startPoint;
        local int    iterations;
        local bool   retval;

        retval = False;

        iterations = 3;
        while (iterations > 0)
        {
            startPoint = VRand()*100 + bird(pawn).Location;
            startPoint.Z = bird(pawn).Location.Z;
            endPoint = startPoint;
            endPoint.Z -= 1000;
            foreach pawn.TraceActors(Class'Actor', landActor, hitLoc, hitNorm, endPoint, startPoint)
            {
                if (landActor == Level)
                {
                    hitLoc.Z += pawn.CollisionHeight+5;
                    if (PointReachable(hitLoc))
                        break;
                }
                else
                {
                    landActor = None;
                    break;
                }
            }
            if (landActor != None)
            {
                break;
            }
            iterations--;
        }

        if (iterations > 0)
        {
            bird(pawn).destLoc = hitLoc;
            retval  = true;
        }
        return (retval);
    }

    function BeginState()
    {
        bird(pawn).SetPhysics(PHYS_Flying);
        Enable('NotifyHitWall');
        bird(pawn).stuck       = 0;
        bird(pawn).hitTimer    = 0;
//      AISetEventCallback('LoudNoise', 'HeardNoise');
        if (pawn.IsA('Pigeon'))
            pawn.PlaySound(Sound'PigeonFly', SLOT_Misc);
        else if (pawn.IsA('Seagull'))
            pawn.PlaySound(Sound'SeagullFly', SLOT_Misc);
        pawn.SetCollision(true, false, false);
    }

    function EndState()
    {
        pawn.SetCollision(true, true, true);
        pawn.SetPhysics(PHYS_Falling);
        Enable('NotifyHitWall');
        //AIClearEventCallback('LoudNoise');
    }

Begin:
    bird(pawn).PlayFlying();

StartFlying:
    PickInitialDestination();
    MoveTo(bird(pawn).destLoc);

Fly:
    if (ReadyToLand())
        Goto('Land');
    PickDestination();

KeepGoing:
    CheckStuck();
    MoveTo(bird(pawn).destLoc);
    Goto('Fly');

Land:
    if (!PickFinalDestination())
    {
        PickDestination();
        Goto('KeepGoing');
    }
    MoveTo(bird(pawn).destLoc);
    pawn.SetPhysics(PHYS_Falling);
    WaitForLanding();
    pawn.Acceleration = vect(0, 0, 0);
    GotoState('Wandering');

Drop:
    pawn.DesiredRotation.pitch = -16384;
    pawn.SetPhysics(PHYS_Falling);
    Sleep(0.5);
    pawn.SetPhysics(PHYS_Flying);
    Goto('Fly');
}


// Kind of a hack, but...
state Fleeing
{
ignores all;
begin:
    GotoState('Flying');
}

state Attacking
{
ignores all;
begin:
    Sleep(0.5);
    GotoState('Wandering');
}

defaultproperties
{
     RotationRate=(Pitch=6000)
}
