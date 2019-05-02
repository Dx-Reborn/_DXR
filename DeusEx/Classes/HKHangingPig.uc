//=============================================================================
// HKHangingPig.
//=============================================================================
class HKHangingPig extends HangingDecoration;

function SpawnBlood(Vector HitLocation, float Damage)
{
	local int i;

	spawn(class'BloodSpurt',,,HitLocation);
	spawn(class'BloodDrop',,,HitLocation);
	for (i=0; i<int(Damage); i+=10)
		spawn(class'BloodDrop',,,HitLocation);
}

auto state Active
{
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation,Vector momentum, class<DamageType> damageType)
	{
		Super.TakeDamage(Damage, instigatedBy, HitLocation, Momentum, DamageType);
		if ((DamageType == class'DM_Shot') || (DamageType == class'DM_Exploded'))
			SpawnBlood(HitLocation, Damage);
	}
}


defaultproperties
{
     HitPoints=100
     FragType=Class'DeusEx.FleshFragment'
     ItemName="Slaughtered Pig"
     mesh=mesh'DeusExDeco.HKHangingPig'
//     PrePivot=(Z=47.000000)
     CollisionRadius=10.000000
     CollisionHeight=47.000000
     Mass=100.000000
     Buoyancy=5.000000
}
