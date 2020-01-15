class RocketEMP extends Rocket;

function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
    local ExplosionLight light;
    local EM_EM_Explosion emp;
    local vector hitLoc2;

    // draw a pretty explosion
    light = Spawn(class'ExplosionLight',,, HitLocation);
    if (light != None)
    {
        light.size = 8;
        light.LightHue = 128;
        light.LightSaturation = 96;
        light.LightEffect = LE_Shell;
    }

    hitLoc2 = HitLocation;
    hitloc2.Z += 100; // Поднять.
    emp = Spawn(class'EM_EM_Explosion',,, hitloc2);
    emp.LifeSpan = 1.5f;
}

defaultproperties
{
     bBlood=False
     bDebris=False
     blastRadius=512.000000
     DamageType=class'DM_EMP'
     ItemName="EMP Rocket"
     ImpactSound=Sound'DeusExSounds.Weapons.EMPGrenadeExplode'
     AmbientSound=Sound'DeusExSounds.Weapons.WPApproach'
     Mesh=Mesh'DeusExItems.RocketHE'
     DrawScale=1.000000
}
