//=============================================================================
// CrateBreakableMedGeneral.
//=============================================================================
class CrateBreakableMedGeneral extends Containers;

// From HardCoreDX mod...
auto state Active
{
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
    {
        if ((damageType == class'DM_Shot') || (damageType == class'DM_Decapitated'))
        {
             if (FRand() > 0.75)
             PlaySound(sound'wood01gr', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
                else if (FRand() > 0.5)
             PlaySound(sound'wood02gr', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
                else if (FRand() > 0.25)
             PlaySound(sound'wood03gr', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
                else
             PlaySound(sound'wood04gr', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
        }
        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }
}

defaultproperties
{
     bBlockSight=True
     HitPoints=10
     FragType=Class'DeusEx.WoodFragment'
     ItemName="General Supply Crate"
     contents=Class'DeusEx.LockpickInv'
     skins[0]=Texture'DeusExDeco.Skins.CrateBreakableMedTex2'
     mesh=mesh'DeusExDeco.CrateBreakableMed'
     CollisionRadius=34.000000
     CollisionHeight=24.000000
     Mass=50.000000
     Buoyancy=60.000000
}
