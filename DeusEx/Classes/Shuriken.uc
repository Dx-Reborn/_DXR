//=============================================================================
// Shuriken.
//=============================================================================
class Shuriken extends DeusExProjectile;

// set it's rotation correctly
function Tick(float deltaTime)
{
	local Rotator rot;

	if (bStuck)
		return;

	Super.Tick(deltaTime);	

	rot = Rotation;
	rot.Roll += 16384;
	rot.Pitch -= 16384;
	SetRotation(rot);
}


defaultproperties
{
     bBlood=True
     bStickToWall=True
     DamageType=class'DM_shot'
     AccurateRange=640
     MaxRange=1280
     spawnWeaponClass=Class'DeusEx.WeaponShurikenInv'
     bIgnoresNanoDefense=True
     ItemName="Throwing Knife"
     speed=750.000000
     MaxSpeed=750.000000
     Damage=15.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     Mesh=Mesh'DeusExItems.ShurikenPickup'
     CollisionRadius=5.000000
     CollisionHeight=0.300000
}
