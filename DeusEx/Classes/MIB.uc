//=============================================================================
// MIB.
//=============================================================================
class MIB extends HumanMilitary;

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

    explosionDamage = 100;
    explosionRadius = 256;

    // alert NPCs that I'm exploding
    class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, , explosionRadius*16);
    PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

    // draw a pretty explosion
    light = Spawn(class'ExplosionLight',,, Location);
    if (light != None)
        light.size = 4;

    Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionLarge',,, Location + 2*VRand()*CollisionRadius);

    sphere = Spawn(class'SphereEffect',,, Location);
    if (sphere != None)
        sphere.size = explosionRadius / 32.0;

    // spawn a mark
    s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation+rot(16384,0,0));
    if (s != None)
    {
        s.SetDrawScale(FClamp(explosionDamage/30, 0.1, 3.0));
//      s.ReattachDecal();
    }

    // spawn some rocks and flesh fragments
    for (i=0; i<explosionDamage/6; i++)
    {
        if (FRand() < 0.3)
            spawn(class'Rockchip',,,Location);
        else
            spawn(class'FleshFragment',,,Location);
    }

    HurtRadius(explosionDamage, explosionRadius, class'DM_Exploded', explosionDamage*100, Location);
}


defaultproperties
{
     HealthHead=350
     HealthTorso=350
     HealthLegLeft=350
     HealthLegRight=350
     HealthArmLeft=350
     HealthArmRight=350
     BindName="MiB"
     FamiliarName="Man In Black"
     UnfamiliarName="Man In Black"
     MinHealth=0.000000
     CarcassType=Class'DeusEx.MIBCarcass'
     WalkingPct=0.213333
     CloseCombatMult=0.500000
     GroundSpeed=180.000000
     Health=350
     Mesh=mesh'DeusExCharacters.GM_Suit'
     DrawScale=1.100000
     skins(0)=Texture'DeusExCharacters.Skins.MIBTex0'
     skins(1)=Texture'DeusExCharacters.Skins.PantsTex5'
     skins(2)=Texture'DeusExCharacters.Skins.MIBTex0'
     skins(3)=Texture'DeusExCharacters.Skins.MIBTex1'
     skins(4)=Texture'DeusExCharacters.Skins.MIBTex1'
     skins(5)=Material'DeusExCharacters.Skins.SH_FramesTex2'
     skins(6)=Material'DeusExCharacters.Skins.FB_LensesTex3'
     skins(7)=Texture'DeusExItems.Skins.PinkMaskTex'
//     CollisionHeight=52.250000
     CollisionHeight=47.750000
     CollisionRadius=22.0
}
