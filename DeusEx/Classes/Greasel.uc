//=============================================================================
// Greasel.
//=============================================================================
class Greasel extends Animal;

















// sound functions

defaultproperties
{
     bPlayDying=True
     FoodClass=Class'DeusEx.DeusExCarcass'
     FoodDamage=5
     FoodHealth=2
     bMessyEater=True
     bCanGlide=False
     Alliance=Greasel
     BindName="Greasel"
     FamiliarName="Greasel"
     UnfamiliarName="Greasel"
     MinHealth=20.000000
		 CarcassType=Class'DeusEx.GreaselCarcass'
     WalkingSpeed=0.080000
     bCanBleed=True
     ShadowScale=1.000000
     InitialAlliances(0)=(AllianceName=Karkian,AllianceLevel=1.000000,bPermanent=True)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponGreaselSpit')
     InitialInventory(1)=(Inventory=Class'DeusEx.AmmoGreaselSpit',Count=9999)
     WalkSound=Sound'DeusExSounds.Animal.GreaselFootstep'
     bSpawnBubbles=False
     bCanSwim=True
     GroundSpeed=350.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=12.500000
     Health=100
     UnderWaterTime=99999.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Animal.GreaselPainSmall'
     HitSound2=Sound'DeusExSounds.Animal.GreaselPainLarge'
     die=Sound'DeusExSounds.Animal.GreaselDeath'
     Mesh=mesh'DeusExCharacters.Greasel'
     //CollisionHeight=17.879999
     CollisionHeight=13.37
     Mass=40.000000
     Buoyancy=40.000000
}
