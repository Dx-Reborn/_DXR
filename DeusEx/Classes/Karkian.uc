//=============================================================================
// Karkian.
//=============================================================================
class Karkian extends Animal;

// fake a charge attack using bump
























// sound functions

defaultproperties
{
     bPlayDying=True
     FoodClass=Class'DeusEx.DeusExCarcass'
     bPauseWhenEating=True
     bMessyEater=True
     bFoodOverridesAttack=True
     bCanGlide=False
     Alliance=Karkian
     BindName="Karkian"
     FamiliarName="Karkian"
     UnfamiliarName="Karkian"
     MinHealth=50.000000
     CarcassType=Class'DeusEx.KarkianCarcass'
     WalkingSpeed=0.200000
     bCanBleed=True
     bShowPain=False
     ShadowScale=1.000000
     InitialAlliances(0)=(AllianceName=Greasel,AllianceLevel=1.000000,bPermanent=True)
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponKarkianBite')
     InitialInventory(1)=(Inventory=Class'DeusEx.WeaponKarkianBump')
     WalkSound=Sound'DeusExSounds.Animal.KarkianFootstep'
     bSpawnBubbles=False
     bCanSwim=True
     GroundSpeed=400.000000
     WaterSpeed=110.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     BaseEyeHeight=12.500000
     Health=400
     UnderWaterTime=99999.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     //  HitSound1=Sound'DeusExSounds.Animal.KarkianPainSmall'
     //  HitSound2=Sound'DeusExSounds.Animal.KarkianPainLarge'
     die=Sound'DeusExSounds.Animal.KarkianDeath'
     Mesh=mesh'DeusExCharacters.Karkian'
     CollisionRadius=54.000000
     CollisionHeight=37.099998
     Mass=500.000000
     Buoyancy=500.000000
     RotationRate=(Yaw=30000)
}
