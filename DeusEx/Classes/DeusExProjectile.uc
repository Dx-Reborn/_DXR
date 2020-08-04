//=============================================================================
// DeusExProjectile.
//=============================================================================
class DeusExProjectile extends Projectile
    abstract
    placeable;

#exec OBJ LOAD FILE=Effects_EX

var bool bExplodes;             // does this projectile explode?
var bool bBlood;                // does this projectile cause blood?
var bool bDebris;               // does this projectile cause debris?
var bool bStickToWall;          // does this projectile stick to walls?
var bool bStuck;                // is this projectile stuck to the wall?
var vector initDir;             // initial direction of travel
var float blastRadius;          // radius to explode
var Actor damagee;              // who is being damaged
var class<DamageType> damageType;// type of damage that this projectile does
var int AccurateRange;          // maximum accurate range in world units (feet * 16)
var int MaxRange;               // maximum range in world units (feet * 16)
var vector initLoc;             // initial location for range tracking
var bool bTracking;             // should this projectile track a target?
var Actor Target;               // what target we are tracking
var float time;                 // misc. timer
var float MinDrawScale;
var float MaxDrawScale;

var int gradualHurtSteps;       // how many separate explosions for the staggered HurtRadius
var int gradualHurtCounter;     // which one are we currently doing

var class<DeusExWeapon>  spawnWeaponClass;  // weapon to give the player if this projectile is disarmed and frobbed
var class<Ammunition>    spawnAmmoClass;  // ammo to give the player if this projectile is disarmed and frobbed

var bool bEmitDanger;
var bool bIgnoresNanoDefense; //True if the aggressive defense aug does not blow this up.
var bool bAggressiveExploded; //True if exploded by Aggressive Defense 
var bool bUseExplosionEffects; // Добавлять эффекты взрыва или нет?
var bool bAddRings;

var localized string itemName;      // human readable name
var localized string itemArticle;    // article much like those for weapons

var sound MiscSound;

function sound GetExplosionSound()
{
    return default.ImpactSound;
}

event PostBeginPlay()
{
    Super.PostBeginPlay();
    if (bEmitDanger)
        class'EventManager'.static.AIStartEvent(self,'Projectile', EAITYPE_Visual);
}

//
// Let the player pick up stuck projectiles
//
function Frob(Actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    // if the player frobs it and it's stuck, the player can grab it
    if (bStuck)
        GrabProjectile(DeusExPlayer(Frobber));
}

function GrabProjectile(DeusExPlayer player)
{
    local Inventory item;

    if (player != None)
    {
        if (spawnWeaponClass != None)       // spawn the weapon
        {
            item = Spawn(spawnWeaponClass);

            if (item != None)
                DeusExWeapon(item).PickupAmmoCount = 1;
        }
        else if (spawnAmmoClass != None)    // or spawn the ammo
        {
            item = Spawn(spawnAmmoClass);

            if (item != None)
            {
                Ammunition(item).AmmoAmount = 1;
                //log("amount = "$Ammunition(item).AmmoAmount);
            }
        }

        if (item != None)
        {
            player.FrobTarget = item;

            // check to see if we can pick up the new weapon/ammo
            if (player.HandleItemPickup(item))
                Destroy();              // destroy the projectile on the wall
            else
                item.Destroy();         // destroy the weapon/ammo if it can't be picked up

            player.FrobTarget = None;
        }
    }
  log(self $ " -- GrabProjectile() ="@item);
}

//
// update our flight path based on our ranges and tracking info
//
event Tick(float deltaTime)
{
    local float dist, size;
    local Rotator dir;
    local vector vel;

    if (bStuck)
        return;

    Super.Tick(deltaTime);

    if (bTracking && (Target != None))
    {
        // check it's range
        dist = Abs(VSize(Target.Location - Location));
        if (dist > MaxRange)
        {
            // if we're out of range, lose the lock and quit tracking
            bTracking = False;
            Target = None;
            return;
        }
        else
        {
            // get the direction to the target
            dir = Rotator(Target.Location - Location);
            dir.Roll = 0;

            // set our new rotation
            bRotateToDesired = True;
            DesiredRotation = dir;

            // move us in the new direction that we are facing
            size = VSize(Velocity);
            vel = Normal(Vector(Rotation));
            Velocity = vel * size;
        }
    }

    dist = Abs(VSize(initLoc - Location));

    if (dist > AccurateRange)       // start descent due to "gravity"
        Acceleration = PhysicsVolume.Gravity / 2;

    // make the rotation match the velocity direction
    if (!bTracking)
        SetRotation(Rotator(Velocity));
}

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
    local int i;

    spawn(class'BloodSpurt',,,HitLocation+HitNormal);
    for (i=0; i<Damage/7; i++)
        if (FRand() < 0.5)
            spawn(class'BloodDrop',,,HitLocation+HitNormal*4);
}

function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
    local int i;
    local DeusExDecal mark;

    // don't draw damage art on destroyed movers
    if (DeusExMover(Other) != None)
        if (DeusExMover(Other).bDestroyed)
            ExplosionDecal = None;

    // draw the explosion decal here, not in Engine.Projectile
    if (ExplosionDecal != None)
    {
        mark = DeusExDecal(Spawn(ExplosionDecal, Self,, HitLocation, Rotator(-HitNormal)));
//      Spawn(ExplosionDecal, Self,, HitLocation, Rotator(-HitNormal));
//                  Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
        if (mark != None)
        {
        //  mark.SetDrawScale(FClamp(damage/30, 0.5, 3.0));
            mark.SetDrawScale(FClamp(damage*10, 2.5, 5.0));
        }

    //  ExplosionDecal = None;
    }

    if (bDebris)
    {
        for (i=0; i<Damage/5; i++)
            if (FRand() < 0.8)
                spawn(class'Rockchip',,,HitLocation+HitNormal);
    }
}

