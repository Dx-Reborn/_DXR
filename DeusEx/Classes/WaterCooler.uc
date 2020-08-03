//=============================================================================
// WaterCooler.
//=============================================================================
class WaterCooler extends DeusExDecoration;

var bool bUsing;
var int numUses;
var localized String msgEmpty;

event Timer()
{
    bUsing = False;
    AmbientSound = None;
}

function Frob(Actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    if (bUsing)
        return;

    if (numUses <= 0)
    {
        if (Pawn(Frobber) != None)
            Pawn(Frobber).ClientMessage(msgEmpty);
        return;
    }

    SetTimer(2.0, False);
    bUsing = True;

    // heal the frobber a small bit
    if (DeusExPlayer(Frobber) != None)
        DeusExPlayer(Frobber).HealPlayer(1);

    // DXR: Для случая когда используется новая модель.
    if (DrawType != DT_StaticMesh)
        PlayAnim('Bubble');
    AmbientSound = sound'WaterBubbling';
    numUses--;
}

event Destroyed()
{
    local Vector HitLocation, HitNormal, EndTrace;
    local Actor hit;
    local WaterPool pool;

    // trace down about 20 feet if we're not in water
    if (!PhysicsVolume.bWaterVolume)
    {
        EndTrace = Location - vect(0,0,320);
        hit = Trace(HitLocation, HitNormal, EndTrace, Location, False);
        pool = spawn(class'WaterPool',,, HitLocation+HitNormal, Rotator(-HitNormal));
        if (pool != None)
            pool.maxDrawScale = CollisionRadius / 20.0;
    }

    Super.Destroyed();
}


defaultproperties
{
     numUses=10
     msgEmpty="It's out of water"
     FragType=Class'DeusEx.PlasticFragment'
     bCanBeBase=True
     ItemName="Water Cooler"
     bPushable=False
//     mesh=mesh'DeusExDeco.WaterCooler'

     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_WaterCoolers.WaterCooler_b'
     CollisionRadius=14.070000
     CollisionHeight=41.570000
     Mass=70.000000
     Buoyancy=100.000000
}
