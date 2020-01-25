class AnnaNavarreController extends DXRAiController;

function GotoDisabledState(class<damageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
    if (!pawn.bCollideActors && !pawn.bBlockActors && !pawn.bBlockPlayers)
        return;
    if (ScriptedPawn(pawn).CanShowPain())
        ScriptedPawn(pawn).TakeHit(hitPos);
    else
        GotoNextState();
}