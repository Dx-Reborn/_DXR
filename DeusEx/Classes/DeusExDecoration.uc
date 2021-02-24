//=============================================================================
// DeusExDecoration.
//=============================================================================
class DeusExDecoration extends DeusExDecorationBase;

#exec obj load file=DXR_PoolTable_Set.usx
#exec obj load file=DeusExDeco.ukx
#exec OBJ LOAD FILE=Effects
#exec OBJ LOAD FILE=Effects_EX // шейдеры
#exec OBJ LOAD FILE=DeusExSounds
#exec obj load file=DeusExStaticMeshes.usx
#exec obj load file=DeusExStaticMeshes0.usx
#exec obj load file=DeusExDeco_EX.utx // двухсторонние шейдеры


var(Decoration) class<inventory> content2;
var(Decoration) class<inventory> content3;
var int AmountOfFire;

// Conversation Related Variables - DEUS_EX AJY
var(Conversation) String BindName;                  // Used to bind conversations
var(Conversation) String BarkBindName;              // Used to bind Barks!
var(Conversation) localized String FamiliarName;    // For display in Conversations
var(Conversation) localized String UnfamiliarName;  // For display in Conversations
var travel   float       LastConEndTime;            // Time when last conversation ended
var(Conversation) float  ConStartInterval;          // Amount of time required between two convos.
var(Conversation) editconst transient array<ConDialogue> conlist; // Диалоги хранятся здесь.


// DEUS_EX AMSD Added to make vision aug run faster.  If true, the vision aug needs to check this object more closely.
// Used for heat sources as well as things that blind.
var bool    bVisionImportant;
var bool    bOnlyTriggerable;
var float   BaseEyeHeight;

// for destroying them
var() travel int HitPoints;
var() int minDamageThreshold;
var() bool bInvincible;

// information for floating/bobbing decorations
var() bool bFloating;
var rotator origRot;
var bool bBobbing;
var bool bWasCarried;

// lets us attach a decoration to a mover
var() name moverTag;

// object properties
var() bool bFlammable;              // can this object catch on fire?
var() float Flammability;           // how long does the object burn?
var() bool bExplosive;              // does this object explode when destroyed?
var() int explosionDamage;          // how much damage does the explosion cause?
var() float explosionRadius;        // how big is the explosion?
var() bool bHighlight;              // should this object not highlight when focused?
var() bool bCanBeBase;              // can an actor stand on this decoration?
var() bool bGenerateFlies;          // does this actor generate flies?
var bool bCanBePushedByDamage;      // for cart (and maybe some other decos?)
var sound pushSoundId;              // used to stop playing the push sound

var int gradualHurtSteps;           // how many separate explosions for the staggered HurtRadius
var int gradualHurtCounter;         // which one are we currently doing


var FlyGenerator flyGen;            // fly generator

var() localized string itemName;      // human readable name
var() finalBlend HoldTexture;         // вариант "в руках"

/*
   DXR: A note about shadows for decoratons. These shadows are true FPS devourers, 
   so by default they are disabled. You can enable them manually for every individual case
   by setting bActorShadows to true. You can disable all shadows and projectors at any time
   in Game Settings menu. 
   Use ShadowDirection to set direction of the shadow (sounds obviously :D)
*/
var transient ShadowProjectorStatic Shadow; // Transient for safety. When savegame is loaded, shadow must be recreated .
var(DynamicShadow) vector ShadowDirection;
var(DynamicShadow) float ShadowLightDistance;
var(DynamicShadow) float ShadowMaxTraceDistance;

var name NextState;                 // for queueing states
var name NextLabel;                 // for queueing states

// Сдвинуть при нанесении урона
function DamageForce(int Damage);

function AddShadow()
{
    if (!bActorShadows)
        return;
    Shadow = Spawn(class'ShadowProjectorStatic',Self,'',Location);

    if (Shadow != none)
    {
        Shadow.bLevelStatic = true;
        Shadow.ShadowActor = self;
        Shadow.LightDirection = Normal(ShadowDirection);
        Shadow.LightDistance = ShadowLightDistance;
        Shadow.MaxTraceDistance = ShadowMaxTraceDistance;
        Shadow.CullDistance = 1200;
        Shadow.InitShadow();
    }
}

