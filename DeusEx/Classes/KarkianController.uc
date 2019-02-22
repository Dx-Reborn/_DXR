/*

*/
class KarkianController extends AnimalController;


function GotoDisabledState(class<DamageType> damageType, ScriptedPawn.EHitLocation hitPos)
{
	if (!pawn.bCollideActors && !pawn.bBlockActors && !pawn.bBlockPlayers)
		return;
	else if ((damageType == class'DM_TearGas') || (damageType == class'DM_HalonGas'))
		GotoNextState();
	else if (damageType == class'DM_Stunned')
		GotoNextState();
	else if (Karkian(pawn).CanShowPain())
		Karkian(pawn).TakeHit(hitPos);
	else
		GotoNextState();
}
