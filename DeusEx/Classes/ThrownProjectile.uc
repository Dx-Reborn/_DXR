//=============================================================================
// ThrownProjectile.
//=============================================================================
class ThrownProjectile extends DeusExProjectile
    abstract;

var() float             Elasticity;
var() float             fuseLength;
var() class<DeusExFragment> FragmentClass;
var() bool              bProximityTriggered;
var() float             proxRadius;
var() bool              bArmed;
var bool                bFirstHit;
var float               proxCheckTime;
var float               beepTime;
var float               skillTime;
var float               skillAtSet;
var() bool              bDisabled;
var() bool              bHighlight;         // should this object not highlight when focused?
var() float             AISoundLevel;       // sound level at which to alert AI (0.0 to 1.0)
var() bool              bDamaged;         // was this blown up via damage?

var bool                bDoExplode;     // Used for communication into a simulated chain

function Tick(float deltaTime)
{
    local ScriptedPawn P;
    local DeusExPlayer Player;
    local Vector dist;
    local float blinkRate;//, mult;
    local float proxRelevance;

    Super.Tick(deltaTime);

    if (bDisabled)
        return;

    time += deltaTime;

    // check for proximity // „тобы не было спама если игрок погибает.
    if ((bProximityTriggered) && (GetPlayerPawn() != none))
    {                         // ^^
        if (bArmed)
        {
            proxCheckTime += deltaTime;

            // beep based on skill
            if (skillTime != 0)
            {
                if (time > fuseLength)
                {
                    if (skillTime % 0.3 > 0.25)
                        PlaySound(sound'Beep4',,,, 1280, 2.0);
                }
            }

            // if we have been triggered, count down based on skill
            if (skillTime > 0)
                skillTime -= deltaTime;

            // explode if time < 0
            if (skillTime < 0)
            {
                Explode(Location, Vector(Rotation));
                bArmed = False;
                return;
            }

            // DC - new ugly way of doing it - old way was "if (proxCheckTime > 0.25)"
            // new way: weight the check frequency based on distance from player
            proxRelevance = DistanceFromPlayer()/2000.0;  // at 500 units it behaves as it did before
            if (proxRelevance<0.25)
                proxRelevance=0.25;               // low bound 1/4
            else if (proxRelevance>10.0)
                proxRelevance=20.0;               // high bound 30
            else
                proxRelevance=proxRelevance*2;    // out past 1.0s, double the timing
            if (proxCheckTime>proxRelevance)
            {
                proxCheckTime = 0;

                // pre-placed explosives are only prox triggered by the player
                if (Owner == None)
                {
                    foreach RadiusActors(class'DeusExPlayer', Player, proxRadius*4)
                    {
                        // the owner won't set it off, either
                        if (Player != Owner)
                        {
                            dist = Player.Location - Location;
                            if (VSize(dist) < proxRadius)
                                if (skillTime == 0)
                                    skillTime = FClamp(-20.0 * Player.SkillSystem.GetSkillLevelValue(class'SkillDemolition'), 1.0, 10.0);
                        }
                    }
                }
                else
                {
                    foreach RadiusActors(class'ScriptedPawn', P, proxRadius*4)
                    {
                        // only "heavy" pawns will set this off
                        if ((P != None) && (P.Mass >= 40))
                        {
                            // the owner won't set it off, either
                            if (P != Owner)
                            {
                                dist = P.Location - Location;
                                if (VSize(dist) < proxRadius)
                                    if (skillTime == 0)
                                        skillTime = 1.0;
                            }
                        }
                    }
                }
            }
        }
    }

    // beep faster as the time expires
    beepTime += deltaTime;

    if (fuseLength - time <= 0.75)
        blinkRate = 0.1;
    else if (fuseLength - time <= fuseLength * 0.5)
        blinkRate = 0.3;
    else
        blinkRate = 0.5;

    if (time < fuseLength)
    {
        if (beepTime > blinkRate)
        {
            beepTime = 0;
            PlaySound(sound'Beep4',,,, 1280);
        }
    }
}

function Frob(Actor Frobber, Inventory frobWith)
{
    // if the player frobs it and it's disabled, the player can grab it
    if (bDisabled)
    {
        Super.Frob(Frobber, frobWith);
    }
    else if (bProximityTriggered && bArmed && (skillTime >= 0))
    {
        // if the player frobs it and has the demolition skill, disarm the explosive
        PlaySound(sound'Beep4',,,, 1280, 0.5);
        bDisabled = True;
    }
}