// Создать прозрачный материал из нулевого (обычно skins[0]).
function FinalBlend CreateHoldMaterial()
{
   HoldTexture = FinalBlend(Level.ObjectPool.AllocateObject(class'FinalBlend'));
   if (HoldTexture != none)
   {
      HoldTexture.Material = GetMeshTexture(0);
      HoldTexture.FrameBufferBlending = FB_Brighten;
      HoldTexture.ZWrite = false; //true;
      HoldTexture.ZTest = true;
      HoldTexture.AlphaTest = true;
      HoldTexture.TwoSided = false;

      return HoldTexture;
   }
}


// ----------------------------------------------------------------------
// Frob()
//
// If we are frobbed, trigger our event
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
    local Actor A;
    local Pawn P;
    local DeusExPlayer Player;

    P = Pawn(Frobber);
    Player = DeusExPlayer(Frobber);

    Super.Frob(Frobber, frobWith);

    // First check to see if there's a conversation associated with this 
    // decoration.  If so, trigger the conversation instead of triggering
    // the event for this decoration
    if (Player != None)
    {
        if (player.StartConversation(Self, IM_Frob))
            return;
    }

    // Trigger event if we aren't hackable
    if (!IsA('HackableDevices'))
        if (Event != '')
            foreach AllActors(class 'Actor', A, Event)
                A.Trigger(Self, P);
}

// if (abs(Location.Z-Other.Location.Z) < (CollisionHeight+Other.CollisionHeight-1)) // Проверить что объект не находится снизу или сверху
// Log(Self@"StandingCount"@count);
function int StandingCount()
{
    local int count;
    local actor a;

    foreach BasedActors(class'Actor', A)
    count++;
    return count;
}

// ----------------------------------------------------------------------
// PreBeginPlay()
// ----------------------------------------------------------------------
function PreBeginPlay()
{
    AddShadow();

    Super.PreBeginPlay();

    if (bGenerateFlies && (FRand() < 0.1))
        flyGen = Spawn(Class'FlyGenerator', , , Location, Rotation);
    else
        flyGen = None;

    RemoteRole = default.RemoteRole;
    Role = default.Role;
}



// ----------------------------------------------------------------------
// PostPostBeginPlay()
// ----------------------------------------------------------------------
event SetInitialState()
{
    super.SetInitialState();
    ConBindEvents();
}

// ----------------------------------------------------------------------
// BeginPlay()
//
// if we are already floating, then set our ref points
// ----------------------------------------------------------------------
event BeginPlay()
{
    local Mover M;
    local EmptyClass Stub; // DXR: Заглушка для того чтобы удерживаемая декорация не жила своей жизнью.

    Super.BeginPlay();

    if (bFloating)
        origRot = Rotation;

    // attach us to the mover that was tagged
    if (moverTag != '')
        foreach AllActors(class'Mover', M, moverTag)
        {
            SetBase(M);
            SetPhysics(PHYS_None);
            bInvincible = True;
            bCollideWorld = False;
        }

    if (fragType == class'GlassFragment')
        pushSound = sound'PushPlastic';
    else if (fragType == class'MetalFragment')
        pushSound = sound'PushMetal';
    else if (fragType == class'PaperFragment')
        pushSound = sound'PushPlastic';
    else if (fragType == class'PlasticFragment')
        pushSound = sound'PushPlastic';
    else if (fragType == class'WoodFragment')
        pushSound = sound'PushWood';
    else if (fragType == class'Rockchip')
        pushSound = sound'PushPlastic';

    if (stub==none)
    {
        Stub = Spawn(class'EmptyClass', Self,, Location,);
        Stub.SetBase(self);
    }
}

