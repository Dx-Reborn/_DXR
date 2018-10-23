//=============================================================================
// CrateUnbreakableLarge.
//=============================================================================
class CrateUnbreakableLarge extends Containers;

auto state Active
{
	function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
	{
		if ( (damageType == class'DM_Shot') || (damageType == class'DM_Decapitated') )
			PlaySound(sound'BulletImpactMetal2', SLOT_None,,, 1024, 1.1 - 0.2*FRand());

		Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
	}
}


defaultproperties
{
     bBlockSight=True
     bInvincible=True
     bFlammable=False
     ItemName="Metal Crate"
     mesh=mesh'DeusExDeco.CrateUnbreakableLarge'
     CollisionRadius=56.500000
     CollisionHeight=56.000000
     Mass=150.000000
     Buoyancy=160.000000
}
