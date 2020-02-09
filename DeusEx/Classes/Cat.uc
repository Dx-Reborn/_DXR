//=============================================================================
// Cat.
//=============================================================================
class Cat extends Animal;

var float time;

function bool ShouldBeStartled(Pawn startler)
{
    local float speed;
//  local float time;
    local float dist;
    local float dist2;
    local bool  bPh33r;

    bPh33r = false;
    if (startler != None)
    {
        speed = VSize(startler.Velocity);
        if (speed >= 20)
        {
            dist = VSize(Location - startler.Location);
            time = dist/speed;
            if (time <= 3.0)
            {
                dist2 = VSize(Location - (startler.Location+startler.Velocity*time));
                if (dist2 < speed*1.5)
                    bPh33r = true;
            }
        }
    }
    return bPh33r;
}


function Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    time += deltaTime;

    // check for random noises
    if (time > 1.0)
    {
        time = 0;
        if (FRand() < 0.05)
            PlaySound(sound'CatPurr', SLOT_None,,, 128);
    }
}


defaultproperties
{
     ControllerClass=class'CatController'
     bPlayDying=True
     bFleeBigPawns=True
     Alliance=Cat
     BindName="Cat"
     FamiliarName="Cat"
     UnfamiliarName="Cat"
     MinHealth=0.000000
     CarcassType=Class'DeusEx.CatCarcass'
     WalkingSpeed=0.111111
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponCatScratch')
     GroundSpeed=180.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     MaxiStepHeight=14.000000
     BaseEyeHeight=6.000000
     Health=30
     UnderWaterTime=20.000000
     bCrawler=true
     HitSound1=Sound'DeusExSounds.Animal.CatHiss'
     HitSound2=Sound'DeusExSounds.Animal.CatHiss'
     die=Sound'DeusExSounds.Animal.CatDie'
     Mesh=mesh'DeusExCharacters.Cat'
     CollisionRadius=17.000000
     CollisionHeight=6.8
     //CollisionHeight=11.300000
     //bBlockActors=False
     bBlockActors=True
     Mass=10.000000
     Buoyancy=97.000000
     RotationRate=(Yaw=100000)
     bAmbientCreature=true
}
