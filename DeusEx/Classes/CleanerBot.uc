//=============================================================================
// CleanerBot.
//=============================================================================
class CleanerBot extends Robot;

const CLEANUP_DECALS_RADIUS = 500;

var float blotchTimer;
var float fleePawnTimer;

enum ECleanDirection  {
    CLEANDIR_North,
    CLEANDIR_South,
    CLEANDIR_East,
    CLEANDIR_West
};

var ECleanDirection minorDir;
var ECleanDirection majorDir;

event Tick(float deltaSeconds)
{
    local DeusExPawn  fearPawn;
    local DeusExDecal blotch;
    local float       deltaXY, deltaZ;

    Super.Tick(deltaSeconds);

    fleePawnTimer += deltaSeconds;
    if (fleePawnTimer > 0.5)
    {
        fleePawnTimer = 0;
        fearPawn = FrightenedByPawn();
        if (fearPawn != None)
            FleeFromPawn(fearPawn);
    }

    blotchTimer += deltaSeconds;
    if (blotchTimer > 0.3)
    {
        blotchTimer = 0;
        foreach RadiusActors(Class'DeusExDecal', blotch, CollisionRadius*2)
        {
            deltaXY = VSize((blotch.Location-Location)*vect(1,1,0));
            deltaZ  = blotch.Location.Z - Location.Z;
            if ((deltaXY <= CollisionRadius*1.2) && (deltaZ < 0) && (deltaZ > -(CollisionHeight+10)))
                blotch.Destroy();
        }
    }
}


// hack -- copied from Animal.uc
function DeusExPawn FrightenedByPawn()
{
    local DeusExPawn  candidate;
    local bool        bCheck;
    local DeusExPawn  fearPawn;

    fearPawn = None;
    if (!bBlockActors && !bBlockPlayers)
        return fearPawn;

    foreach RadiusActors(Class'DeusExPawn', candidate, CLEANUP_DECALS_RADIUS)
    {
        bCheck = false;
        if (!ClassIsChildOf(candidate.Class, Class))
        {
            if (candidate.bBlockActors)
            {
                if (bBlockActors && !candidate.Controller.bIsPlayer)
                    bCheck = true;
                else if (bBlockPlayers && candidate.Controller.bIsPlayer)
                    bCheck = true;
            }
        }

        if (bCheck)
        {
            if ((candidate.MaxiStepHeight < CollisionHeight*1.5) && (candidate.CollisionHeight*0.5 <= CollisionHeight))
                bCheck = false;
        }

        if (bCheck)
        {
            if (ShouldBeStartled(candidate))
            {
                fearPawn = candidate;
                break;
            }
        }
    }
    return fearPawn;
}

function bool ShouldBeStartled(Pawn startler)
{
    local float speed;
    local float time;
    local float dist;
    local float dist2;
    local bool  bPh33r;

    bPh33r = false;
    if (IsValidEnemy(DeusExPawn(startler), false))
    {
        speed = VSize(startler.Velocity);
        if (speed >= 20)
        {
            dist = VSize(Location - startler.Location);
            time = dist/speed;
            if (time <= 2.0)
            {
                dist2 = VSize(Location - (startler.Location+startler.Velocity*time));
                if (dist2 < speed*0.8)
                    bPh33r = true;
            }
        }
    }

    return bPh33r;
}

function FleeFromPawn(Pawn fleePawn)
{
    SetEnemy(fleePawn, , true);
    Controller.GotoState('AvoidingPawn');
}



defaultproperties
{
     majorDir=CLEANDIR_East
     EMPHitPoints=20
     BindName="CleanerBot"
     FamiliarName="Cleaner Bot"
     UnfamiliarName="Cleaner Bot"
     WalkingPct=0.200000
     GroundSpeed=300.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     Health=20
     UnderWaterTime=20.000000
     bFullVolume=true // Иначе не издает звука "шипения"
     AmbientSound=Sound'DeusExSounds.Robot.CleanerBotMove'
     Mesh=mesh'DeusExCharacters.CleanerBot'
     SoundRadius=16
     SoundVolume=128
     CollisionRadius=18.000000
     //CollisionHeight=6.71
     CollisionHeight=11.210000
     Mass=70.000000
     Buoyancy=97.000000
     RotationRate=(Yaw=100000)
     ControllerClass=class'CleanerBotController'
}