// ----------------------------------------------------------------------
// Landed()
// 
// Called when we hit the ground
// ----------------------------------------------------------------------
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
                hitSound = sound'MetalHit2';
        }
        else if (fragType == class'PlasticFragment')
        {
            if (Mass <= 20)
                hitSound = sound'PlasticHit1';
            else
                hitSound = sound'PlasticHit2';
        }
        else if (fragType == class'GlassFragment')
        {
            if (Mass <= 20)
                hitSound = sound'GlassHit1';
            else
                hitSound = sound'GlassHit2';
        }
        else    // paper sound
        {
            if (Mass <= 20)
                hitSound = sound'PaperHit1';
            else
                hitSound = sound'PaperHit2';
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

singular function SupportActor(Actor standingActor)
{
    local vector newVelocity;
    local float  angle;
    local float  zVelocity;
    local float  baseMass;
    local float  standingMass;

//    standingActor.SetBase(self);

    /* Исправлена жуткая ошибка: турели отваливались от основания и проваливались сквозь уровень ((( 
     возможно нужно будет добавить еще исключения */
  if ((standingActor.IsA('EmptyClass')) || 
     (standingActor.IsA('AutoTurretGun')) || (standingActor.IsA('AutoTurretGunSmall')) ||
     (standingActor.IsA('AutoTurret')) || (standingActor.IsA('AutoTurretSmall')) || (standingActor.IsA('Emitter')) ||
     (standingActor.IsA('xEmitter')) || (standingActor.IsA('Light')) || (standingActor.IsA('ScaledSprite')) || // Добавлены исключения для ходовых огней.
     (standingActor.GetStateName() == 'Sitting'));
  return;                   

    zVelocity = standingActor.Velocity.Z;
    // We've been stomped!
    if (zVelocity < -500)
    {
        standingMass = FMax(1, standingActor.Mass);
        baseMass     = FMax(1, Mass);
        TakeDamage((1 - standingMass/baseMass * zVelocity/30),
                   standingActor.Instigator, standingActor.Location, 0.2*standingActor.Velocity, class'DM_stomped');
    }

    if (!bCanBeBase)
    {
        angle = FRand()*Pi*2;
        newVelocity.X = cos(angle);
        newVelocity.Y = sin(angle);
        newVelocity.Z = 0;
        newVelocity *= FRand()*25 + 25;
        newVelocity += standingActor.Velocity;
        newVelocity.Z = 50;
        standingActor.Velocity = newVelocity;
        standingActor.SetPhysics(PHYS_Falling);
    }
    else
        standingActor.SetBase(self);
}


// ----------------------------------------------------------------------
// ResetScaleGlow()
//
// Reset the ScaleGlow to the default
// Decorations modify ScaleGlow using damage
// DXR: Restore default skins too.
// ----------------------------------------------------------------------
function ResetScaleGlow()
{
   local int i;

   for (i=0;i<Skins.Length;i++)
     Skins[i]=default.skins[i];

//    if (!bInvincible)
//        ScaleGlow = float(HitPoints) / float(Default.HitPoints) * 0.9 + 0.1;
}

// ----------------------------------------------------------------------
// BaseChange()
//
// Ripped out most of the code from the original BaseChange; the equivalent
// functionality has been moved to Landed() and SupportActor()
// ----------------------------------------------------------------------

singular function BaseChange()
{
    bBobbing = false;

    if((base == None) && (bPushable || IsA('Carcass')) && (Physics == PHYS_None))
        SetPhysics(PHYS_Falling);

    // make sure if a decoration is accidentally dropped,
    // we reset it's parameters correctly
    SetCollision(Default.bCollideActors, Default.bBlockActors, Default.bBlockPlayers);
    Style = Default.Style;
    bUnlit = Default.bUnlit;
}



// ----------------------------------------------------------------------
// Tick()
//
// Make the decoration act like it is floating
// Покачивание декорации на поверхности воды (или в воздухе)
// ----------------------------------------------------------------------

event Tick(float deltaTime)
{
    local float        ang;
    local rotator      rot;
    local DeusExPlayer player;

    if (GetStateName() == 'Interpolating')
    return;

    Super.Tick(deltaTime);


    // + 3-4 FPS, instead of rendering on HUD.
    if (bShouldBeAlwaysUpdated)
        LastRenderTime = Level.TimeSeconds;

    if (bFloating)
    {
        ang = 2 * Pi * Level.TimeSeconds / 4.0;
        rot = origRot;
        rot.Pitch += Sin(ang) * 512;
        rot.Roll += Cos(ang) * 512;
        rot.Yaw += Sin(ang) * 256;
        SetRotation(rot);
    }

    // BOOGER!  This is a hack!
    // Ideally, we'd set the base of the fly generator to this decoration,
    // but unfortunately this prevents the player from picking up the
    // decoration... need to fix!

    if (flyGen != None)
    {
        if ((flyGen.Location != Location) || (flyGen.Rotation != Rotation))
        {
            flyGen.SetLocation(Location);
            flyGen.SetRotation(Rotation);
        }
    }

    // If we have any conversations, check to see if we're close enough
    // to the player to start one (and all the other checks that take place
    // when a valid conversation can be started);
    if ((conList.Length > 0) && (bindName != ""))// != None)
    {
        player = DeusExPlayer(GetPlayerPawn());
        if (player != None)
            player.StartConversation(Self, IM_Radius);
    }
}



// ----------------------------------------------------------------------
// this decoration will now float with cool bobbing if it is
// buoyant enough
// DXR: PhysicsVolumeChange replaces old ZoneChange().
// ----------------------------------------------------------------------
event PhysicsVolumeChange(PhysicsVolume Volume)
{
//Super.PhysicsVolumeChange(Volume);

  if (bFloating && !Volume.bWaterVolume)
  {
        bFloating = False;
        SetRotation(origRot);
        return;
    }

    if (Volume.bWaterVolume)
        ExtinguishFire();

    if (Volume.bWaterVolume && !bFloating && (Buoyancy > Mass))
    {
        bFloating = True;
        origRot = Rotation;
    }
}


// ----------------------------------------------------------------------
// Bump()
// copied from Engine\Classes\Decoration.uc
// modified so we can have strength modify what you can push
// ----------------------------------------------------------------------
event Bump(actor Other)
{
    local int augLevel, augMult;
    local float maxPush, velscale;
    local DeusExPlayer player;
    local Rotator rot;

    player = DeusExPlayer(Other);

    // if we are bumped by a burning pawn, then set us on fire
    if (Other.IsA('DeusExPawn') && DeusExPawn(Other).bOnFire && !Other.IsA('Robot') && !PhysicsVolume.bWaterVolume && bFlammable)
        GotoState('Burning');

    // if we are bumped by a burning decoration, then set us on fire
    if (Other.IsA('DeusExDecoration') && DeusExDecoration(Other).IsInState('Burning') && DeusExDecoration(Other).bFlammable && !PhysicsVolume.bWaterVolume && bFlammable)
        GotoState('Burning');

    // Check to see if the actor touched is the Player Character
    if (player != None)
    {
        // if we are being carried, ignore Bump()
        if (player.CarriedDecoration == Self)
            return;
    }

    if (bPushable && (PlayerPawn(Other) != None) && (Other.Mass > 40))// && (Physics != PHYS_Falling))
    {
        // A little bit of a hack...
        // Make sure this decoration isn't being bumped from above or below
        if (abs(Location.Z-Other.Location.Z) < (CollisionHeight+Other.CollisionHeight-1))
        {
            maxPush = 100;
            augMult = 1;
            if (player != None)
            {
                if (player.AugmentationSystem != None)
                {
                    augLevel = player.AugmentationSystem.GetClassLevel(class'AugMuscle');
                    if (augLevel >= 0)
                        augMult = augLevel+2;
                    maxPush *= augMult;
                }
            }

            if (Mass <= maxPush)
            {
                // slow it down based on how heavy it is and what level my augmentation is
                velscale = FClamp((50.0 * augMult) / Mass, 0.0, 1.0);
                if (velscale < 0.25)
                    velscale = 0;

                // apply more velocity than normal if we're floating
                if (bFloating)
                    Velocity = Other.Velocity;
                else
                    Velocity = Other.Velocity * velscale;

                if (Physics != PHYS_Falling)
                    Velocity.Z = 0;

                if (!bFloating && !bPushSoundPlaying && (Mass > 15))
                {
                    //pushSoundId = PlaySoundEx(PushSound, SLOT_Misc, , true, 128,,true);
                    AmbientSound = PushSound;
                    class'EventManager'.static.AIStartEvent(self,'LoudNoise', EAITYPE_Audio, , 128);
                    bPushSoundPlaying = True;
                }

                if (!bFloating && (Physics != PHYS_Falling))
                    SetPhysics(PHYS_Walking);

                SetTimer(0.2, False);
                Instigator = Pawn(Other);

                // Impart angular velocity (yaw only) based on where we are bumped from
                // NOTE: This is faked, but it looks cool
                rot = Rotator((Other.Location - Location) << Rotation);
                rot.Pitch = 0;
                rot.Roll = 0;

                // ignore which side we're pushing from
                if (rot.Yaw >= 24576)
                    rot.Yaw -= 32768;
                else if (rot.Yaw >= 8192)
                    rot.Yaw -= 16384;
                else if (rot.Yaw <= -24576)
                    rot.Yaw += 32768;
                else if (rot.Yaw <= -8192)
                    rot.Yaw += 16384;

                // scale it down based on mass and apply the new "rotational force"
                rot.Yaw *= velscale * 0.025;
                SetRotation(Rotation+rot);
            }
        }
    }
}


// ----------------------------------------------------------------------
// Timer() function for Bump
//
// shuts off the looping push sound
// ----------------------------------------------------------------------
event Timer()
{
    if (bPushSoundPlaying)
    {
//        class'DxUtil'.static.StopSound(self, PushSoundId);
        class'EventManager'.static.AIEndEvent(self,'LoudNoise', EAITYPE_Audio);
        bPushSoundPlaying = False;
        AmbientSound = None; //default.AmbientSound;

        acceleration = vect(0,0,0);
        velocity = vect(0,0,0);
    }
}


/*
   drops everything that is based on this decoration
*/
function DropThings()
{
    local actor A;

    // drop everything that is on us
    foreach BasedActors(class'Actor', A)
        if (!A.IsA('DeusExEmitter'))
            A.SetPhysics(PHYS_Falling);
}

function EnterConversationState(bool bFirstPerson, optional bool bAvoidState)
{
    // First check to see if we're already in a conversation state, 
    // in which case we'll abort immediately

    if ((GetStateName() == 'Conversation') || (GetStateName() == 'FirstPersonConversation'))
        return;

    NextState = GetStateName();

    // If bAvoidState is set, then we don't want to jump into the conversaton state
    // because bad things might happen otherwise.

    if (!bAvoidState)
    {
        if (bFirstPerson)
            GotoState('FirstPersonConversation');
        else
            GotoState('Conversation');
    }
}

function EndConversation()
{
    LastConEndTime = Level.TimeSeconds;
    Enable('Bump');
    GotoState(NextState);
}

/*
   Just sit here until the conversation is over
*/
state Conversation
{
    ignores bump, frob;

Idle:
    Sleep(1.0);
    goto('Idle');

Begin:

    // Make sure we're not on fire!
    ExtinguishFire();

    goto('Idle');
}


/*
   Just sit here until the conversation is over
*/
state FirstPersonConversation
{
    ignores bump, frob;

Idle:
    Sleep(1.0);
    goto('Idle');

Begin:
    goto('Idle');
}



// ----------------------------------------------------------------------
// Explode()
// Blow it up real good!
// ----------------------------------------------------------------------
function Explode(vector HitLocation)
{
    local ShockRing ring;
    local ExplosionLight light;
    local ScorchMark s;
    local int i;

    // make sure we wake up when taking damage
    bStasis = False;

    // alert NPCs that I'm exploding
    class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, , explosionRadius * 16);
        
    if (explosionRadius <= 128)
        PlaySound(Sound'SmallExplosion1', SLOT_None,,, explosionRadius*16);
    else
        PlaySound(Sound'LargeExplosion1', SLOT_None,,, explosionRadius*16);

    // draw a pretty explosion
    light = Spawn(class'ExplosionLight',,, HitLocation);
    if (explosionRadius < 128)
    {
        Spawn(class'ExplosionSmall',,, HitLocation);
        light.size = 2;
    }
    else if (explosionRadius < 256)
    {
        Spawn(class'ExplosionMedium',,, HitLocation);
        light.size = 4;
    }
    else
    {
        Spawn(class'ExplosionLarge',,, HitLocation);
        light.size = 8;
    }

    // draw a pretty shock ring
    ring = Spawn(class'ShockRing',,, HitLocation, rot(16384,0,0));
    if (ring != None)
        ring.size = explosionRadius / 32.0;
    ring = Spawn(class'ShockRing',,, HitLocation, rot(0,0,0));
    if (ring != None)
        ring.size = explosionRadius / 32.0;
    ring = Spawn(class'ShockRing',,, HitLocation, rot(0,16384,0));
    if (ring != None)
        ring.size = explosionRadius / 32.0;

    // spawn a mark
    s = spawn(class'ScorchMark', Base,, Location, rot(-16384,0,0));
/*    if (s != None)
    {
       s.SetDrawScale(FClamp(explosionDamage/30, 0.1, 3.0)); // Похоже это ничего не дает
    }*/

    // spawn some rocks
    for (i=0; i<explosionDamage/30+1; i++)
    if (FRand() < 0.8)
       spawn(class'Rockchip',,,HitLocation);

    GotoState('Exploding');
}


