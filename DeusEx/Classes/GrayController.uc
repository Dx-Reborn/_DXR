/*

*/

class GrayController extends AnimalController;

function GotoDisabledState(class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
	if (!pawn.bCollideActors && !pawn.bBlockActors && !pawn.bBlockPlayers)
		return;
	else if (damageType == class'DM_Stunned')
		GotoNextState();
	else if (gray(pawn).CanShowPain())
		gray(pawn).TakeHit(hitPos);
	else
		GotoNextState();
}
