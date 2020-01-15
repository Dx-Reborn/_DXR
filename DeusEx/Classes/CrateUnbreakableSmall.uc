//=============================================================================
// CrateUnbreakableSmall.
//=============================================================================
class CrateUnbreakableSmall extends Containers;

// From HardCoreDX mod...
auto state Active
{
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
    {
        if ( (damageType == class'DM_Shot') || (damageType == class'DM_Decapitated') )
            PlaySound(sound'BulletImpactMetal2', SLOT_None,,, 1024, 1.1 - 0.2*FRand());

        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }
}

defaultproperties
{
     bBlockSight=True
     bInvincible=True
     bFlammable=False
     ItemName="Metal Crate"
     mesh=mesh'DeusExDeco.CrateUnbreakableSmall'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     Mass=40.000000
     Buoyancy=50.000000
     Skins[0]=Texture'DeusExDeco.Skins.CrateUnbreakableSmallTex1'
}