function Timer()
{
    if (bProximityTriggered)
        bArmed = True;
    else
    {
        if (!bDisabled)
            Explode(Location, Vector(Rotation));
    }
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> damageType)
{
    local ParticleGenerator gen;

    if ((DamageType ==class'DM_TearGas') || (DamageType == class'DM_PoisonGas') || (DamageType == class'DM_Radiation'))
        return;

    if (DamageType == class'DM_NanoVirus')
        return;

    // EMP damage disables explosives
    if (DamageType == class'DM_EMP')
    {
        if (!bDisabled)
        {
            PlaySound(sound'EMPZap', SLOT_None,,, 1280);
            bDisabled = True;

            // smoke a bit
            gen = Spawn(class'ParticleGenerator', Self,, Location, rot(16384,0,0));
/*          if (gen != None)
            {
                gen.checkTime = 0.25;
                gen.LifeSpan = 2;
                gen.particleDrawScale = 0.3;
                gen.bRandomEject = True;
                gen.ejectSpeed = 10.0;
                gen.bGravity = False;
                gen.bParticlesUnlit = True;
                gen.frequency = 0.5;
                gen.riseRate = 10.0;
                gen.spawnSound = Sound'Spark2';
                gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
                gen.SetBase(Self);
            }*/
        }

        return;
    }

    Explode(Location, Vector(Rotation));
}

function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
    local int i;
    local SmokeTrail puff;
    local TearGas gas;
    local DeusExFragment frag;
    local ParticleGenerator gen;
//  local ProjectileGenerator projgen;
    local vector loc;
    local rotator rot;
    local ExplosionLight light;
    local DeusExDecal mark;

    rot.Pitch = 16384 + FRand() * 16384 - 8192;
    rot.Yaw = FRand() * 65536;
    rot.Roll = 0;

    if ((damageType == class'DM_Exploded') && bStuck)
    {
        gen = spawn(class'ParticleGenerator',,, HitLocation, rot);
/*      if (gen != None)
        {
            gen.LifeSpan = FRand() * 10 + 10;
            gen.CheckTime = 0.25;
            gen.particleDrawScale = 0.4;
            gen.RiseRate = 20.0;
            gen.bRandomEject = True;
            gen.particleTexture = Texture'Effects.Smoke.SmokePuff1';
        }*/
    }

    // don't draw damage art on destroyed movers
    if (DeusExMover(Other) != None)
        if (DeusExMover(Other).bDestroyed)
            ExplosionDecal = None;

    if (ExplosionDecal != None)
    {
        mark = DeusExDecal(Spawn(ExplosionDecal, Self,, HitLocation, Rotator(-HitNormal)));
        if (mark != None)
        {
            mark.SetDrawScale(FClamp(damage/30, 0.1, 3.0));
//          mark.ReattachDecal();
        }
    }

    for (i=0; i<blastRadius/36; i++)
    {
        if (FRand() < 0.9)
        {
            if (bDebris && bStuck)
            {
                frag = spawn(FragmentClass,,, HitLocation);
                if (frag != None)
                    frag.CalcVelocity(VRand(), blastRadius);
            }

            loc = Location;
            loc.X += FRand() * blastRadius - blastRadius * 0.5;
            loc.Y += FRand() * blastRadius - blastRadius * 0.5;

            if (damageType == class'DM_Exploded')
            {
                puff = spawn(class'SmokeTrail',,, loc);
                if (puff != None)
                {
                    puff.RiseRate = FRand() + 1;
                    puff.SetDrawScale(FRand() + 3.0);
                    puff.OrigScale = puff.DrawScale;
                    puff.LifeSpan = FRand() * 10 + 10;
                    puff.OrigLifeSpan = puff.LifeSpan;
                }

                light = Spawn(class'ExplosionLight',,, HitLocation);
                if (FRand() < 0.5)
                {
                    spawn(class'ExplosionSmall',,, loc);
                    light.size = 2;
                }
                else
                {
                    spawn(class'ExplosionMedium',,, loc);
                    light.size = 4;
                }
            }
            else if (damageType == class'DM_TearGas')
            {
                loc.Z += 32;
                gas = spawn(class'TearGas', None,, loc);
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
            else if (damageType == class'DM_EMP')
            {
                light = Spawn(class'ExplosionLight',,, HitLocation);
                if (light != None)
                {
                    light.size = 6;
                    light.LightHue = 170;
                    light.LightSaturation = 64;
                }
            }
        }
    }
}

