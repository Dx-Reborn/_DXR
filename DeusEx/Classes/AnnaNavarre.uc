//=============================================================================
// AnnaNavarre.
//=============================================================================
class AnnaNavarre extends HumanMilitary;


function Bool HasTwoHandedWeapon()
{
    return False;
}

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
    local vector loc;
    local FleshFragment chunk;

    explosionDamage = 110;
    explosionRadius = 288;

    // alert NPCs that I'm exploding
    class'eventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, , explosionRadius*16);
    PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

    // draw a pretty explosion
    light = Spawn(class'ExplosionLight',,, Location);
    if (light != None)
        light.size = 4;

    Spawn(class'ExplosionSmall',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);
    Spawn(class'ExplosionMedium',,, Location + 2*VRand()*CollisionRadius);


    sphere = Spawn(class'SphereEffect',,, Location);
    if (sphere != None)
        sphere.size = explosionRadius / 32.0;

    // spawn a mark
    s = spawn(class'ScorchMark', Base,, Location-vect(0,0,1)*CollisionHeight, Rotation-rot(16384,0,0)); //+
    if (s != None)
        s.SetDrawScale(drawScale * FClamp(explosionDamage/28, 0.1, 3.0)); //*= // DXR: This is pointless...

        for (i=0; i<22; i++) //CyberP: was /1.2
        {
            loc.X = (1-2*FRand()) * CollisionRadius;
            loc.Y = (1-2*FRand()) * CollisionRadius;
            loc.Z = (1-2*FRand()) * CollisionHeight;
            loc += Location;
            spawn(class'BloodDropFlying');
            chunk = spawn(class'FleshFragment', None,, loc);
              if (chunk != None)
              {
                  chunk.Velocity.Z = FRand() * 410 + 410;
                  chunk.bFixedRotationDir = False;
                  chunk.RotationRate = RotRand();
              }
       }
       HurtRadius(explosionDamage, explosionRadius, class'DM_Exploded', explosionDamage*100, Location);
}


function float ModifyDamage(int Damage, Pawn instigatedBy, vector hitLocation, vector offset, class<DamageType> damageType, vector Momentum)
{
    if ((damageType == class'DM_Stunned') || (damageType == class'DM_KnockedOut') || (damageType == class'DM_Poison') || (damageType == class'DM_PoisonEffect'))
        return 0;
    else
        return Super.ModifyDamage(Damage, instigatedBy, hitLocation, offset, damageType, Momentum);
}


defaultproperties
{
     HealthHead=400
     HealthTorso=300
     HealthLegLeft=300
     HealthLegRight=300
     HealthArmLeft=300
     HealthArmRight=300
     BindName="AnnaNavarre"
     FamiliarName="Anna Navarre"
     UnfamiliarName="Anna Navarre"
     CarcassType=Class'DeusEx.AnnaNavarreCarcass'
     WalkingPct=0.280000
     bImportant=True
     bInvincible=True
     CloseCombatMult=0.500000
     BaseAssHeight=-18.000000
     InitialInventory(0)=(Inventory=Class'DeusEx.WeaponAssaultGun')
     InitialInventory(1)=(Inventory=Class'DeusEx.Ammo762mm',Count=12)
     InitialInventory(2)=(Inventory=Class'DeusEx.WeaponCombatKnife')
     BurnPeriod=5.000000
     bHasCloak=True
     CloakThreshold=100
     walkAnimMult=1.000000
     bIsFemale=True
     GroundSpeed=220.000000
     BaseEyeHeight=38.000000
     Health=300
     Mesh=mesh'DeusExCharacters.GFM_TShirtPants'
     DrawScale=1.100000
     skins(0)=Texture'DeusExCharacters.Skins.AnnaNavarreTex0'
     skins(1)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(2)=Texture'DeusExItems.Skins.PinkMaskTex'
     skins(3)=Texture'DeusExItems.Skins.GrayMaskTex'
     skins(4)=Texture'DeusExItems.Skins.BlackMaskTex'
     skins(5)=Texture'DeusExCharacters.Skins.AnnaNavarreTex0'
     skins(6)=Texture'DeusExCharacters.Skins.PantsTex9'
     skins(7)=Texture'DeusExCharacters.Skins.AnnaNavarreTex1'
     //CollisionHeight=47.299999
     CollisionHeight=42.799999
     CollisionRadius=22.0

     LampBone=37
}