function DrawExplosionEffects(vector HitLocation, vector HitNormal)
{
    local ShockRing ring;
    local ExplosionLight light;
    local EM_UWExplosion waterExplosion;

    if (bUseExplosionEffects)
    {
      // draw a pretty explosion
      light = Spawn(class'ExplosionLight',,, HitLocation);
      // DXR: Added if exploded under water.
      if (PhysicsVolume.bWaterVolume)
      {
         waterExplosion = Spawn(class'EM_UWExplosion',,, HitLocation);
         light.size = 4;
      }

      if (blastRadius < 128)
      {
          Spawn(class'ExplosionSmall',,, HitLocation);
          light.size = 2;
      }
      else if (blastRadius < 256)
      {
          Spawn(class'ExplosionMedium',,, HitLocation);
          light.size = 4;
      }
      else
      {
          Spawn(class'ExplosionLarge',,, HitLocation);
          light.size = 8;
      }

        if (bAddRings) // draw a pretty shock ring
        {
           ring = Spawn(class'ShockRing',,, HitLocation, rot(16384,0,0));
           if (ring != None)
               ring.size = blastRadius / 32.0;

           ring = Spawn(class'ShockRing',,, HitLocation, rot(0,0,0));
           if (ring != None)
               ring.size = blastRadius / 32.0;

           ring = Spawn(class'ShockRing',,, HitLocation, rot(0,16384,0));
           if (ring != None)
               ring.size = blastRadius / 32.0;
      }
    }
}

//
// Exploding state
//
state Exploding
{
    ignores ProcessTouch, HitWall, Explode;

    event Timer()
    {
        HurtRadius
        (
            (2 * Damage) / gradualHurtSteps,
            (blastRadius / gradualHurtSteps) * gradualHurtCounter,
            damageType,
            MomentumTransfer / gradualHurtSteps,
            Location
        );
        if (++gradualHurtCounter >= gradualHurtSteps)
            Destroy();
    }

Begin:
    // stagger the HurtRadius outward using Timer()
    // do five separate blast rings increasing in size
    gradualHurtCounter = 1;
    gradualHurtSteps = 5;
    Velocity = vect(0,0,0);
    bHidden = True;
    LightType = LT_None;
    SetCollision(False, False, False);
    SetTimer(0.5/float(gradualHurtSteps), True);
}

auto state Flying
{
    function ProcessTouch (Actor Other, Vector HitLocation)
    {
        if (bStuck)
            return;

        if ((Other != instigator) && (DeusExProjectile(Other) == None) &&
            (Other != Owner))
        {
            damagee = Other;
            Explode(HitLocation, Normal(HitLocation-damagee.Location));
            if (damagee.IsA('Pawn') && !damagee.IsA('Robot') && bBlood)
                SpawnBlood(HitLocation, Normal(HitLocation-damagee.Location));
        }
    }

    function HitWall(vector HitNormal, actor Wall)
    {
        if (bStickToWall)
        {
            Velocity = vect(0,0,0);
            Acceleration = vect(0,0,0);
            SetPhysics(PHYS_None);
            bStuck = True;
            if (Wall.IsA('Mover'))
            {
                SetBase(Wall);
                Wall.TakeDamage(Damage, Pawn(Owner), Wall.Location, MomentumTransfer*Normal(Velocity), damageType);
            }
        }

        if (Wall.IsA('BreakableGlass'))
            bDebris = False;

        SpawnEffects(Location, HitNormal, Wall);

        Super.HitWall(HitNormal, Wall);
    }

    function Explode(vector HitLocation, vector HitNormal)
    {
        local bool bDestroy;
        local float rad;

        bDestroy = false;

        if (bExplodes)
        {
            DrawExplosionEffects(HitLocation, HitNormal);
            GotoState('Exploding');
        }
        else
        {
            if (damagee != None)
                damagee.TakeDamage(Damage, Pawn(Owner), HitLocation, MomentumTransfer*Normal(Velocity), damageType);

            if (!bStuck)
                bDestroy = true;
        }

        rad = Max(blastRadius*24, 1024);
        PlaySound(/*ImpactSound*/GetExplosionSound(), SLOT_None, 2.0,, rad);
        if (/*ImpactSound*/GetExplosionSound() != None)
        {
            class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, 2.0, blastRadius*24);
            if (bExplodes)
                class'EventManager'.static.AISendEvent(self,'WeaponFire', EAITYPE_Audio, 2.0, blastRadius*5);
        }

        if (bDestroy)
            Destroy();
    }

    function BeginState()
    {

        initLoc = Location;
        initDir = vector(Rotation); 

        Velocity = speed*initDir;

        PlaySound(SpawnSound, SLOT_None);
    }
}

defaultproperties
{
     AccurateRange=800
     MaxRange=1600
     MinDrawScale=0.050000
     maxDrawScale=2.500000
     bEmitDanger=True
     ItemName="DEFAULT PROJECTILE NAME - REPORT THIS AS A BUG"
     ItemArticle="Error"
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=60.000000
     bUseExplosionEffects=true
     bAddRings=false
//     RotationRate=(Pitch=65536,Yaw=65536)
}
