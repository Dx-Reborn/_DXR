//=============================================================================
// GuntherHermann.
//=============================================================================
class GuntherHermann extends HumanMilitary;

//
// Damage type table for Gunther Hermann:
//
// Shot			- 100%
// Sabot		- 100%
// Exploded		- 100%
// TearGas		- 10%
// PoisonGas	- 10%
// Poison		- 10%
// HalonGas		- 10%
// Radiation	- 10%
// Shocked		- 10%
// Stunned		- 0%
// KnockedOut   - 0%
// Flamed		- 0%
// Burned		- 0%
// NanoVirus	- 0%
// EMP			- 0%
//

function float ShieldDamage(class<DamageType> damageType)
{
	// handle special damage types
	if ((damageType == class'DM_Flamed') || (damageType == class'DM_Burned') || (damageType ==class'DM_Stunned') || (damageType == class'DM_KnockedOut'))
		return 0.0;
	else if ((damageType == class'DM_TearGas') || (damageType == class'DM_PoisonGas') || (damageType == class'DM_HalonGas') ||
			     (damageType == class'DM_Radiation') || (damageType == class'DM_Shocked') || (damageType == class'DM_Poison') || (damageType == class'DM_PoisonEffect'))
		return 0.1;
	else
		return Super.ShieldDamage(damageType);
}

// ----------------------------------------------------------------------
// SpawnCarcass()
//
// Blow up instead of spawning a carcass
// ----------------------------------------------------------------------
function Carcass SpawnCarcass()
{
	if (bStunned)
		return Super.SpawnCarcass();

	Explode();

	return None;
}

function Explode()
{
	local SphereEffect sphere;
	local ScorchMark s;
	local ExplosionLight light;
	local int i;
	local float explosionDamage;
	local float explosionRadius;
	local vector loc;
    local FleshFragment chunk;

	explosionDamage = 110;
	explosionRadius = 320;

	// alert NPCs that I'm exploding
	class'EventManager'.static.AISendEvent(self, 'LoudNoise', EAITYPE_Audio, , explosionRadius*16);
	PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, Location);
	if (light != None)
		light.size = 4;

	Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
	Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);


	sphere = Spawn(class'SphereEffect',,, Location);
	if (sphere != None)
		sphere.size = explosionRadius / 32.0;

	// spawn a mark
	s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation-rot(16384,0,0));
	if (s != None)
	{
		s.SetDrawScale(drawScale * FClamp(explosionDamage/28, 0.1, 3.0)); //*=
		//s.ReattachDecal();
	}

	//CyberP: messy gore
	for (i=0; i<22; i++)
	{
				loc.X = (1-2*FRand()) * CollisionRadius;
				loc.Y = (1-2*FRand()) * CollisionRadius;
				loc.Z = (1-2*FRand()) * CollisionHeight;
				loc += Location;
				spawn(class'BloodDropFlying');
				chunk = spawn(class'FleshFragment', None,, loc);

        if (chunk != None)
				{
          chunk.Velocity.Z = FRand() * 410 + 410;
				 	chunk.bFixedRotationDir = False;
					chunk.RotationRate = RotRand();
				}
  }
	HurtRadius(explosionDamage, explosionRadius, class'DM_Exploded', explosionDamage*100, Location);

	if (PawnShadow != none)
	    PawnShadow.Destroy(); // Destroy the shadow projector, otherwise bad things will happen.
}


defaultproperties
{
     HealthHead=600
     HealthTorso=400
     HealthLegLeft=400
     HealthLegRight=400
     HealthArmLeft=400
     HealthArmRight=400
     BindName="GuntherHermann"
     FamiliarName="Gunther Hermann"
     UnfamiliarName="Gunther Hermann"
     CarcassType=Class'DeusEx.GuntherHermannCarcass'
     WalkingSpeed=0.350000
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     InitialInventory(3)=(Inventory=Class'DeusEx.WeaponFlamethrower')
     InitialInventory(4)=(Inventory=Class'DeusEx.AmmoNapalm',Count=2)
     BurnPeriod=0.000000
     walkAnimMult=0.750000
     GroundSpeed=210.000000
     BaseEyeHeight=44.000000
     Health=400
     Mesh=mesh'DeusExCharacters.GM_DressShirt_B'
     DrawScale=1.100000
     skins(0)=Texture'DeusExCharacters.Skins.GuntherHermannTex1'
     skins(1)=Texture'DeusExCharacters.Skins.PantsTex9'
     skins(2)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     skins(3)=Texture'DeusExCharacters.Skins.GuntherHermannTex0'
     skins(4)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(5)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(6)=Texture'DeusExItems.Skins.BlackMaskTex'
     skins(7)=Texture'DeusExItems.Skins.BlackMaskTex'
     CollisionRadius=24.200001
     CollisionHeight=51.16
//     CollisionHeight=55.660000
     ControllerClass=class'GuntherHermannController'
}
