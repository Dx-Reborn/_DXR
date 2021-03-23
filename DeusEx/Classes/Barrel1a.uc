/*
  Barrel1.
 
  ToDo (DXR): Вместо одной многофункциональной бочки задействовать разные классы (унаследованные от BarrelMultiBase).
  На мой взгляд это проще и понятнее.
*/

class Barrel1a extends Barrels;

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
var material ColorSkins[10];
var() bool bPreDamage;
var bool bLeaking;
var float radTimer;
var bool bGenCreated; // Только один генератор частиц на одну бочку. Иначе он корректно не уничтожается.

event PostSetInitialState()
{
    if (bPreDamage)
        TakeDamage(1, None, Location, vect(0,0,0), class'DM_shot');

}

// DXR: Overriden to use custom "landed" sound.
event Landed(vector HitNormal)
{
    local Rotator rot;
    local sound hitSound;

    // make it lay flat on the ground
    bFixedRotationDir = False;
    rot = Rotation;
    rot.Pitch = 0;
    rot.Roll = 0;
    SetRotation(rot);

    // play a sound effect if it's falling fast enough
    if (Velocity.Z <= -200)
    {
        if (fragType == class'WoodFragment')
        {
            if (Mass <= 20)
                hitSound = sound'WoodHit1';
            else
                hitSound = sound'WoodHit2';
        }
        else if (fragType == class'MetalFragment')
        {
            if (Mass <= 20)
                hitSound = sound'MetalHit1';
            else
                hitSound = sound'STALKER_Sounds.Hit.barrel_2';
        }

        if ((hitSound != None) && (Level.TimeSeconds > 2)) //DXR: Не воспроизводить звук падения сразу после загрузки.
            PlaySound(hitSound, SLOT_None);

        // alert NPCs that I've landed
        class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio);
    }

    bWasCarried = false;
    bBobbing    = false;

        if ((bExplosive && (VSize(Velocity) > 425)) || (!bExplosive && (Velocity.Z < -500)))
            TakeDamage((1-Velocity.Z/30), Instigator, Location, vect(0,0,0), class'fell');
}

function SetDefaultSkin(material material)
{
   Skins[0] = material;
}

function ResetScaleGlow()
{
   SetSkin();
}

function SetStuff()
{
    switch (SkinColor)
    {
        case SC_Biohazard:          
           HitPoints = 12;
                    break;

        case SC_Explosive:          
        bExplosive = True;
    explosionDamage = 400;
   explosionRadius = 1000;
            HitPoints = 4;
                    break;

  case SC_FlammableLiquid:    
        bExplosive = True;
            HitPoints = 8;
                    break;

   case SC_FlammableSolid:     
        bExplosive = True;
    explosionDamage = 200;
            HitPoints = 8;
                    break;

           case SC_Poison:             
           HitPoints = 12;
                    break;

      case SC_RadioActive:        
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

              case SC_Wood:               
   FragType = Class'DeusEx.WoodFragment'; //CyberP
                     break;

    }
}

function SetSkin()
{
    switch (SkinColor)
    {
        case SC_Biohazard:          SetDefaultSkin(ColorSkins[0]);
                                    break;

        case SC_Blue:               SetDefaultSkin(ColorSkins[1]); 
                                    break;

        case SC_Brown:              SetDefaultSkin(ColorSkins[2]); 
                                    break;

        case SC_Rusty:              SetDefaultSkin(ColorSkins[3]);
                                    break;

        case SC_Explosive:          SetDefaultSkin(ColorSkins[4]);
                                    break;

        case SC_FlammableLiquid:    SetDefaultSkin(ColorSkins[5]);
                                    break;

        case SC_FlammableSolid:     SetDefaultSkin(ColorSkins[6]);
                                    break;

        case SC_Poison:             SetDefaultSkin(ColorSkins[7]);
                                    break;

        case SC_RadioActive:        SetDefaultSkin(ColorSkins[8]);
                                    break;

        case SC_Wood:               SetDefaultSkin(Texture'Barrel1Tex10');
                                    break;

        case SC_Yellow:             SetDefaultSkin(ColorSkins[9]);
                                    break;
    }
}

event BeginPlay()
{
    Super.BeginPlay();
    SetSkin();
    SetStuff();
}

auto state Active
{
    event Tick(float deltaTime)
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

            if (HitPoints - Damage <= 0)
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
   bBlockSight=true
//    mesh=mesh'DeusExDeco.Barrel1'
   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DeusExStaticMeshes0.Barrel1a_HD'

   CollisionRadius=20.00
   CollisionHeight=29.00

   Mass=80.00
   Buoyancy=90.00

   ColorSkins[0]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex1'
   ColorSkins[1]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex2'
   ColorSkins[2]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex3'
   ColorSkins[3]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex4'
   ColorSkins[4]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex5'
   ColorSkins[5]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex6'
   ColorSkins[6]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex7'
   ColorSkins[7]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex8'
   ColorSkins[8]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex9'
   ColorSkins[9]=texture'DeusExStaticMeshes0.Metal.Barrel1a_HD_Tex11'
}

