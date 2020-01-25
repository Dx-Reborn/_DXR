//=============================================================================
// RocketWP.
//=============================================================================
class RocketWP extends Rocket;

#exec OBJ LOAD FILE=Effects

function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
	local ExplosionLight light;
	local EM_WPExplosion gen;

	// draw a pretty explosion
	light = Spawn(class'ExplosionLight',,, HitLocation);
	if (light != None)
		light.size = 12;
		Spawn(class'ExplosionSmall',,, HitLocation);

	// create a particle generator shooting out white-hot fireballs
	gen = Spawn(class'EM_WPExplosion',,, HitLocation, Rotator(HitNormal));
	if (gen != None)
	{
		gen.LifeSpan = 7.0;
	}
}


defaultproperties
{
     bBlood=False
     bDebris=False
     blastRadius=512.000000
     DamageType=class'DM_Flamed'
     ItemName="WP Rocket"
     ImpactSound=Sound'DeusExSounds.Generic.SmallExplosion2'
     AmbientSound=Sound'DeusExSounds.Weapons.WPApproach'
     Mesh=Mesh'DeusExItems.RocketHE'
     DrawScale=1.000000
}
