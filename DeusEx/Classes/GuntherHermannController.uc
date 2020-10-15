/*

*/

class GuntherHermannController extends DXRAiController;

function GotoDisabledState(class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
    if (!pawn.bCollideActors && !pawn.bBlockActors && !pawn.bBlockPlayers)
        return;
    if (GuntherHermann(pawn).CanShowPain())
        GuntherHermann(pawn).TakeHit(hitPos);
    else
        GotoNextState();
}

