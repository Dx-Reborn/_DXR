/*

*/
class DXRKActor extends KActor;

var(KActor) bool bAcceptBumpFromPawns;

event Bump(Actor Other)
{
    local Pawn hitpawn;

    if(bAcceptBumpFromPawns)
    {
        hitpawn = Pawn(Other);

        if(hitpawn != None)
           KAddImpulse(hitPawn.Velocity * 5, Location);
    }
}


event PostLoadSavedGame()
{
    if(!bStasis)
    {
        KWake();
        KAddImpulse(Velocity, Location);
    }
}
