//=============================================================================
// Barrel1.
// ScriptedBarrel (C)
//=============================================================================
class Barrel1 extends Containers;

#exec OBJ LOAD FILE=Ambient

enum ESkinColor
{
    SC_Biohazard,
    SC_Blue,
    SC_Brown,
    SC_Rusty,
    SC_Explosive,
    SC_FlammableLiquid,
    SC_FlammableSolid,
    SC_Poison,
    SC_RadioActive,
    SC_Wood,
    SC_Yellow
};

var() ESkinColor SkinColor;
var() bool bPreDamage;
var bool bLeaking;
var float radTimer;
var bool bGenCreated; // Только один генератор частиц на одну бочку. Иначе он корректно не уничтожается.

function SetInitialState()
{
        super.SetInitialState();

    if (bPreDamage)
        TakeDamage(1, None, Location, vect(0,0,0), class'DM_shot');

}

function SetDefaultSkin(material material)
{
    default.Skins[0] = material;
    Skins[0] = material;
}

function BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
        case SC_Biohazard:          SetDefaultSkin(Texture'Barrel1Tex1');
                                    HitPoints = 12;
                                    break;

        case SC_Blue:               SetDefaultSkin(Texture'Barrel1Tex2'); 
                                    break;

        case SC_Brown:              SetDefaultSkin(Texture'Barrel1Tex3'); 
                                    break;

        case SC_Rusty:              SetDefaultSkin(Texture'Barrel1Tex4');
                                    break;

        case SC_Explosive:          SetDefaultSkin(Texture'Barrel1Tex5');
                                    bExplosive = True;
                                    explosionDamage = 400;
                                    explosionRadius = 1000;
                                    HitPoints = 4;
                                    break;

        case SC_FlammableLiquid:    SetDefaultSkin(Texture'Barrel1Tex6');
                                    bExplosive = True;
                                    HitPoints = 8;
                                    break;

        case SC_FlammableSolid:     SetDefaultSkin(Texture'Barrel1Tex7');
                                    bExplosive = True;
                                    explosionDamage = 200;
                                    HitPoints = 8;
                                    break;

        case SC_Poison:             SetDefaultSkin(Texture'Barrel1Tex8');
                                    HitPoints = 12;
                                    break;

        case SC_RadioActive:        SetDefaultSkin(Texture'Barrel1Tex9');
                                    bInvincible = True;
                                    LightType = LT_Steady;
                                    LightRadius = 8;
                                    LightBrightness = 128;
                                    LightHue = 64;
                                    LightSaturation = 96;
                                    AmbientSound = sound'GeigerLoop';
                                    SoundRadius = 8;
                                    SoundVolume = 255;
                                    bUnlit = True;
                                    ScaleGlow = 0.4;
                                    break;

        case SC_Wood:               SetDefaultSkin(Texture'Barrel1Tex10');
                                    FragType = Class'DeusEx.WoodFragment'; //CyberP
                                    break;

        case SC_Yellow:             SetDefaultSkin(Texture'Barrel1Tex11');
                                    break;
    }
}

