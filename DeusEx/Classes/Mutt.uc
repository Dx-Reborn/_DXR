//=============================================================================
// Mutt.
//=============================================================================
class Mutt extends Dog;

function PlayDogBark()
{
    if (FRand() < 0.5)
        PlaySound(sound'DogSmallBark2', SLOT_None);
    else
        PlaySound(sound'DogSmallBark3', SLOT_None);
}

defaultproperties
{
     BindName="Mutt"
     FamiliarName="Dog"
     UnfamiliarName="Dog"
     CarcassType=Class'DeusEx.MuttCarcass'
     WalkingPct=0.200000
     GroundSpeed=250.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     UnderWaterTime=20.000000
     HitSound1=Sound'DeusExSounds.Animal.DogSmallGrowl'
     HitSound2=Sound'DeusExSounds.Animal.DogSmallBark1'
     die=Sound'DeusExSounds.Animal.DogSmallDie'
     Mesh=mesh'DeusExCharacters.Mutt'
//     CollisionRadius=38.000000
     CollisionRadius=34.000000 // DXR: 38 is too large, 34 is fine
     CollisionHeight=26.000000
     Mass=20.000000
}