auto state Flying
{
    function Explode(vector HitLocation, vector HitNormal)
    {
//      local ShockRing ring;
        local DeusExPlayer player;
        local float dist;

        // flash the screen white based on how far away the explosion is
        player = DeusExPlayer(GetPlayerPawn());
        dist = Abs(VSize(player.Location - Location));

        // if you are at the same location, blind the player
        if (dist ~= 0)
            dist = 10.0;
        else
            dist = 2.0 * FClamp(blastRadius/dist, 0.0, 4.0);

        if (damageType == class'DM_EMP')
            DeusExPlayerController(Level.GetLocalPlayerController()).ClientFlash(dist, vect(0,200,1000));
        else if (damageType == class'DM_TearGas')
            DeusExPlayerController(Level.GetLocalPlayerController()).ClientFlash(dist, vect(0,1000,100));
        else
            DeusExPlayerController(Level.GetLocalPlayerController()).ClientFlash(dist, vect(1000,1000,900));

        SpawnEffects(HitLocation, HitNormal, None);
        DrawExplosionEffects(HitLocation, HitNormal);
        PlaySound(ImpactSound, SLOT_None, 2.0,, blastRadius*16);

        if (AISoundLevel > 0.0)
            class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, 2.0, AISoundLevel*blastRadius*16);

        GotoState('Exploding');
    }

    simulated function HitWall (vector HitNormal, actor HitWall)
    {
        local Rotator rot;
        local float   volume;

        Velocity = Elasticity*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
        speed = VSize(Velocity);    
        if (bFirstHit && speed<400) 
            bFirstHit=False;
        RotationRate = RotRand(True);
        if ( (speed < 60) && (HitNormal.Z > 0.7) )
        {
            volume = 0.5+FRand()*0.5;
            PlaySound(MiscSound, SLOT_None, volume,, 512, 0.85+FRand()*0.3);

            // I know this is a little cheesy, but certain grenade types should
            // not alert AIs unless they are really really close - CNN
            if (AISoundLevel > 0.0)
                class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, volume, AISoundLevel*256);
            class'ActorManager'.static.SetPhysicsEx(self, PHYS_None, HitWall);
            if (Physics == PHYS_None)
            {
                rot = Rotator(HitNormal);
                rot.Yaw = Rand(65536);
                SetRotation(rot);
                bBounce = False;
                bStuck = True;
            }
        }
        else If (speed > 50) 
        {
            PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
        }
    }
}

simulated singular function PhysicsVolumeChange(PhysicsVolume Volume)
{
    local float splashsize;
    local actor splash;

    if (Volume.bWaterVolume)
    {
        Velocity = 0.2 * Velocity;
        splashSize = 0.0005 * (250 - 0.5 * Velocity.Z);
        if ( Level.NetMode != NM_DedicatedServer )
        {
            if ( Volume.EntrySound != None )
                PlaySound(Volume.EntrySound, SLOT_None, splashSize);
            if (Volume.EntryActor != None)
            {
                splash = Spawn(Volume.EntryActor); 
                if ( splash != None )
                    splash.SetDrawScale(4 * splashSize);
            }
        }
        if (bFirstHit) 
            bFirstHit=False;
        
        RotationRate = 0.2 * RotationRate;
    }
}

function BeginPlay()
{
    Super.BeginPlay();

    Velocity = Speed * Vector(Rotation);
    RotationRate = RotRand(True);
    SetTimer(fuseLength, False);
    SetCollision(True, True, True);

    // don't beep at the start of a level if we've been preplaced
    if (Owner == None)
    {
        time = fuseLength;
        bStuck = True;
    }
}

function Pawn GetPlayerPawn()
{
    return Level.GetLocalPlayerController().Pawn;
}


defaultproperties
{
     elasticity=0.500000
     fuseLength=5.000000
     FragmentClass=Class'DeusEx.Rockchip'
     proxRadius=64.000000
     bFirstHit=True
     bHighlight=True
     AISoundLevel=1.000000
     bExplodes=True
     bBlood=True
     bDebris=True
     blastRadius=512.000000
     DamageType=class'DM_exploded'
     ItemName="ERROR ThrownProjectile Default-Report as bug!"
     ImpactSound=Sound'DeusExSounds.Generic.LargeExplosion1'
     MiscSound=Sound'DeusExSounds.Generic.MetalBounce1'
     Physics=PHYS_Falling
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     bBounce=True
     bFixedRotationDir=True
}
