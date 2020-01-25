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

//
// special Gunther killswitch animation state
//

state KillswitchActivated
{
	function BeginState()
	{
		GuntherHermann(pawn).StandUp();
		GuntherHermann(pawn).LastPainTime = Level.TimeSeconds;
		GuntherHermann(pawn).LastPainAnim = GetAnimSequence();
		GuntherHermann(pawn).bInterruptState = false;
		GuntherHermann(pawn).BlockReactions();
		GuntherHermann(pawn).bCanConverse = False;
		GuntherHermann(pawn).bStasis = false;
		GuntherHermann(pawn).SetDistress(true);
		GuntherHermann(pawn).TakeHitTimer = 2.0;
		GuntherHermann(pawn).EnemyReadiness = 1.0;
		GuntherHermann(pawn).ReactionLevel  = 1.0;
		GuntherHermann(pawn).bInTransientState = true;
	}

Begin:
	FinishAnim();
	pawn.PlayAnim('HitTorso', 2.0, 0.1);
	FinishAnim();
	pawn.PlayAnim('HitHead', 2.0, 0.1);
	FinishAnim();
	pawn.PlayAnim('HitTorsoBack', 2.0, 0.1);
	FinishAnim();
	pawn.PlayAnim('HitHeadBack', 2.0, 0.1);
	FinishAnim();
	pawn.PlayAnim('HitHead', 3.0, 0.1);
	FinishAnim();
	pawn.PlayAnim('HitHeadBack', 3.0, 0.1);
	FinishAnim();
	pawn.PlayAnim('HitHead', 5.0, 0.1);
	FinishAnim();
	pawn.PlayAnim('HitHeadBack', 5.0, 0.1);
	FinishAnim();
	GuntherHermann(pawn).Explode();
	GuntherHermann(pawn).Destroy();
	Destroy();
}
