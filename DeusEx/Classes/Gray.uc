//=============================================================================
// Gray.
//=============================================================================
class Gray extends Animal;

#exec OBJ LOAD FILE=Ambient

var float damageRadius;
var float damageInterval;
var float damageAmount;
var float damageTime;

// check every damageInterval seconds and damage any player near the gray
function Tick(float deltaTime)
{
	local DeusExPlayer player;

	damageTime += deltaTime;

	if (damageTime >= damageInterval)
	{
		damageTime = 0;
		foreach VisibleActors(class'DeusExPlayer', player, damageRadius)
			if (player != None)
				player.TakeDamage(damageAmount, Self, player.Location, vect(0,0,0), class'DM_Radiation');
	}

	Super.Tick(deltaTime);
}














// sound functions

defaultproperties
{
     DamageRadius=256.000000
     damageInterval=1.000000
     DamageAmount=10.000000
     bPlayDying=True
     Alliance=Gray
     BindName="Gray"
     FamiliarName="Gray"
     UnfamiliarName="Gray"
     MinHealth=10.000000
     CarcassType=Class'DeusEx.GrayCarcass'
     WalkingSpeed=0.280000
     bCanBleed=True
     CloseCombatMult=0.500000
     ShadowScale=0.750000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponGraySwipe')
     InitialInventory(1)=(Inventory=Class'DeusEx.WeaponGraySpit')
     InitialInventory(2)=(Inventory=Class'DeusEx.AmmoGraySpit',Count=9999)
     WalkSound=Sound'DeusExSounds.Animal.GrayFootstep'
     GroundSpeed=350.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=25.000000
     Health=50
     // ReducedDamageType=Radiation
     // ReducedDamagePct=1.000000
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     //  HitSound1=Sound'DeusExSounds.Animal.GrayPainSmall'
     //  HitSound2=Sound'DeusExSounds.Animal.GrayPainLarge'
     die=Sound'DeusExSounds.Animal.GrayDeath'
     AmbientSound=Sound'Ambient.Ambient.GeigerLoop'
     Mesh=mesh'DeusExCharacters.Gray'
     AmbientGlow=12
     SoundRadius=14
     SoundVolume=255
     CollisionRadius=28.540001
     CollisionHeight=36.000000
     LightType=LT_Steady
     LightBrightness=32
     LightHue=96
     LightSaturation=128
     LightRadius=5
     Mass=120.000000
     Buoyancy=97.000000
}
