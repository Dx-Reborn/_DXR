//=============================================================================
// Seat.
//=============================================================================
class Seat extends Furniture
    abstract;

//
// Seat class to allow NPCs to sit down
//

var() Vector sitPoint[4];
var Actor sittingActor[4];
var int numSitPoints;
var vector InitialPosition;

event BeginPlay()
{
    local int i;

    super.BeginPlay();

    // count how many sitpoints are valid
    for(i=0; i<ArrayCount(sitPoint); i++)
    {
        if (sitPoint[i] != vect(-1000,-1000,-1000))
            numSitPoints++;
        else
            break;
    }
    InitialPosition = Location;
}

function Bump(actor Other)
{
    local bool         bInUse;
    local int          i;

    bInUse = false;
    for (i=0; i<ArrayCount(sittingActor); i++)
    {
        if (sittingActor[i] != None)
        {
            if ((sittingActor[i] == Other) || ((ScriptedPawn(sittingActor[i]) != None) && ScriptedPawn(sittingActor[i]).bSitting))
            {
                bInUse = true;
                break;
            }
        }
    }

    // If we're in use, ignore bump (no pushing)
    if (!bInUse)
        Super.Bump(Other);
}

function int StandingCount()
{
   if (SittingActor[0] != none)
       return 2;
    else
       return 0;
}

event Destroyed()
{
    local int i;

    for (i=0; i<ArrayCount(sittingActor); i++)
       if (sittingActor[i] != None)
            ScriptedPawn(SittingActor[i]).FollowOrders();

   Super.Destroyed();
}

defaultproperties
{
     sitPoint(0)=(X=-1000.000000,Y=-1000.000000,Z=-1000.000000)
     sitPoint(1)=(X=-1000.000000,Y=-1000.000000,Z=-1000.000000)
     sitPoint(2)=(X=-1000.000000,Y=-1000.000000,Z=-1000.000000)
     sitPoint(3)=(X=-1000.000000,Y=-1000.000000,Z=-1000.000000)
     bCanBeBase=True
}
