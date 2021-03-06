//=============================================================================
// LAM.
//=============================================================================
class LAM extends ThrownProjectile;

function sound GetExplosionSound()
{
    local DeusExGlobals gl;
    local sound sound;

    gl = class'DeusExGlobals'.static.GetGlobals();
    if (gl.bUseAltWeaponsSounds)
    {
        sound = class'DXRWeaponSoundManager'.static.GetLAMGrenadeExplosion(gl.WS_Preset);
        if (sound != None)
        return sound;
        else
        return Super.GetExplosionSound();
    }
    else return Super.GetExplosionSound();
}

event Tick(float deltaTime)
{
    local float blinkRate;

    Super.Tick(deltaTime);

    if (bDisabled)
    {
        Skins[0] = Texture'BlackMaskTex';
        return;
    }

    // flash faster as the time expires
    if (fuseLength - time <= 0.75)
        blinkRate = 0.1;
    else if (fuseLength - time <= fuseLength * 0.5)
        blinkRate = 0.3;
    else
        blinkRate = 0.5;

   if ((Level.NetMode == NM_Standalone) || (Role < ROLE_Authority) || (Level.NetMode == NM_ListenServer))
   {
      if (Abs((fuseLength - time)) % blinkRate > blinkRate * 0.5)
         Skins[0] = Texture'BlackMaskTex';
      else
         Skins[0] = Texture'LAM3rdtex1';
   }
}


defaultproperties
{
     Skins[0]=Shader'DeusExItemsEx.ExSkins.Unlit_Red'
     Skins[1]=Texture'DeusExItems.Skins.LAM3rdTex1'

     fuseLength=3.000000
     proxRadius=128.000000
     blastRadius=384.000000
     spawnWeaponClass=Class'DeusEx.WeaponLAM'
     ItemName="Lightweight Attack Munition (LAM)"
     speed=1000.000000
     MaxSpeed=1000.000000
     Damage=500.000000
     MomentumTransfer=50000
     ImpactSound=Sound'DeusExSounds.Weapons.LAMExplode'
     ExplosionDecal=Class'DeusEx.ScorchMark'
     LifeSpan=0.000000
     Mesh=Mesh'DeusExItems.LAMPickup'
     CollisionRadius=4.300000
     CollisionHeight=3.800000
     Mass=5.000000
     Buoyancy=2.000000
}
