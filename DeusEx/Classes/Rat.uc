//=============================================================================
// Rat.
//=============================================================================
class Rat extends Animal;

var float myTime;

function bool ShouldBeStartled(Pawn startler)
{
    local float speed;
    local float time;
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


event Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    myTime += deltaTime;

    // check for random noises
    if (myTime > 1.0)
    {
        myTime = 0;
        if (FRand() < 0.05)
            PlaySound(sound'RatSqueak2', SLOT_None);
    }
}

defaultproperties
{
     bFleeBigPawns=True
     HealthHead=5
     HealthTorso=5
     HealthLegLeft=5
     HealthLegRight=5
     HealthArmLeft=5
     HealthArmRight=5
     Alliance=Rat
     BindName="Rat"
     FamiliarName="Rat"
     UnfamiliarName="Rat"
     Restlessness=0.900000
     Wanderlust=0.200000
     MinHealth=2.000000
     CarcassType=Class'DeusEx.RatCarcass'
     WalkingPct=0.360000
     GroundSpeed=250.000000
     WaterSpeed=24.000000
     AirSpeed=150.000000
     AccelRate=500.000000
     JumpZ=0.000000
     MaxiStepHeight=8.000000
     BaseEyeHeight=1.000000
     Health=5
     UnderWaterTime=20.000000
//     bCrawler=true
     HitSound1=Sound'DeusExSounds.Animal.RatSqueak1'
     HitSound2=Sound'DeusExSounds.Animal.RatSqueak3'
     die=Sound'DeusExSounds.Animal.RatDie'
     Mesh=mesh'DeusExCharacters.Rat'
     CollisionRadius=16.000000
     CollisionHeight=1.75

     CrouchRadius=16.000000
     CrouchHeight=1.75

//     CollisionHeight=3.500000
     bBlockActors=False
     Mass=2.000000
     Buoyancy=2.000000
     RotationRate=(Yaw=65530)
     ControllerClass=class'RatController'
     bAmbientCreature=true
}