auto state Active
{
    function Tick(float deltaTime)
    {
        local Actor A;
        local Vector offset;

        Super.Tick(deltaTime);

        if (SkinColor == SC_RadioActive)
        {
            radTimer += deltaTime;

            if (radTimer > 1.0)
            {
                radTimer = 0;

                // check to see if anything has entered our effect radius
                foreach VisibleActors(class'Actor', A, 128.0)
                    if (A != None)
                    {
                        // be sure to damage the torso
                        offset = A.Location;
                        A.TakeDamage(5, None, offset, vect(0,0,0), class'DM_Radiation');
                    }
            }
        }
    }

    function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
    {
        local EM_BarrelSpray gen;
        local ProjectileGenerator projgen;
        local float size;
        local Vector loc;
        local Actor A;
        local EM_SteamRegular puff;
        local PoisonGas gas;
        local int i;

        if (bStatic || bInvincible)
            return;

        if ((damageType == class'DM_TearGas') || (damageType == class'DM_PoisonGas') || (damageType == class'DM_HalonGas'))
            return;

        if ((damageType == class'DM_EMP') || (damageType == class'DM_NanoVirus') || (damageType == class'DM_Radiation'))
            return;

        if (Damage >= minDamageThreshold)
        {
            if (skincolor != sc_wood)
            {
             if (FRand() > 0.5)
             PlaySound(sound'barrel_2', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
                else
             PlaySound(sound'barrel_1', SLOT_None,,, 1024, 1.1 - 0.2*FRand());
            }
            if (skincolor == sc_wood)
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

            if (HitPoints-Damage <= 0)
            {
                foreach BasedActors(class'Actor', A)
                {
                    if (A.IsA('DeusExEmitter'))
                    {
                        DeusExEmitter(A).SetBase(none);
                        DeusExEmitter(A).Kill();
                    }
                    else if (A.IsA('ProjectileGenerator'))
                    {
                        ProjectileGenerator(A).SetBase(none);
                        ProjectileGenerator(A).Destroy();
                    }
                    else    if (A.IsA('Fire'))
                    {
                        Fire(A).SetBase(none);
                        Fire(A).Destroy();
                    }
                }

                // spread out a gas cloud
                for (i=0; i<explosionRadius/36; i++)
                {
                    loc = Location;
                    loc.X += FRand() * explosionRadius - explosionRadius * 0.5;
                    loc.Y += FRand() * explosionRadius - explosionRadius * 0.5;
        
                    if ((SkinColor == SC_Explosive) || (SkinColor == SC_FlammableLiquid) || (SkinColor == SC_FlammableSolid))
                    {
                        //puff = spawn(class'SmokeTrail',,, loc);
                        puff = Spawn(class'EM_SteamRegular', Self,, loc, rot(16384,0,0));
                        if (puff != None)
                        {
                            puff.Emitters[0].LifeTimeRange.Max =  RandRange(20, 40);
                            puff.Emitters[0].LifeTimeRange.Min = puff.Emitters[0].LifeTimeRange.Max;
                            puff.Emitters[0].RespawnDeadParticles=false;
                            puff.lifespan = puff.Emitters[0].LifeTimeRange.Max + 0.5;
                        }
                    }
                    else if ((SkinColor == SC_Biohazard) || (SkinColor == SC_Poison))
                    {
                        loc.Z += 32;
                        gas = spawn(class'PoisonGas', None,, loc);
                        if (gas != None)
                        {
                            gas.Velocity = vect(0,0,0);
                            gas.Acceleration = vect(0,0,0);
                            gas.SetDrawScale(FRand() * 0.5 + 2.0);
                            gas.LifeSpan = FRand() * 10 + 30;
                            gas.bFloating = True;
                            gas.Instigator = Instigator;
                        }
                    }
                }
            }

            if (!bLeaking)
            {
                // spawn a projectile generator for toxic gas leaks
                if (((SkinColor == SC_Biohazard) || (SkinColor == SC_Poison)) && (HitPoints-Damage > 0))
                {
                    size = CollisionRadius / 54.0;
                    size = FClamp(size, 0.1, 4.0);

                    loc.X = 0;
                    loc.Y = 0;
                    loc.Z = CollisionHeight + 32;
                    loc += Location;

                    projgen = Spawn(class'ProjectileGenerator', Self,, loc, rot(16384,0,0));
                    if (projgen != None)
                    {
                        bLeaking = True;
                        projgen.ProjectileClass = class'PoisonGas';
                        projgen.ProjectileLifeSpan = 3.0;
                        projgen.frequency = 0.9;
                        projgen.checkTime = 0.5;
                        projgen.ejectSpeed = 50.0;
                        projgen.bRandomEject = True;
                        projgen.SetBase(Self);
                    }

                    // play a hissing sound
                    if (AmbientSound == None)
                    {
                        AmbientSound = Sound'SteamVent2';
                        SoundRadius = 64 * size;
                        SoundVolume = 192;
                    }
                }

                // spawn a smoke generator if a flammable solid barrel is damaged
                if (((SkinColor == SC_Explosive) || (SkinColor == SC_FlammableLiquid) ||
                     (SkinColor == SC_FlammableSolid)) && (HitPoints-Damage > 0))
                {
                    size = CollisionRadius / 54.0;
                    size = FClamp(size, 0.1, 4.0);

                    loc.X = 0;
                    loc.Y = 0;
                    loc.Z = CollisionHeight + 8;
                    loc += Location;

                    log ("bGenCreated"@bGenCreated);

                    if (!bGenCreated)
                    {
                    gen = Spawn(class'EM_BarrelSpray', Self,, loc, rot(16384,0,0));
                    if (gen != None)
                        {
                            gen.Emitters[0].ColorScale[0].Color.R = 120 + rand(40);
                            gen.Emitters[0].ColorScale[0].Color.G = 128 + rand(40);
                            gen.Emitters[0].ColorScale[0].Color.B = 150 + rand(40);
                            gen.Emitters[0].Acceleration.Z=30 + rand(30);
                            gen.Emitters[0].Opacity=0.3;
                            gen.Emitters[0].StartVelocityRange.X.Min = -3;
                            gen.Emitters[0].StartVelocityRange.X.Max =  3;
                            gen.Emitters[0].StartVelocityRange.Y.Min = -3;
                            gen.Emitters[0].StartVelocityRange.Y.Max =  3;
                            gen.Emitters[0].GetVelocityDirectionFrom = PTVD_None;
                            bGenCreated=true;
                            gen.SetBase(self);
                
                        }
                    }

                    // play a hissing sound
                    if (AmbientSound == None)
                    {
                        AmbientSound = Sound'SteamVent2';
                        SoundRadius = 64 * size;
                        SoundVolume = 192;
                    }
                }
            }
        }

        Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
    }
}

defaultproperties
{
    SkinColor=SC_Brown
    HitPoints=30
    ItemName="Barrel"
    bBlockSight=True
    mesh=mesh'DeusExDeco.Barrel1'
    CollisionRadius=20.00
    CollisionHeight=29.00
    Mass=80.00
    Buoyancy=90.00
}