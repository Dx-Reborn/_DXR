//=============================================================================
// Tree.
//=============================================================================
class Tree extends OutdoorThings
    abstract;

var() float soundFreq;      // chance of making a sound every 5 seconds

event Timer()
{
    if (FRand() < soundFreq)
    {
        // play wind sounds at random pitch offsets
        if (FRand() < 0.5)
            PlaySound(sound'WindGust1', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
        else if (FRand() < 0.3)
            PlaySound(sound'WindGust2', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
        else
            PlaySound(sound'rnd_wind_tree', SLOT_Misc,,, 2048, 0.7 + 0.6 * FRand());
    }
}

event PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(4.0 + 2.0 * FRand(), True);
}

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
                else if (FRand() > 0.15)
             PlaySound(sound'wood04gr', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
                else 
            PlaySound(sound'tree01gr', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
        }

        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }
}


defaultproperties
{
     soundFreq=0.200000
     bStatic=False
     Mass=2000.000000
     Buoyancy=5.000000
     bShadowCast=true
}