// ----------------------------------------------------------------------
// Exploding state
// ----------------------------------------------------------------------

state Exploding
{
    ignores Explode;

    event Timer()
    {
        HurtRadius
        (
            (2 * explosionDamage) / gradualHurtSteps,
            (explosionRadius / gradualHurtSteps) * gradualHurtCounter,
            class'DM_Exploded',
            (explosionDamage / gradualHurtSteps) * 100,
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
    bHidden = True;
    SetCollision(False, False, False);
    SetTimer(0.5/float(gradualHurtSteps), True);
}


// ----------------------------------------------------------------------
// this is our normal, just sitting there state
// ----------------------------------------------------------------------
auto state Active
{
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
    {
        local float avg;
        local float MassMult;

        MassMult = 0.85; //DXR: For now

        if (bStatic || bInvincible)
            return;

        if ((DamageType == class'DM_TearGas') || (DamageType == class'DM_PoisonGas') || (DamageType == class'DM_Radiation'))
            return;

        if ((DamageType == class'DM_EMP') || (DamageType == class'DM_NanoVirus') || (DamageType == class'DM_Shocked'))
            return;

        if (DamageType == class'DM_HalonGas')
            ExtinguishFire();

        // DXR: Сдвинуть декорацию если возможно
        if ((Mass <= 100) && (bPushable) && (bCanBePushedByDamage))
        {
            Velocity = (Momentum*0.125) * damage * 0.8 * massmult; 
            DamageForce(Damage);
        }

        if ((DamageType == class'DM_Burned') || (DamageType == class'DM_Flamed'))
        {
            if (bExplosive)     // blow up if we are hit by fire
                HitPoints = 0;
            else if (bFlammable && !PhysicsVolume.bWaterVolume)
            {
                GotoState('Burning');
                return;
            }
        }
        if (Damage >= minDamageThreshold)
            HitPoints -= Damage;
        else
        {
            // sabot damage at 50%
            // explosion damage at 25%
            if (damageType == class'DM_Sabot')
                HitPoints -= Damage * 0.5;
            else if (damageType == class'DM_Exploded')
                HitPoints -= Damage * 0.25;
            else if (damageType == class'DM_GrenadeDeath')
                HitPoints -= Damage * 0.25;
            else if (damageType == class'DM_Decapitated')
                HitPoints -= Damage * 0.5;
        }

        if (HitPoints > 0)      // darken it to show damage (from 1.0 to 0.1 - don't go completely black)
        {
            ResetScaleGlow();
        }
        else    // destroy it!
        {
            DropThings();

            // clear the event to keep Destroyed() from triggering the event
            Event = '';
            avg = (CollisionRadius + CollisionHeight) / 2;
            Instigator = EventInstigator;
            if (Instigator != None)
                MakeNoise(1.0);

            if (fragType == class'WoodFragment')
            {
                if (avg > 20)
                    PlaySound(sound'WoodBreakLarge', SLOT_Misc,,, 512);
                else
                    PlaySound(sound'WoodBreakSmall', SLOT_Misc,,, 512);
                class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, , 512);
            }
            if (bExplosive)
            {
                Frag(fragType, Momentum * explosionRadius / 4, avg/20.0, avg/5 + 1);
                Explode(HitLocation);
            }
            else
                Frag(fragType, Momentum / 10, avg/20.0, avg/5 + 1);
        }
    }
}


// ----------------------------------------------------------------------
// ExtinguishFire()
// ----------------------------------------------------------------------
function ExtinguishFire()
{
    local Fire f;

    if (IsInState('Burning'))
    {
        foreach BasedActors(class'Fire', f)
            f.Destroy();

        GotoState('Active');
    }
}



// ----------------------------------------------------------------------
// state Burning
//
// We are burning and slowly taking damage
// ----------------------------------------------------------------------
state Burning
{
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
    {
        local float avg;

        if ((DamageType == class'DM_TearGas') || (DamageType == class'DM_PoisonGas') || (DamageType == class'DM_Radiation'))
            return;

        if ((DamageType == class'DM_EMP') || (DamageType == class'DM_NanoVirus') || (DamageType == class'DM_Shocked'))
            return;

        if (DamageType == class'DM_HalonGas')
            ExtinguishFire();

        // if we are already burning, we can't take any more damage
        if ((DamageType == class'DM_Burned') || (DamageType == class'DM_Flamed'))
        {
            HitPoints -= Damage/2;
        }
        else
        {
            if (Damage >= minDamageThreshold)
                HitPoints -= Damage;
        }

        if (bExplosive)
            HitPoints = 0;

        if (HitPoints > 0)      // darken it to show damage (from 1.0 to 0.1 - don't go completely black)
        {
            ResetScaleGlow();
        }
        else    // destroy it!
        {
            DropThings();

            // clear the event to keep Destroyed() from triggering the event
            Event = '';
            avg = (CollisionRadius + CollisionHeight) / 2;
            Frag(fragType, Momentum / 10, avg/20.0, avg/5 + 1);
            Instigator = EventInstigator;
            if (Instigator != None)
                MakeNoise(1.0);

            // if we have been blown up, then destroy our contents
            if (bExplosive)
            {
//              Contents = None;
//              Content2 = None;
//              Content3 = None;
                Explode(HitLocation);
            }
        }
    }

    // continually burn and do damage
    event Timer()
    {
        if (bPushSoundPlaying)
        {
            class'DxUtil'.static.StopSound(self, PushSoundId);
            class'EventManager'.static.AIEndEvent(self,'LoudNoise', EAITYPE_Audio);
            AmbientSound = None; // DXR: Теперь это тоже нужно
            bPushSoundPlaying = False;
        }
        TakeDamage(2, None, Location, vect(0,0,0), class'DM_Burned');
    }

    function BeginState()
    {
        local Fire f;
        local int i;
        local vector loc;

        for (i=0; i<AmountOfFire; i++)
        {
            loc.X = 0.9*CollisionRadius * (1.0-2.0*FRand());
            loc.Y = 0.9*CollisionRadius * (1.0-2.0*FRand());
            loc.Z = 0.9*CollisionHeight * (1.0-2.0*FRand());
            loc += Location;
            f = Spawn(class'Fire', Self,, loc);
            if (f != None)
            {
                f.SetDrawScale(FRand() + 1.0);
                f.LifeSpan = Flammability;

                // turn off the sound and lights for all but the first one
                if (i > 0)
                {
                    f.AmbientSound = None;
                    f.LightType = LT_None;
                }

                // turn on/off extra fire and smoke
                if (FRand() < 0.5)
                    f.smokeGen.Destroy();
                if (FRand() < 0.5)
                    f.AddFire(1.5);
            }
        }

        // set the burn timer
        SetTimer(1.0, True);
    }
}


// ----------------------------------------------------------------------
// Frag()
//
// copied from Engine.Decoration
// modified so fragments will smoke and use the skin of their parent object
// ----------------------------------------------------------------------
function Frag(class<fragment> FragType, vector Momentum, float DSize, int NumFrags) 
{
    local int i;
    local actor A, Toucher;
    local DeusExFragment s;

    if (bOnlyTriggerable)
        return;

    if (Event!='')
        foreach AllActors( class 'Actor', A, Event )
            A.Trigger( Toucher, pawn(Toucher) );

    if (PhysicsVolume.bDestructive)
    {
        Destroy();
        return;
    }

    for (i=0 ; i<NumFrags + 5; i++) 
    {
        s = DeusExFragment(Spawn(FragType, Owner));
        if (s != None)
        {
            s.Instigator = Instigator;
            s.CalcVelocity(Momentum,0);
            s.SetDrawScale(DSize*0.5+0.7*DSize*FRand());
            s.Skins[0] = GetMeshTexture();
            if (bExplosive)
                s.bSmoking = True;
        }
    }

    if (!bExplosive)
        Destroy();
}



// ----------------------------------------------------------------------
// Destroyed()
// ----------------------------------------------------------------------

event Destroyed()
{
    local DeusExPlayer Player;

    if (bPushSoundPlaying)
    {
        class'DxUtil'.static.StopSound(self, PushSoundId);
        class'EventManager'.static.AIEndEvent(self,'LoudNoise', EAITYPE_Audio);
        bPushSoundPlaying = False;
        AmbientSound = None; // DXR: Just in case
    }
    // DXR: from GMDX mod
    if (fragType == class'GlassFragment')
        PlaySound(sound'GlassBreakSmall',SLOT_Interact,1.0,,1024);


    if (flyGen != None)
    {
        flyGen.Burst();
        flyGen.StopGenerator();
        flyGen = None;
    }

    // Pass a message to conPlay, if it exists in the player, that 
    // this object has been destroyed.  This is used to prevent 
    // bad things from happening in converseations.
    player = DeusExPlayer(GetPlayerPawn());

    if ((player != None) && (player.conPlay != None))
    {
        player.conPlay.ActorDestroyed(Self);
    }

    DropThings();

    if (!IsA('Containers'))
        Super.Destroyed();
}

function Pawn GetPlayerPawn()
{
    return Level.GetLocalPlayerController().Pawn;
}

// ----------------------------------------------------------------------
// if we are triggered and explosive, then explode
// ----------------------------------------------------------------------
function Trigger(Actor Other, Pawn Instigator)
{
    if (bExplosive)
    {
        Explode(Location);
        Super.Trigger(Other, Instigator);
    }
}

function material GetMeshTexture(optional int texnum)
{
  return class'ObjectManager'.static.GetActorMeshTexture(self, texnum);
}

function array<Object> GetConList()
{
   return conList;
}

function ConBindEvents()
{
    local DeusExLevelInfo dxInfo;

    foreach AllActors(class'DeusExLevelInfo', dxInfo)
    {
        if (dxInfo != none)
            break;
    }
    if (dxInfo != none)
    {
       RegisterConFiles(dxinfo.ConversationsPath);
     LoadConsForMission(dxinfo.missionNumber);
    }
    else
        log("DeusExLevelInfo not found! Failed to register conversations.");
}

// Регистрация *.con файлов
function RegisterConFiles(string Path)
{
   local array<byte> bt;
   local array<string> conFiles;
   local int f, res;

   conFiles = class'FileManager'.static.FindFiles(Path$"*.con", true, false);

   if (conFiles.length == 0)
   {
       log("ERROR -- No *.con files found !");
       return;
   }

  for (f=0; f<conFiles.length; f++)
  {
      bt = class'DXUtil'.static.GetFileAsArray(Path$conFiles[f]);
      res = class'ConversationManager'.static.RegisterConFile(Path$conFiles[f],bt);
  }
}

function LoadConsForMission(int mission)
{
   if (bindName != "")
       class'ConversationManager'.static.GetConversations(conList, mission, bindName, "");
}

function DeusExGameInfo getFlagBase()
{
    return DeusExGameInfo(Level.Game);
}

event PostLoadSavedGame()
{
    ConBindEvents();
}

function float GetBaseEyeHeight()
{
    return BaseEyeHeight;
}

function float GetEyeHeight()
{
    return collisionheight;
}

function string GetBindName()
{
    return bindName;
}

function string GetBarkBindName() // Used to bind Barks!
{
    return BarkBindName;
}

function string GetFamiliarName() // For display in Conversations
{
    return FamiliarName;
}

function string GetUnfamiliarName() // For display in Conversations
{
    return UnfamiliarName;
}

function float GetConStartInterval()
{
    return ConStartInterval;
}

function float GetLastConEndTime()  // Time when last conversation ended
{
    return LastConEndTime;
}

// ----------------------------------------------------------------------

defaultproperties
{
     ShadowDirection=(X=1.00,Y=1.00,Z=6.00)
     HitPoints=20
     FragType=Class'DeusEx.MetalFragment'
     Flammability=30.000000
     explosionDamage=100
     explosionRadius=768.000000
     bHighlight=True
     ItemName="DEFAULT DECORATION NAME - REPORT THIS AS A BUG"
     bPushable=True
     PushSound=None // Sound'DeusExSounds.Generic.PushMetal'
     bStatic=False
     Texture=Texture'Engine.S_Pawn'
     bTravel=True
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     physics=PHYS_Falling

     AmountOfFire=1 // DXR: Количество источников огня. 
     bUseDynamicLights=true // DXR: Чтобы более-менее освещались от AugLight
     bFullVolume=false
     bHardAttach=false
     bIgnoreOutOfWorld=true
     bLightingVisibility=false
     bActorShadows=false
     bCanBePushedByDamage=false
     bUseCylinderCollision=true // DXR: Ignore StaticMesh built-in collision (if DrawType=DT_StaticMesh of course)

     ShadowLightDistance=1200
     ShadowMaxTraceDistance=1050
}
