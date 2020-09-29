/*
   Plasma rifle projectile
*/

class PlasmaBolt extends DeusExProjectile;

#exec OBJ LOAD FILE=Effects.utx

var EM_PlasmaBoltTrail pGen1;
var EM_PlasmaBoltTrailA pGen2;
var DynamicCoronaLight dcl;

event Destroyed()
{
    if (pGen1 != None)
        pGen1.Kill();

    if (pGen2 != None)
        pGen2.Kill();
    // DXR: Destroy the coronalight as well.
    if (dcl != None)
        dcl.Destroy();

    Super.Destroyed();
}

function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
    local EM_PlasmaBoltImpact gen;

    // create a particle generator shooting out plasma spheres
    gen = Spawn(class'EM_PlasmaBoltImpact',,, HitLocation, Rotator(HitNormal));
/*    if (gen != None)
    {
        gen.LifeSpan = 2.0;
    }*/
}

auto state Flying
{
    event BeginState()
    {
        Super.BeginState();
        SetTimer(0.1, false); // DXR: Delay effects spawning a little bit.
    }

    event Timer()
    {
        SpawnCoolEffects();
    }
}

//event PostBeginPlay()
function SpawnCoolEffects()
{
    local Rotator rot;
//    Super.PostBeginPlay();

    rot = Rotation;
    rot.Yaw -= 32768;

    if (pGen1 == None)
        pGen1 = Spawn(class'EM_PlasmaBoltTrail',Self,,Location,rot);
    if (pGen1 != None)
    {
        pGen1.SetPhysics(PHYS_Trailer);
    }

    if (pGen2 == None)
        pGen2 = Spawn(class'EM_PlasmaBoltTrailA',Self,,Location,rot);
    if (pGen2 != None)
    {
        pGen2.SetPhysics(PHYS_Trailer);
    }

    // DXR: New coronalight effect!
    if (dcl == None)
        dcl = Spawn(class'DynamicCoronaLight',Self,,Location,rot);
    if (dcl != None)
    {
        // Setup corona light...
        dcl.SetPhysics(PHYS_Trailer);
        dcl.Skins[0] = Texture'Effects.Corona.Corona_A';
        dcl.MinCoronaSize = 1;
        dcl.MaxCoronaSize = 80;
        dcl.LightHue = 85;
        dcl.LightSaturation = 84;
        dcl.LightBrightness = 0;
        dcl.LightRadius = 250;
        dcl.bDirectionalCorona = false;
        dcl.CoronaRotation = 3;
    }
}


defaultproperties
{
     bExplodes=True
     blastRadius=128.000000
     DamageType=class'DM_Burned'
     AccurateRange=14400
     MaxRange=24000
     bIgnoresNanoDefense=True
     ItemName="Plasma Bolt"
     speed=1500.000000
     MaxSpeed=1500.000000
     Damage=40.000000
     MomentumTransfer=5000
     ImpactSound=Sound'DeusExSounds.Weapons.PlasmaRifleHit'
     ExplosionDecal=class'DeusEx.ScorchMark'
     Mesh=Mesh'DeusExItems.PlasmaBolt'
     DrawScale=3.000000
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=200
     LightHue=80
     LightSaturation=128
     LightRadius=3
     bFixedRotationDir=True
}
