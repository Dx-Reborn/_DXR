/*

*/

class GreaselController extends AnimalController;

function GotoDisabledState(class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
	if (!pawn.bCollideActors && !pawn.bBlockActors && !pawn.bBlockPlayers)
		return;
	else if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas'))
		GotoNextState();
	else if (damageType == class'DM_Stunned')
		GotoNextState();
	else if (Greasel(pawn).CanShowPain())
		Greasel(pawn).TakeHit(hitPos);
	else
		GotoNextState();
}
