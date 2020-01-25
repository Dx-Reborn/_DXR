//=============================================================================
// AttackHelicopter.
//=============================================================================

class AttackHelicopter extends Vehicles;

auto state Flying
{
	function BeginState()
	{
		Super.BeginState();
		LoopAnim('Fly');
	}
}

singular function SupportActor(Actor standingActor)
{
	// kill whatever lands on the blades
	if (standingActor != None)
		standingActor.TakeDamage(10000, None, standingActor.Location, vect(0,0,0), class'DM_Exploded');
}


defaultproperties
{
			Skins(0)=Texture'DeusExDeco.Skins.AttackHelicopterTex1'
			Skins(1)=Shader'DeusExStaticMeshes.Skins.HelicopterBladesSH'
			Skins(2)=TexEnvMap'DeusExStaticMeshes.Glass.EM1'
     ItemName="Attack Helicopter"
     AmbientSound=Sound'Ambient.Ambient.Helicopter'
     mesh=mesh'DeusExDeco.AttackHelicopter'
     SoundRadius=160
     SoundVolume=192
     CollisionRadius=461.230011
     CollisionHeight=87.839996
     Mass=6000.000000
     Buoyancy=1000.000000
}
