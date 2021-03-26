/*
  Base weapon class. Converted from DeusEx Demo.
  Added fixes from "DeusEx V2" and GMDX.
*/

class DeusExWeapon extends RuntimeWeapon
                            HideDropDown
                                Abstract;

const AcquireTarget_DIST = 10000;

//
// enums for weapons (duh)
//
enum EEnemyEffective
{
    ENMEFF_All,
    ENMEFF_Organic,
    ENMEFF_Robot
};

enum EEnviroEffective
{
    ENVEFF_All,
    ENVEFF_Air,
    ENVEFF_Water,
    ENVEFF_Vacuum,
    ENVEFF_AirWater,
    ENVEFF_AirVacuum,
    ENVEFF_WaterVacuum
};

enum EConcealability
{
    CONC_None,
    CONC_Visual,
    CONC_Metal,
    CONC_All
};

enum EAreaType
{
    AOE_Point,
    AOE_Cone,
    AOE_Sphere
};

enum ELockMode
{
    LOCK_None,
    LOCK_Invalid,
    LOCK_Range,
    LOCK_Acquire,
    LOCK_Locked
};

var() float ShellCasingDrawScale;

var bool                bReadyToFire;           // true if our bullets are loaded, etc.
var() int               LowAmmoWaterMark;       // critical low ammo count
var travel int          ClipCount;              // number of bullets remaining in current clip

var() class<Skill>      GoverningSkill;         // skill that affects this weapon
var() travel float      NoiseLevel;             // amount of noise that weapon makes when fired
var() EEnemyEffective   EnemyEffective;         // type of enemies that weapon is effective against
var() EEnviroEffective  EnviroEffective;        // type of environment that weapon is effective in
var() EConcealability   Concealability;         // concealability of weapon
var() travel bool       bAutomatic;             // is this an automatic weapon?
var() travel float      ShotTime;               // number of seconds between shots
var() travel float      ReloadTime;             // number of seconds needed to reload the clip
var() int               HitDamage;              // damage done by a single shot (or for shotguns, a single slug)
var() int               MaxRange;               // absolute maximum range in world units (feet * 16)
var() travel int        AccurateRange;          // maximum accurate range in world units (feet * 16)
var() travel float      BaseAccuracy;           // base accuracy (0.0 is dead on, 1.0 is far off)

var bool                bCanHaveScope;          // can this weapon have a scope?
var() travel bool       bHasScope;              // does this weapon have a scope?
var() int               ScopeFOV;               // FOV while using scope
var bool                bZoomed;                // are we currently zoomed?
var bool                bWasZoomed;             // were we zoomed? (used during reloading)

var bool                bCanHaveLaser;          // can this weapon have a laser sight?
var() travel bool       bHasLaser;              // does this weapon have a laser sight?
var bool                bLasing;                // is the laser sight currently on?
var EM_LaserBeam        Emitter;                // actual laser emitter - valid only when bLasing == True

var bool                bCanHaveSilencer;       // can this weapon have a silencer?
var() travel bool       bHasSilencer;           // does this weapon have a silencer?

var() bool              bCanTrack;              // can this weapon lock on to a target?
var() float             LockTime;               // how long the target must stay targetted to lock
var float               LockTimer;              // used for lock checking
var Actor               Target;                 // actor currently targetted
var ELockMode           LockMode;               // is this target locked?
var string              TargetMessage;          // message to print during targetting
var float               TargetRange;            // range to current target
var() Sound             LockedSound;            // sound to play when locked
var() Sound             TrackingSound;          // sound to play while tracking a target
var float               SoundTimer;             // to time the sounds correctly

var() class<Ammunition> AmmoNames[3];           // three possible types of ammo per weapon
var() class<Projectile> ProjectileNames[3];     // projectile classes for different ammo
var() EAreaType         AreaOfEffect;           // area of effect of the weapon
var() bool              bPenetrating;           // shot will penetrate and cause blood
var() float             StunDuration;           // how long the shot stuns the target
var() bool              bHasMuzzleFlash;        // does this weapon have a flash when fired?
var() bool              bHandToHand;            // is this weapon hand to hand (no ammo)?
var() travel float      recoilStrength;         // amount that the weapon kicks back after firing (0.0 is none, 1.0 is large)
var bool                bFiring;                // True while firing, used for recoil
var bool                bOwnerWillNotify;       // True if firing hand-to-hand weapons is dependent on the owner's animations
var bool                bFallbackWeapon;        // If True, only use if no other weapons are available
var bool                bNativeAttack;          // True if weapon represents a native attack
var bool                bEmitWeaponDrawn;       // True if drawing this weapon should make NPCs react
var bool                bUseWhileCrouched;      // True if NPCs should crouch while using this weapon
var bool                bUseAsDrawnWeapon;      // True if this weapon should be carried by NPCs as a drawn weapon

var bool bNearWall;                             // used for prox. mine placement
var Vector placeLocation;                       // used for prox. mine placement
var Vector placeNormal;                         // used for prox. mine placement
var Mover placeMover;                           // used for prox. mine placement

var float ShakeTimer;
var float ShakeYaw;
var float ShakePitch;

var float AIMinRange;                           // minimum "best" range for AI; 0=default min range
var float AIMaxRange;                           // maximum "best" range for AI; 0=default max range
var float AITimeLimit;                          // maximum amount of time an NPC should hold the weapon; 0=no time limit
var float AIFireDelay;                          // Once fired, use as fallback weapon until the timeout expires; 0=no time limit

var float standingTimer;                        // how long we've been standing still (to increase accuracy)
var float currentAccuracy;                      // what the currently calculated accuracy is (updated every tick)

var MuzzleFlash flash;                          // muzzle flash actor

// Used to track weapon mods accurately.
var bool bCanHaveModBaseAccuracy;
var bool bCanHaveModReloadCount;
var bool bCanHaveModAccurateRange;
var bool bCanHaveModReloadTime;
var bool bCanHaveModRecoilStrength;
var travel float ModBaseAccuracy;
var travel float ModReloadCount;
var travel float ModAccurateRange;
var travel float ModReloadTime;
var travel float ModRecoilStrength;

var localized String msgCannotBeReloaded;
var localized String msgOutOf;
var localized String msgNowHas;
var localized String msgAlreadyHas;
var localized String msgNone;
var localized String msgLockInvalid;
var localized String msgLockRange;
var localized String msgLockAcquire;
var localized String msgLockLocked;
var localized String msgRangeUnit;
var localized String msgTimeUnit;
var localized String msgMassUnit;
var localized String msgNotWorking;

//
// strings for info display
//
var localized String msgInfoAmmoLoaded;
var localized String msgInfoAmmo;
var localized String msgInfoDamage;
var localized String msgInfoClip;
var localized String msgInfoROF;
var localized String msgInfoReload;
var localized String msgInfoRecoil;
var localized String msgInfoAccuracy;
var localized String msgInfoAccRange;
var localized String msgInfoMaxRange;
var localized String msgInfoMass;
var localized String msgInfoLaser;
var localized String msgInfoScope;
var localized String msgInfoSilencer;
var localized String msgInfoNA;
var localized String msgInfoYes;
var localized String msgInfoNo;
var localized String msgInfoAuto;
var localized String msgInfoSingle;
var localized String msgInfoRounds;
var localized String msgInfoRoundsPerSec;
var localized String msgInfoSkill;
var localized String msgInfoWeaponStats;

// camera shakes //
var(ShakeView) vector ShakeRotMag;           // how far to rot view
var(ShakeView) vector ShakeRotRate;          // how fast to rot view
var(ShakeView) float  ShakeRotTime;          // how much time to rot the instigator's view
var(ShakeView) vector ShakeOffsetMag;        // max view offset vertically
var(ShakeView) vector ShakeOffsetRate;       // how fast to offset view vertically
var(ShakeView) float  ShakeOffsetTime;       // how much time to offset view

var float holdShotTime;

//
// network replication
//
replication
{
    // Things the client should send to the server
    reliable if (Role<ROLE_Authority)
        ClipCount, LockTimer, Target, LockMode, TargetMessage, TargetRange;
}

// Drop "physical" version of the used weapon, instead of disappearing to nowhere.
function DropUsedWeapon();

function PlayDownSound()
{
   if (bool(Owner))
      Owner.PlaySound(GetDownSound(), SLOT_Misc,,, 1024);
}

// Переопределить в дочерних классах.
function Sound GetSelectSound()
{
   return default.SelectSound;
}

function Sound GetFireSound()
{
   return default.FireSound;
}

function Sound GetGEPFireSound()
{
   return sound'GEPGunFire';
}

function Sound GetGEPFireWPSound()
{
   return sound'GEPGunFireWP';
}

function Sound GetReloadBeginSound()
{
   return default.CockingSound;
}

function Sound GetReloadEndSound()
{
   return default.ReloadEndSound;
}

function Sound GetDownSound()
{
   return default.DownSound;
}

function Sound Get20mmFireSound() // Особый случай!
{
   return sound'AssaultGunFire20mm';
}

function Sound GetFleshHitSound()
{
   return default.Misc1Sound;
}

function Sound GetHardHitSound()
{
   return default.Misc2Sound;
}

function Sound GetSoftHitSound()
{
   return default.Misc3Sound;
}

function Sound GetSilencedSound()
{
   return sound'StealthPistolFire';
}

function Sound GetLandedSound()
{
   return default.LandSound;
}

event RenderOverlays(Canvas u)
{
    Super.RenderOverlays(u);

    if (bZoomed)
    {
        renderScopeView(u);

//        if ((DeusExPlayerController(Instigator.Controller)) != None)
        DeusExPlayerController(Instigator.Controller).DesiredFOV = ScopeFOV;
    }
}


function renderScopeView(canvas u)
{
    local texture bg, cr;

    bg = texture'HUDScopeView';
    cr = texture'HUDScopeCrosshair';

     if (DeusExPlayer(Owner) != none)
     {
        // Вид из прицела...
        u.SetDrawColor(255,255,255,255);
        u.setPos(u.sizeX / 2 - 256,u.sizeY / 2 - 256);
        u.Style = ERenderStyle.STY_Modulated;
        u.DrawTileJustified(bg, 1, 512, 512); // 0 = left/top, 1 = center, 2 = right/bottom 
        u.Style = ERenderStyle.STY_Normal;
        u.SetDrawColor(255,255,255,255);
        u.DrawTileJustified(cr, 1, 512, 512); // 0 = left/top, 1 = center, 2 = right/bottom 

        // Заполнители
        u.Style = ERenderStyle.STY_Normal;
        u.DrawColor = class'DeusExHUD'.default.blackColor;

        u.SetPos(0,0); // верхний
        u.DrawTileStretched(texture'solid', u.sizeX, (u.sizeY / 2) - 256);

        u.SetPos(0,(u.sizeY / 2) + 256); // Нижний заполнитель...
        u.DrawTileStretched(texture'solid', u.sizeX, u.sizeY );

        u.SetPos(0,(u.sizeY /2) - 256); // Левый заполнитель...
        u.DrawTileStretched(texture'solid', (u.sizeX / 2) - 256, (u.sizeY / 2) + 152);

        u.SetPos((u.SizeX / 2) + 256,(u.sizeY /2) - 256); // Правый заполнитель...
        u.DrawTileStretched(texture'solid', (u.sizeX / 2) - 256, (u.sizeY / 2) + 152);
     }
}

function bool isPlayingIdleAnim()
{
   if (GetAnimSequence() == 'Idle1' || GetAnimSequence() == 'Idle2' || GetAnimSequence() == 'Idle3')
   return true;

   return false;
}

function PutBackInHand()
{
    log(self@"  PutBackInHand() ?");

    if (self == PlayerPawn(Owner).myWeapon)
    {
        bPostTravel = true;
        PlayerPawn(Owner).PutInHand(self);
//        bPostTravel = false;
    }
    else GotoState('Idle2');
}

//
// install the correct projectile info if needed
//
event TravelPostAccept()
{
    local int i;

    Super.TravelPostAccept();

    beltPos--;

    // make sure the AmmoName matches the currently loaded AmmoType
    if (AmmoType != None)
        AmmoName = AmmoType.class;

    if (!bInstantHit)
    {
        if (ProjectileClass != None)
            ProjectileSpeed = ProjectileClass.Default.speed;

        // make sure the projectile info matches the actual AmmoType
        // since we can't "var travel class" (AmmoName and ProjectileClass)
        if (AmmoType != None)
        {
            //FireSound = None; // DXR: Это зачем здесь?
            for (i=0; i<ArrayCount(AmmoNames); i++)
            {
                if (AmmoNames[i] == AmmoName)
                {
                    ProjectileClass = ProjectileNames[i];
                    break;
                }
            }
        }
    }
    bPostTravel = true;
    PutBackInHand();
}

singular function BaseChange()
{
    Super.BaseChange();

    // Make sure we fall if we don't have a base
    if ((base == None) && (Owner == None))
        SetPhysics(PHYS_Falling);
}

function bool HandlePickupQuery(Inventory Item)
{
    local DeusExWeapon W;
    local DeusExPlayer player;
    local bool bResult;
    local class<Ammunition> defAmmoClass;
    local Ammunition defAmmo;
    
    // make sure that if you pick up a modded weapon that you
    // already have, you get the mods
    W = DeusExWeapon(Item);
    if ((W != None) && (W.class == class))
    {
        if (W.ModBaseAccuracy > ModBaseAccuracy)
            ModBaseAccuracy = W.ModBaseAccuracy;
        if (W.ModReloadCount > ModReloadCount)
            ModReloadCount = W.ModReloadCount;
        if (W.ModAccurateRange > ModAccurateRange)
            ModAccurateRange = W.ModAccurateRange;

        // these are negative
        if (W.ModReloadTime < ModReloadTime)
            ModReloadTime = W.ModReloadTime;
        if (W.ModRecoilStrength < ModRecoilStrength)
            ModRecoilStrength = W.ModRecoilStrength;

        if (W.bHasLaser)
            bHasLaser = True;
        if (W.bHasSilencer)
            bHasSilencer = True;
        if (W.bHasScope)
            bHasScope = True;

        // copy the actual stats as well
        if (W.ReloadCount > ReloadCount)
            ReloadCount = W.ReloadCount;
        if (W.AccurateRange > AccurateRange)
            AccurateRange = W.AccurateRange;

        // these are negative
        if (W.BaseAccuracy < BaseAccuracy)
            BaseAccuracy = W.BaseAccuracy;
        if (W.ReloadTime < ReloadTime)
            ReloadTime = W.ReloadTime;
        if (W.RecoilStrength < RecoilStrength)
            RecoilStrength = W.RecoilStrength;
    }
    player = DeusExPlayer(Owner);

    if (Item.class == class)
    {
        if (!((Weapon(item).bWeaponStay && (Level.NetMode == NM_Standalone)) && 
           (!Weapon(item).bHeldItem || Weapon(item).bTossedOut)))
        {
            // Only add ammo of the default type
            // There was an easy way to get 32 20mm shells, by picking up another assault rifle with 20mm ammo selected
            if (AmmoType != None)
            {
                // Add to default ammo only
                if (AmmoNames[0] == None)
                    defAmmoClass = AmmoName;
                else
                    defAmmoClass = AmmoNames[0];

                defAmmo = Ammunition(player.FindInventoryType(defAmmoClass));
                defAmmo.AddAmmo(RuntimeWeapon(Item).PickupAmmoCount);
            }
        }
    }
    bResult = Super.HandlePickupQuery(Item);

    // Notify the object belt of the new ammo
    if (player != None)
        player.UpdateBeltText(Self);

    return bResult;
}


function BringUp(optional weapon PrevWeapon)
{
    // alert NPCs that I'm whipping it out
    if (!bNativeAttack && bEmitWeaponDrawn)
        class'EventManager'.static.AIStartEvent(self,'WeaponDrawn', EAITYPE_Visual);

    // reset the standing still accuracy bonus
    standingTimer = 0;

    Super.BringUp();
}

function bool PutDown()
{
    // alert NPCs that I'm putting away my gun
    class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);

    // reset the standing still accuracy bonus
    standingTimer = 0;

    return Super.PutDown();
}

function ReloadAmmo()
{
    // single use or hand to hand weapon if ReloadCount == 0
    if (ReloadCount == 0)
    {
        Pawn(Owner).ClientMessage(msgCannotBeReloaded);
        return;
    }

    if (!IsInState('Reload') && CanReload()) //Lork: Prevents you from reloading if you shouldn't be able to
    {
       if (isPlayingIdleAnim())
           TweenAnim('Still', 0.1);

        GotoState('Reload');
    }
}

//Lork: Reload function intended for changing to different ammo types
function ReloadNewAmmo()
{
    // single use or hand to hand weapon if ReloadCount == 0
    if (ReloadCount == 0)
    {
        Pawn(Owner).ClientMessage(msgCannotBeReloaded);
        return;
    }

    if (!IsInState('Reload'))
    {
       if (isPlayingIdleAnim())
           TweenAnim('Still', 0.1);
        GotoState('Reload');
    }
}

// Note we need to control what's calling this...but I'll get rid of the access nones for now
function float GetWeaponSkill()
{
    local DeusExPlayer player;
    local float value;

    value = 0;

    if (Owner != None)
    {
        player = DeusExPlayer(Owner);
        if (player != None)
        {
            if ((player.AugmentationSystem != None) && (player.SkillSystem != None))
            {
                // get the target augmentation
                value = player.AugmentationSystem.GetAugLevelValue(class'AugTarget');
                if (value == -1.0)
                    value = 0;

                // get the skill
                value += player.SkillSystem.GetSkillLevelValue(GoverningSkill);
            }
        }
    }
    return value;
}

// calculate the accuracy for this weapon and the owner's damage
function float CalculateAccuracy()
{
    local float accuracy;   // 0 is dead on, 1 is pretty far off
    local float tempacc, div;
    local int HealthArmRight, HealthArmLeft, HealthHead;
    local int BestArmRight, BestArmLeft, BestHead;
    local bool checkit;
    local DeusExPlayer player;

    accuracy = BaseAccuracy;        // start with the weapon's base accuracy

    player = DeusExPlayer(Owner);

    if (player != None)
    {
        // check the player's skill
        // 0.0 = dead on, 1.0 = way off
        accuracy += GetWeaponSkill();

        // get the health values for the player
        HealthArmRight = player.HealthArmRight;
        HealthArmLeft  = player.HealthArmLeft;
        HealthHead     = player.HealthHead;
        BestArmRight   = player.Default.HealthArmRight;
        BestArmLeft    = player.Default.HealthArmLeft;
        BestHead       = player.Default.HealthHead;
        checkit = True;
    }
    else if (ScriptedPawn(Owner) != None)
    {
        // update the weapon's accuracy with the ScriptedPawn's BaseAccuracy
        // (BaseAccuracy uses higher values for less accuracy, hence we add)
        accuracy += ScriptedPawn(Owner).BaseAccuracy;

        // get the health values for the NPC
        HealthArmRight = ScriptedPawn(Owner).HealthArmRight;
        HealthArmLeft  = ScriptedPawn(Owner).HealthArmLeft;
        HealthHead     = ScriptedPawn(Owner).HealthHead;
        BestArmRight   = ScriptedPawn(Owner).Default.HealthArmRight;
        BestArmLeft    = ScriptedPawn(Owner).Default.HealthArmLeft;
        BestHead       = ScriptedPawn(Owner).Default.HealthHead;
        checkit = True;
    }
    else
        checkit = False;

    if (checkit)
    {
        if (HealthArmRight < 1)
            accuracy += 0.5;
        else if (HealthArmRight < BestArmRight * 0.34)
            accuracy += 0.2;
        else if (HealthArmRight < BestArmRight * 0.67)
            accuracy += 0.1;

        if (HealthArmLeft < 1)
            accuracy += 0.5;
        else if (HealthArmLeft < BestArmLeft * 0.34)
            accuracy += 0.2;
        else if (HealthArmLeft < BestArmLeft * 0.67)
            accuracy += 0.1;

        if (HealthHead < BestHead * 0.67)
            accuracy += 0.1;
    }

    // increase accuracy (decrease value) if we haven't been moving for awhile
    // this only works for the player, because NPCs don't need any more aiming help!
    if (player != None)
    {
        tempacc = accuracy;
        if (standingTimer > 0)
        {
            // higher skill makes standing bonus greater
            div = Max(15.0 + 29.0 * GetWeaponSkill(), 0.0);
            accuracy -= FClamp(standingTimer/div, 0.0, 0.6);
    
            // don't go too low
            if ((accuracy < 0.1) && (tempacc > 0.1))
                accuracy = 0.1;
        }
    }

    // make sure we don't go negative
    if (accuracy < 0.0)
        accuracy = 0.0;

    return accuracy;
}

function bool LoadAmmo(int ammoNum)
{
    local class<Ammunition> newAmmoClass;
    local Ammunition newAmmo;
    local Pawn P;

    if ((ammoNum < 0) || (ammoNum > 2))
        return False;

    P = Pawn(Owner);

    // sorry, only pawns can have weapons
    if (P == None)
        return False;

    newAmmoClass = AmmoNames[ammoNum];

    if (newAmmoClass != None)
    {
        if (newAmmoClass != AmmoName)
        {
            newAmmo = Ammunition(P.FindInventoryType(newAmmoClass));
            if (newAmmo == None)
            {
                P.ClientMessage(Sprintf(msgOutOf, newAmmoClass.default.ItemName));
                return False;
            }
            
            // if we don't have a projectile for this ammo type, then set instant hit
            if (ProjectileNames[ammoNum] == None)
            {
                bInstantHit = True;
                bAutomatic = default.bAutomatic;
                ShotTime = default.ShotTime;

                if (HasReloadMod())
                    ReloadTime = Default.ReloadTime * (1.0+ModReloadTime);
                      else
                    ReloadTime = Default.ReloadTime;

                FireSound = GetFireSound(); //Default.FireSound;
                ProjectileClass = None;
            }
            else
            {
                // otherwise, set us to fire projectiles
                bInstantHit = False;
                bAutomatic = False;
                ShotTime = 1.0;
                if (HasReloadMod())
                    ReloadTime = 2.0 * (1.0+ModReloadTime);
                else
                    ReloadTime = 2.0;
                FireSound = None;       // handled by the projectile
                ProjectileClass = ProjectileNames[ammoNum];
                ProjectileSpeed = ProjectileClass.Default.Speed;
            }

            AmmoName = newAmmoClass;
            AmmoType = newAmmo;

            // AlexB had a new sound for 20mm but there's no mechanism for playing alternate sounds per ammo type
            // Same for WP rocket
            if (Ammo20mm(newAmmo) != None)
            {
                FireSound = Get20mmFireSound(); //Sound'AssaultGunFire20mm';
                log(self@FireSound);
            }
            else if (AmmoRocketWP(newAmmo) != None)
                FireSound = GetGEPFireSound(); //Sound'GEPGunFireWP';
            else if (AmmoRocket(newAmmo) != None)
                FireSound = GetGEPFireWPSound(); //Sound'GEPGunFire';

            // Notify the object belt of the new ammo
            if (DeusExPlayer(P) != None)
                DeusExPlayer(P).UpdateBeltText(Self);

            ReloadNewAmmo(); //Lork: Use the 'old' function so the reload animation will still play

            P.ClientMessage(Sprintf(msgNowHas, ItemName, newAmmoClass.Default.ItemName));
            return True;
        }
        else
        {
            P.ClientMessage(Sprintf(MsgAlreadyHas, ItemName, newAmmoClass.Default.ItemName));
        }
    }

    return False;
}


// ----------------------------------------------------------------------
// Returns True if this ammo type can be used with this weapon
// ----------------------------------------------------------------------
function bool CanLoadAmmoType(Ammunition ammo)
{
    local int  ammoIndex;
    local bool bCanLoad;

    bCanLoad = False;

    if (ammo != None)
    {
        // First check "AmmoName"

        if (AmmoName == ammo.class)
        {
            bCanLoad = True;
        }
        else
        {
            for (ammoIndex=0; ammoIndex<3; ammoIndex++)
            {
                if (AmmoNames[ammoIndex] == ammo.Class)
                {
                    bCanLoad = True;
                    break;
                }
            }
        }
    }
    return bCanLoad;
}

// ----------------------------------------------------------------------
// Load this ammo type given the actual object
// ----------------------------------------------------------------------
function LoadAmmoType(Ammunition ammo)
{
    local int i;

    if (ammo != None)
        for (i=0; i<3; i++)
            if (AmmoNames[i] == ammo.Class)
                LoadAmmo(i);
}

// ----------------------------------------------------------------------
// Load this ammo type given the class
// ----------------------------------------------------------------------
function LoadAmmoClass(class<Ammunition> ammoClass)
{
    local int i;

    if (ammoClass != None)
        for (i=0; i<3; i++)
            if (AmmoNames[i] == ammoClass)
                LoadAmmo(i);
}

function CycleAmmo()
{
    local int i, last;

    if (NumAmmoTypesAvailable() < 2)
        return;

    for (i=0; i<ArrayCount(AmmoNames); i++)
        if (AmmoNames[i] == AmmoName)
            break;

    last = i;

    do
    {
        if (++i >= 3)
            i = 0;

        if (LoadAmmo(i))
            break;
    } until (last == i);
}

function bool CanReload()
{
    if ((ClipCount > 0) && (ReloadCount != 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0) &&
        (AmmoType.AmmoAmount > (ReloadCount-ClipCount)))
        return true;
    else
        return false;
}

function bool MustReload()
{
    if ((AmmoLeftInClip() == 0) && (AmmoType != None) && (AmmoType.AmmoAmount > 0))
        return true;
    else
        return false;
}

function int AmmoLeftInClip()
{
    if (ReloadCount == 0)   // if this weapon is not reloadable
        return 1;
    else if (AmmoType == None)
        return 0;
    else if (AmmoType.AmmoAmount == 0)      // if we are out of ammo
        return 0;
    else if (ReloadCount - ClipCount > AmmoType.AmmoAmount)     // if we have no clips left
        return AmmoType.AmmoAmount;
    else
        return ReloadCount - ClipCount;
}

function int NumClips()
{
    if (ReloadCount == 0)  // if this weapon is not reloadable
        return 0;
    else if (AmmoType == None)
        return 0;
    else if (AmmoType.AmmoAmount == 0)  // if we are out of ammo
        return 0;
    else  // compute remaining clips
        return ((AmmoType.AmmoAmount-AmmoLeftInClip()) + (ReloadCount-1)) / ReloadCount;
}

function int AmmoAvailable(int ammoNum)
{
    local class<Ammunition> newAmmoClass;
    local Ammunition newAmmo;
    local Pawn P;

    P = Pawn(Owner);

    // sorry, only pawns can have weapons
    if (P == None)
        return 0;

    newAmmoClass = AmmoNames[ammoNum];

    if (newAmmoClass == None)
        return 0;

    newAmmo = Ammunition(P.FindInventoryType(newAmmoClass));

    if (newAmmo == None)
        return 0;

    return newAmmo.AmmoAmount;
}

function int NumAmmoTypesAvailable()
{
    local int i;

    for (i=0; i<ArrayCount(AmmoNames); i++)
        if (AmmoNames[i] == None)
            break;

    // to make Al fucking happy
    if (i == 0)
        i = 1;

    return i;
}

function class<DamageType> WeaponDamageType()
{
    local class<DamageType>       damageType;
    local Class<DeusExProjectile> projClass;

    projClass = Class<DeusExProjectile>(ProjectileClass);
    if (bInstantHit)
    {
        if (StunDuration > 0)
            damageType = class'DM_Stunned';
        else
            damageType = class'DM_Shot';

        if (AmmoType != None)
            if (AmmoType.IsA('AmmoSabot'))
                damageType = class'DM_Sabot';
    }
    else if (projClass != None)
        damageType = projClass.Default.damageType;
    else
        damageType = None;

    return (damageType);
}


//
// target tracking info
//
function Actor AcquireTarget()
{
    local vector StartTrace, EndTrace, HitLocation, HitNormal;
    local Actor hit;
    local Pawn p;

    p = Pawn(Owner);
    if (p == None)
        return None;

    StartTrace = p.Location;
    if (PlayerPawn(p) != None)
        EndTrace = p.Location + (AcquireTarget_DIST * Vector(p.GetViewRotation()));
    else
        EndTrace = p.Location + (AcquireTarget_DIST * Vector(p.Rotation));

    // adjust for eye height
    StartTrace.Z += p.BaseEyeHeight;
    EndTrace.Z += p.BaseEyeHeight;

    foreach TraceActors(class'Actor', hit, HitLocation, HitNormal, EndTrace, StartTrace)
    {
      if ((hit.bWorldGeometry) || (hit.IsA('DeusExMover')))
      {
          break;
      //    return hit;
      }

         if (!hit.bHidden && (hit.IsA('Decoration') || hit.IsA('Pawn')))
             return hit;
    }
    return None;
}

//
// Used to determine if we are near (and facing) a wall for placing LAMs, etc.
//
function bool NearWallCheck()
{
    local Vector StartTrace, EndTrace, HitLocation, HitNormal;
    local Actor HitActor;

    // Scripted pawns can't place LAMs
    if (ScriptedPawn(Owner) != None)
        return False;

    // trace out one foot in front of the pawn
    StartTrace = Owner.Location;
    EndTrace = StartTrace + Vector(Pawn(Owner).GetViewRotation()) * 32;

    StartTrace.Z += Pawn(Owner).BaseEyeHeight;
    EndTrace.Z += Pawn(Owner).BaseEyeHeight;

    HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace);
    if ((HitActor == Level) || ((HitActor != None) && HitActor.IsA('Mover')) || ((HitActor != None) && (HitActor.bWorldGeometry)))
    {                                                                            // DXR: Added check for StaticMeshes
        placeLocation = HitLocation;
        placeNormal = HitNormal;
        placeMover = Mover(HitActor);
        return True;
    }

    return False;
}

//
// used to place a grenade on the wall
//
function PlaceGrenade()
{
    local ThrownProjectile gren;
    local float dmgX;

    gren = ThrownProjectile(spawn(ProjectileClass, Owner,, placeLocation, Rotator(placeNormal)));
    if (gren != None)
    {
        gren.PlayAnim('Open');
        gren.PlaySound(gren.MiscSound, SLOT_Misc, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
        gren.SetPhysics(PHYS_None);
        gren.bBounce = False;
        gren.bProximityTriggered = True;
        gren.bStuck = True;
        if (placeMover != None)
            gren.SetBase(placeMover);

        // up the damage based on the skill
        // returned value from GetWeaponSkill is negative, so negate it to make it positive
        // dmgX value ranges from 1.0 to 2.4 (max demo skill and max target aug)
        dmgX = -2.0 * GetWeaponSkill() + 1.0;
        gren.Damage *= dmgX;

        // Update ammo count on object belt
        if (DeusExPlayer(Owner) != None)
            DeusExPlayer(Owner).UpdateBeltText(Self);
    }
}

// scope, laser, and targetting updates are done here
event Tick(float deltaTime)
{
    local vector loc;
    local rotator rot, recoilRot, ZoomRotation;
    local float beepspeed, recoil;
    local DeusExPlayer player;
    local Pawn pawn;

    player = DeusExPlayer(Owner);
    pawn = Pawn(Owner);

    Super.Tick(deltaTime);

    // don't do any of this if this weapon isn't currently in use
    if (pawn == None)
        return;

    if (pawn.Weapon != self)
        return;

    // all this should only happen IF you have ammo loaded
    if (ClipCount < ReloadCount)
    {
        // check for LAM or other placed mine placement
        if (bHandToHand && (ProjectileClass != None))
        {
            if (NearWallCheck())
            {
                if (!bNearWall || (GetAnimSequence() == 'Select'))
                {
                   if (HasAnim('PlaceBegin')) // DXR: Для метательных ножей
                       PlayAnim('PlaceBegin',, 0.1);

                    bNearWall = True;
                }
            }
            else
            {
                if (bNearWall)
                {
                   if (HasAnim('PlaceBegin'))  // DXR: Для метательных ножей
                       PlayAnim('PlaceEnd',, 0.1);
                    bNearWall = False;
                }
            }
        }

        if (bCanTrack)
        {
            Target = AcquireTarget();

            // change LockTime based on skill
            // -0.7 = max skill
            LockTime = FMax(default.LockTime + 3.0 * GetWeaponSkill(), 0.0);

            // calculate the range
            if (Target != None)
                TargetRange = Abs(VSize(Target.Location - Location));

            // update our timers
            LockTimer += deltaTime;
            SoundTimer += deltaTime;

            // check target and range info to see what our mode is
            if ((Target == None) || IsInState('Reload'))
                LockMode = LOCK_None;
            else if (!Target.IsA('Pawn'))
                LockMode = LOCK_Invalid;
            else
            {
                if (TargetRange > MaxRange)
                    LockMode = LOCK_Range;
                else
                {
                    if (LockTimer >= LockTime)
                        LockMode = LOCK_Locked;
                    else
                        LockMode = LOCK_Acquire;
                }
            }

            // act on the lock mode
            switch (LockMode)
            {
                case LOCK_None:
                    TargetMessage = msgNone;
                    LockTimer = 0;
                    break;

                case LOCK_Invalid:
                    TargetMessage = msgLockInvalid;
                    LockTimer = 0;
                    break;

                case LOCK_Range:
                    TargetMessage = msgLockRange @ Int(TargetRange/16) @ msgRangeUnit;
                    LockTimer = 0;
                    break;

                case LOCK_Acquire:
                    TargetMessage = msgLockAcquire @ Left(String(LockTime-LockTimer), 4) @ msgTimeUnit;
                    beepspeed = FClamp((LockTime - LockTimer) / Default.LockTime, 0.2, 1.0);
                    if (SoundTimer > beepspeed)
                    {
                        Owner.PlaySound(TrackingSound, SLOT_Misc);
                        SoundTimer = 0;
                    }
                    break;

                case LOCK_Locked:
                    TargetMessage = msgLockLocked @ Int(TargetRange/16) @ msgRangeUnit;
                    if (SoundTimer > 0.1)
                    {
                        Owner.PlaySound(LockedSound, SLOT_Misc);
                        SoundTimer = 0;
                    }
                    break;
            }
        }
    }
    else
    {
        LockMode = LOCK_None;
        TargetMessage = msgNone;
        LockTimer = 0;
    }

    currentAccuracy = CalculateAccuracy();

    if (player != None)
    {
        // reduce the recoil based on skill
        recoil = recoilStrength + GetWeaponSkill() * 2.0;
        if (recoil < 0.0)
            recoil = 0.0;

        // simulate recoil while firing
        if (bFiring && IsAnimating() && (GetAnimSequence() == 'Shoot') && (recoil > 0.0))
        {
              recoilRot = player.GetViewRotation();
              recoilRot.Yaw = player.GetViewRotation().Yaw + deltaTime * (Rand(4096) - 2048) * recoil;
              recoilRot.Pitch = player.GetViewRotation().Pitch + deltaTime * (Rand(4096) + 4096) * recoil;
              player.SetViewRotation(recoilRot);
              if ((player.GetViewRotation().Pitch > 16384) && (player.GetViewRotation().Pitch < 32768))
              {
                  recoilRot.Pitch = 16384;
                  player.SetViewRotation(recoilRot);
              }
//            player.ViewRotation.Yaw += deltaTime * (Rand(4096) - 2048) * recoil;
//            player.ViewRotation.Pitch += deltaTime * (Rand(4096) + 4096) * recoil;
//            if ((player.ViewRotation.Pitch > 16384) && (player.ViewRotation.Pitch < 32768))
//                player.ViewRotation.Pitch = 16384;
        }
    }

    // if were standing still, increase the timer
    if (VSize(Owner.Velocity) < 10)
        standingTimer += deltaTime;
    else    // otherwise, decrease it slowly based on velocity
        standingTimer = FMax(0, standingTimer - 0.03*deltaTime*VSize(Owner.Velocity));

    if (bLasing || bZoomed)
    {
        // shake our view to simulate poor aiming
        if (ShakeTimer > 0.25)
        {
            ShakeYaw = currentAccuracy * (Rand(4096) - 2048);
            ShakePitch = currentAccuracy * (Rand(4096) - 2048);
            ShakeTimer -= 0.25;
        }

        ShakeTimer += deltaTime;

        if (bLasing && (Emitter != None))
        {
            loc = Owner.Location;
            loc.Z += Pawn(Owner).BaseEyeHeight;

            // add a little random jitter - looks cool!
            rot = Pawn(Owner).GetViewRotation();
            rot.Yaw += Rand(5) - 2;
            rot.Pitch += Rand(5) - 2;

            Emitter.SetLocation(loc);
            Emitter.SetRotation(rot);
        }

        if ((player != None) && bZoomed)
        {
              ZoomRotation = player.GetViewRotation();
              ZoomRotation.Yaw = player.GetViewRotation().Yaw + deltaTime * ShakeYaw;
              ZoomRotation.Pitch = player.GetViewRotation().Pitch + deltaTime * ShakePitch;
              player.SetViewRotation(ZoomRotation);
//            player.ViewRotation.Yaw += deltaTime * ShakeYaw;
//            player.ViewRotation.Pitch += deltaTime * ShakePitch;
        }
    }
}

//
// scope functions for weapons which have them
//

function ScopeOn()
{
    if (bHasScope && !bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
    {
        // Show the Scope View
        bZoomed = True;
//        RefreshScopeDisplay(DeusExPlayer(Owner), False);
    }
}

function ScopeOff()
{
    if (bHasScope && bZoomed && (Owner != None) && Owner.IsA('DeusExPlayer'))
    {
        // Hide the Scope View
//        DeusExRootWindow(DeusExPlayer(Owner).rootWindow).scopeView.DeactivateView();
        bZoomed = False;
        DeusExPlayerController(Instigator.Controller).ResetFOV();
    }
}

function ScopeToggle()
{
    if (IsInState('Idle'))
    {
        if (bHasScope && (Owner != None) && Owner.IsA('DeusExPlayer'))
        {
            if (bZoomed)
                ScopeOff();
            else
                ScopeOn();
        }
    }
}

function RefreshScopeDisplay(DeusExPlayer player, bool bInstant)
{
    if (bZoomed && (player != None))
    {
        // Show the Scope View
//        DeusExRootWindow(player.rootWindow).scopeView.ActivateView(ScopeFOV, False, bInstant);
    }
}

// laser functions for weapons which have them
function LaserOn()
{
    if (bHasLaser && !bLasing)
    {
        // if we don't have an emitter, then spawn one
        // otherwise, just turn it on
        if (Emitter == None)
        {
            Emitter = Spawn(class'EM_LaserBeam', Self, , Location, Pawn(Owner).GetViewRotation());
            if (Emitter != None)
            {
                Emitter.SetHiddenBeam(True);
                Emitter.AmbientSound = None;
                Emitter.TurnOn();
            }
        }
        else
            Emitter.TurnOn();

        bLasing = True;
    }
}

function LaserOff()
{
    if (bHasLaser && bLasing)
    {
        if (Emitter != None)
            Emitter.TurnOff();

        bLasing = False;
    }
}

function LaserToggle()
{
    if (IsInState('Idle'))
    {
        if (bHasLaser)
        {
            if (bLasing)
                LaserOff();
            else
                LaserOn();
        }
    }
}

//
// called from the MESH NOTIFY
//
function SwapMuzzleFlashTexture()
{
/*    if (FRand() < 0.5)
        Skins[2] = Texture'FlatFXTex34';
    else
        Skins[2] = Texture'FlatFXTex37';

    MuzzleFlashLight();
    SetTimer(0.1, False);*/
}

function EraseMuzzleFlashTexture()
{
//    Skins[2] = None;
}

event Timer()
{
//    EraseMuzzleFlashTexture();
}

function MuzzleFlashLight()
{
    local Vector offset, X, Y, Z;

    if (!bHasMuzzleFlash)
        return;

    if ((flash != None) && !flash.bDeleteMe)
        flash.LifeSpan = flash.Default.LifeSpan;
    else
    {
        GetAxes(Pawn(Owner).GetViewRotation(),X,Y,Z);
        offset = Owner.Location;
        offset += X * Owner.CollisionRadius * 2;
        flash = spawn(class'MuzzleFlash',,, offset);
        if (flash != None)
            flash.SetBase(Owner);
    }
}

// HandToHandAttack
// called by the MESH NOTIFY for the H2H weapons
function HandToHandAttack()
{
    if ((bOwnerWillNotify) || (Owner.IsInState('Dying'))) // DXR: Added exclusion for state dying 
         return;

    if (ScriptedPawn(Owner) != None)
        ScriptedPawn(Owner).SetAttackAngle();

    if (bInstantHit)
        TraceFire(0.0);
    else
        ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

// OwnerHandToHandAttack
// called by the MESH NOTIFY for this weapon's owner
function OwnerHandToHandAttack()
{
    if (!bOwnerWillNotify)
        return;

    if (ScriptedPawn(Owner) != None)
        ScriptedPawn(Owner).SetAttackAngle();

    if (bInstantHit)
        TraceFire(0.0);
    else
        ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
}

//
// from Weapon.uc - modified so we can have the accuracy in TraceFire
//
function Fire(float Value)
{
    // check for surrounding environment
    if ((EnviroEffective == ENVEFF_Air) || (EnviroEffective == ENVEFF_Vacuum) || (EnviroEffective == ENVEFF_AirVacuum))
    {
        if (PhysicsVolume.bWaterVolume)
        {
            if (Pawn(Owner) != None)
            {
                Pawn(Owner).ClientMessage(msgNotWorking);
                if (!bHandToHand)
                    Owner.PlaySound(Misc1Sound, SLOT_Misc,,, 1024);     // play dry fire sound
            }
            GotoState('Idle');
            return;
        }
    }

    if (bHandToHand)
    {
        if (ReloadCount > 0)
            AmmoType.UseAmmo(1);

        bReadyToFire = False;
        GotoState('NormalFire');
        bPointing=True;
        PlayFiring();
    }
    // if we are a single-use weapon, then our ReloadCount is 0 and we don't use ammo
    else if ((ClipCount < ReloadCount) || (ReloadCount == 0))
    {
        if ((ReloadCount == 0) || AmmoType.UseAmmo(1))
        {
            ClipCount++;
            bFiring = True;
            bReadyToFire = False;
            GotoState('NormalFire');
            if (PlayerPawn(Owner) != None)        // shake us based on accuracy
                Level.GetLocalPlayerController().WeaponShakeView(currentAccuracy * ShakeRotMag + ShakeRotMag,
                                                       ShakeRotRate,
                                                       ShakeRotTime,
                                                       currentAccuracy * ShakeOffsetMag,
                                                       ShakeOffsetRate,
                                                       ShakeOffsetTime);
                //PlayerPawn(Owner).ShakeView(ShakeTime, currentAccuracy * ShakeMag + ShakeMag, currentAccuracy * ShakeVert);
            bPointing=True;
            if (bInstantHit)
                TraceFire(currentAccuracy);
            else
                ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
            PlayFiring();
            if (Owner.bHidden)
                CheckVisibility();
        }
        else
            Owner.PlaySound(Misc1Sound, SLOT_Misc,,, 1024);     // play dry fire sound
    }
    else
        Owner.PlaySound(Misc1Sound, SLOT_Misc,,, 1024);     // play dry fire sound

    // Update ammo count on object belt
    if (DeusExPlayer(Owner) != None)
        DeusExPlayer(Owner).UpdateBeltText(Self);
}

function CheckVisibility()
{
    local Pawn PawnOwner;

    PawnOwner = Pawn(Owner);
    if(Owner.bHidden && (PawnOwner.Health > 0) && (PawnOwner.Visibility < PawnOwner.Default.Visibility))
    {
        Owner.bHidden = false;
        PawnOwner.Visibility = PawnOwner.Default.Visibility;
    }
}

function ReadyToFire()
{
    if (!bReadyToFire)
        bReadyToFire = True;
}

function PlayPostSelect()
{
    // let's not zero the ammo count anymore - you must always reload
//  ClipCount = 0;      
}

function PlayFiring()
{
    local float rnd;
    local Name anim;

    anim = 'Shoot';

    if (bAutomatic)
        LoopAnim(anim,, 0.1);
    else
    {
        if (bHandToHand)
        {
            rnd = FRand();
            if (rnd < 0.33)
                anim = 'Attack';
            else if (rnd < 0.66)
                anim = 'Attack2';
            else
                anim = 'Attack3';
        }
        PlayAnim(anim,,0.1);
    }

    IncrementFlashCount(0); // DXR: Для эффектов в 3drPersonActor
    PlayFireSound();
}


function PlayFireSound()
{
    if (bHasSilencer)
        Owner.PlaySound(/*Sound'StealthPistolFire'*/GetSilencedSound(), SLOT_Misc,,, 2048);
    else
        Owner.PlaySound(GetFireSound(), SLOT_None,,false, 2048, 1.0, false);
//        Owner.PlaySound(/*FireSound*/GetFireSound(), SLOT_Misc,,, 2048, 1.0, );
}

function PlayIdleAnim()
{
    local float rnd;

    if (bZoomed || bNearWall)
        return;

    rnd = FRand();

    if (rnd < 0.1)
        PlayAnim('Idle1',,0.1);
    else if (rnd < 0.2)
        PlayAnim('Idle2',,0.1);
    else if (rnd < 0.3)
        PlayAnim('Idle3',,0.1);
}

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
//    spawn(class'BloodSpurt',,,HitLocation+HitNormal);
    spawn(class'EM_BloodHit',,,HitLocation+HitNormal);
    spawn(class'BloodDrop',,,HitLocation+HitNormal);

    if (FRand() < 0.5)
        spawn(class'BloodDrop',,,HitLocation+HitNormal);
}

function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other, float Damage)
{
    local EM_NeutralHit puff;

    if (Other == None)
    return;

    if (bPenetrating && !bHandToHand && !Other.IsA('DeusExDecoration'))
    {
        if (FRand() < 0.5)
        {
            puff = spawn(class'EM_NeutralHit',,,HitLocation+HitNormal, Rotator(HitNormal));
        }
    }

    if (bHandToHand)
    {
        // if we are hand to hand, play an appropriate sound
        if (Other.IsA('DeusExDecoration'))
            Owner.PlaySound(GetSoftHitSound()/* Misc3Sound*/, SLOT_Misc,,, 1024);
        else if (Other.IsA('Pawn'))
            Owner.PlaySound(GetFleshHitSound()/*Misc1Sound*/, SLOT_Misc,,, 1024);
        else if (Other.IsA('BreakableGlass'))
            Owner.PlaySound(sound'GlassHit1', SLOT_Misc,,, 1024);
        else if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
            Owner.PlaySound(sound'BulletProofHit', SLOT_Misc,,, 1024);
        else
            Owner.PlaySound(GetHardHitSound()/*Misc2Sound*/, SLOT_Misc,,, 1024);
    }
    else if (bInstantHit && bPenetrating)
    {
//        hole = spawn(class'BulletHole', Other,, HitLocation, Rotator(-HitNormal));
    }

    // draw the correct damage art for what we hit
    /*if (bPenetrating || bHandToHand)
    {
        if (Other.IsA('DeusExMover'))
        {
            mov = DeusExMover(Other);
            if ((mov != None) && (hole == None))
                hole = spawn(class'BulletHole', Other,, HitLocation, Rotator(-HitNormal));

            if (hole != None)
            {
                if (mov.bBreakable && (mov.minDamageThreshold <= Damage))
                {
                    // don't draw damage art on destroyed movers
                    if (mov.bDestroyed)
                        hole.Destroy();
                    else if (mov.FragmentClass == class'GlassFragment')
                    {
                        // glass hole
                        if (FRand() < 0.5)
                            hole.ProjTexture = Texture'FlatFXTex29';
                        else
                            hole.ProjTexture = Texture'FlatFXTex30';

                        hole.SetDrawScale(0.1);
                        //hole.ReattachDecal();
                    }
                    else
                    {
                        // non-glass crack
                        if (FRand() < 0.5)
                            hole.ProjTexture = Texture'FlatFXTex7';
                        else
                            hole.ProjTexture = Texture'FlatFXTex8';

                        hole.SetDrawScale(0.4);
                        //hole.ReattachDecal();
                    }
                }
                else
                {
                    if (!bPenetrating || bHandToHand)
                        hole.Destroy();
                }
            }
        }
    }*/
}

function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
    local vector EndTrace, StartTrace;
    local actor aTarget;
    local int texFlags;
    local name texName, texGroup;

    StartTrace = HitLocation + HitNormal*16;        // make sure we start far enough out
    EndTrace = HitLocation - HitNormal;

    foreach class'ActorManager'.static.TraceTexture(self,class'Actor', aTarget, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
        if ((aTarget == Level) || aTarget.IsA('Mover'))
            break;

    return texGroup;
}

function GenerateBullet()
{
    if (AmmoType.UseAmmo(1))
    {
        if (bInstantHit)
            TraceFire(currentAccuracy);
        else
            ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget);
        ClipCount++;
    }
    else
        GotoState('FinishFire');
}


//
// we have to use an actor to play the hit sound at the correct location
//
function PlayHitSound(actor destActor, Actor hitActor)
{
    local sound snd;

    // play a different ricochet sound if the object isn't damaged by normal bullets
    if (hitActor != None) 
    {
        if (hitActor.IsA('DeusExDecoration') && (DeusExDecoration(hitActor).minDamageThreshold > 10))
            snd = sound'ArmorRicochet';
        else if (hitActor.IsA('Robot'))
            snd = sound'ArmorRicochet';
        else if(hitActor != Level && !hitActor.IsA('DeusExMover') && !hitActor.bWorldGeometry) //Lork: Prevents sparks and ricochet sounds on normal decorations // DXR: And StaticMeshes!
        {
            snd = None;
            destActor.bHidden = True;
        }
    }
    if (destActor != None)
        destActor.PlaySound(snd, SLOT_None,,, 1024, 1.1 - 0.2*FRand());
}

function PlayLandingSound()
{
    if (LandSound != None)
    {
        if (Velocity.Z <= -200)
        {
            PlaySound(GetLandedSound(), SLOT_Misc, TransientSoundVolume,, 768);
            class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, TransientSoundVolume, 768);
        }
    }
}

function GetWeaponRanges(out float wMinRange,out float wMaxAccurateRange,out float wMaxRange)
{
    local class<DeusExProjectile> dxProjectileClass;

    dxProjectileClass = Class<DeusExProjectile>(ProjectileClass);
    if (dxProjectileClass != None)
    {
        wMinRange         = dxProjectileClass.Default.blastRadius;
        wMaxAccurateRange = dxProjectileClass.Default.AccurateRange;
        wMaxRange         = dxProjectileClass.Default.MaxRange;
    }
    else
    {
        wMinRange         = 0;
        wMaxAccurateRange = AccurateRange;
        wMaxRange         = MaxRange;
    }
}

//
// computes the start position of a projectile/trace
//
function Vector ComputeProjectileStart(Vector X, Vector Y, Vector Z)
{
    local Vector Start;

    // if we are instant-hit, non-projectile, then don't offset our starting point by PlayerViewOffset
    if (bInstantHit)
        Start = Owner.Location + Pawn(Owner).BaseEyeHeight * vect(0,0,1);// - Vector(Pawn(Owner).ViewRotation)*(0.9*Pawn(Owner).CollisionRadius);
    else
        Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z;

    return Start;
}

//
// Modified to work better with scripted pawns
//
function vector CalcDrawOffset()
{
    local vector        DrawOffset, WeaponBob;
    local ScriptedPawn  SPOwner;
    local Pawn          PawnOwner;

    SPOwner = ScriptedPawn(Owner);
    if (SPOwner != None)
    {
        DrawOffset = ((0.9/SPOwner.Controller.FOVAngle * PlayerViewOffset) >> SPOwner.GetViewRotation());
        DrawOffset += (SPOwner.BaseEyeHeight * vect(0,0,1));
    }
    else
    {
        // copied from Engine.Inventory to not be FOVAngle dependent
        PawnOwner = Pawn(Owner);
        DrawOffset = ((0.9/PawnOwner.Controller.default.FOVAngle * PlayerViewOffset) >> PawnOwner.GetViewRotation());

        DrawOffset += (PawnOwner.EyeHeight * vect(0,0,1));
        WeaponBob = BobDamping * PawnOwner.WalkBob;
        WeaponBob.Z = (0.45 + 0.55 * BobDamping) * PawnOwner.WalkBob.Z;
        DrawOffset += WeaponBob;
    }

    return DrawOffset;
}

function GetAIVolume(out float volume, out float radius)
{
    volume = 0;
    radius = 0;

    if (!bHasSilencer && !bHandToHand)
    {
        volume = NoiseLevel*Pawn(Owner).SoundDampening;
        radius = volume * 800.0;
    }
}

//
// copied from Weapon.uc
//
function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn)
{
    local Vector Start, X, Y, Z;
    local float mult;
    local DeusExProjectile proj;
    local float volume, radius;
    local int i, numProj;

    // AugCombat increases our speed (distance) if hand to hand
    mult = 1.0;
    if (bHandToHand && (DeusExPlayer(Owner) != None))
    {
        mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
        if (mult == -1.0)
            mult = 1.0;
        ProjSpeed *= mult;
    }

    // skill also affects our damage
    // GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
    mult += -2.0 * GetWeaponSkill();

    // make noise if we are not silenced
    if (!bHasSilencer && !bHandToHand)
    {
        GetAIVolume(volume, radius);
        class'EventManager'.static.AISendEvent(Owner,'WeaponFire', EAITYPE_Audio, volume, radius);
        class'EventManager'.static.AISendEvent(Owner,'LoudNoise', EAITYPE_Audio, volume, radius);
        if (!Owner.IsA('PlayerPawn'))
            class'EventManager'.static.AISendEvent(Owner,'Distress', EAITYPE_Audio, volume, radius);
    }

    // should we shoot multiple projectiles in a spread?
    if (AreaOfEffect == AOE_Cone)
        numProj = 3;
    else
        numProj = 1;

    GetAxes(Pawn(owner).GetViewRotation(),X,Y,Z);
    Start = ComputeProjectileStart(X, Y, Z);

    for (i=0; i<numProj; i++)
    {
        AdjustedAim = pawn(owner).AdjustAim(ProjSpeed, Start, AimError, True, bWarn);
        AdjustedAim.Yaw += currentAccuracy * (Rand(1024) - 512);
        AdjustedAim.Pitch += currentAccuracy * (Rand(1024) - 512);
        proj = DeusExProjectile(Spawn(ProjClass, Owner,, Start, AdjustedAim));
        if (proj != None)
        {
            // AugCombat increases our damage as well
            proj.Damage *= mult;

            // send the targetting information to the projectile
            if (bCanTrack && (Target != None) && (LockMode == LOCK_Locked))
            {
                proj.Target = Target;
                proj.bTracking = True;
            }
        }
    }

    return proj;
}

//
// copied from Weapon.uc so we can add range information
//
function TraceFire(float Accuracy)
{
    local vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
    local Rotator rot;
    local actor Other;
    local float dist, alpha, degrade;
    local int i, numSlugs;
    local float volume, radius;

    // make noise if we are not silenced
    if (!bHasSilencer && !bHandToHand)
    {
        GetAIVolume(volume, radius);
        class'EventManager'.static.AISendEvent(Owner,'WeaponFire', EAITYPE_Audio, volume, radius);
        class'EventManager'.static.AISendEvent(Owner,'LoudNoise', EAITYPE_Audio, volume, radius);
        if (!Owner.IsA('PlayerPawn'))
            class'EventManager'.static.AISendEvent(Owner,'Distress', EAITYPE_Audio, volume, radius);
    }

    GetAxes(Pawn(owner).GetViewRotation(),X,Y,Z);
    StartTrace = ComputeProjectileStart(X, Y, Z);
    AdjustedAim = pawn(owner).AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);

    // check to see if we are a shotgun-type weapon
    if (AreaOfEffect == AOE_Cone)
        numSlugs = 5;
    else
        numSlugs = 1;

    // if there is a scope, but the player isn't using it, decrease the accuracy
    // so there is an advantage to using the scope
    if (bHasScope && !bZoomed)
        Accuracy += 0.2;
    // if the laser sight is on, make this shot dead on
    // also, if the scope is on, zero the accuracy so the shake makes the shot inaccurate
    else if (bLasing || bZoomed)
        Accuracy = 0.0;

    for (i=0; i<numSlugs; i++)
    {
        EndTrace = StartTrace + Accuracy * (FRand()-0.5)*Y*1000 + Accuracy * (FRand()-0.5)*Z*1000;

        if (DXRWeaponAttachment(ThirdPersonActor) != None)
            DXRWeaponAttachment(ThirdPersonActor).EndTraceExtra = EndTrace;

        if (Owner.IsA('DeusExPlayer') && MaxRange >= 1024)
        {
            EndTrace += 4000.0 * vector(AdjustedAim);  //RSD: range no longer influences player accuracy (took GMDX pistol range as baseline) 
            EndTrace = (FMax(1024.0, MaxRange)*Normal(EndTrace-StartTrace)) + StartTrace;  //RSD: Extend length of vector to max range
        }
        else 
            EndTrace += (FMax(1024.0, MaxRange) * vector(AdjustedAim)); //RSD: If short range weapon or not a DeusExPlayer, use the old routine

            Other = Pawn(Owner).TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);

        // randomly draw a tracer for relevant ammo types
        // don't draw tracers if we're zoomed in with a scope - looks stupid
        if (!bZoomed && (numSlugs == 1) && (FRand() < 0.5))
        {
            if ((AmmoName == class'Ammo10mm') || (AmmoName == class'Ammo3006a') || (AmmoName == class'Ammo762mm'))
            {
                if (VSize(HitLocation - StartTrace) > 250)
                {
                    rot = Rotator(EndTrace - StartTrace);
                    Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);
                }
            }
        }

        // check our range
        dist = Abs(VSize(HitLocation - Owner.Location));

        if (dist <= AccurateRange)      // we hit just fine
        {
            ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
        }
        else if (dist <= MaxRange)
        {
            // simulate gravity by lowering the bullet's hit point
            // based on the owner's distance from the ground
            alpha = (dist - AccurateRange) / (MaxRange - AccurateRange);
            degrade = 0.5 * Square(alpha);
            HitLocation.Z += degrade * (Owner.Location.Z - Owner.CollisionHeight);
            ProcessTraceHit(Other, HitLocation, HitNormal, vector(AdjustedAim),Y,Z);
        }

    }
    // otherwise we don't hit the target at all
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    local float        mult;
    local class<DamageType> damageType;
    local Spark        spark;
    local DeusExPlayer dxPlayer;

    if (Other != None)
    {
        // AugCombat increases our damage if hand to hand
        mult = 1.0;
        if (bHandToHand && (DeusExPlayer(Owner) != None))
        {
            mult = DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
            if (mult == -1.0)
                mult = 1.0;
        }

        // skill also affects our damage
        // GetWeaponSkill returns 0.0 to -0.7 (max skill/aug)
        mult += -2.0 * GetWeaponSkill();

        // Determine damage type
        damageType = WeaponDamageType();

        // spawn a little spark and make a ricochet sound if we hit something
        if (Other != None)
        {
            if (/*bHandToHand && */bInstantHit/* && bPenetrating*/) //if (!bHandToHand && bInstantHit && bPenetrating)
            {
                spark = spawn(class'Spark',,,HitLocation+HitNormal, Rotator(HitNormal));
                if (spark != None)
                {
                    spark.SetDrawScale(0.05);
                    PlayHitSound(spark, Other);
                }
            }
        }

        if (Other != None)
        {
            if (Other.bOwned)
            {
                dxPlayer = DeusExPlayer(Owner);
                if (dxPlayer != None)
                    class'EventManager'.static.AISendEvent(dxPlayer,'Futz', EAITYPE_Visual);
            }
        }

        if ((Other == Level) || (Other.IsA('Mover')) || (Other.bWorldGeometry)) // DXR: Добавлена проверка на статикмеши
        {
            Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
            SpawnEffects(HitLocation, HitNormal, Other, HitDamage * mult);
        }
        else if ((Other != self) && (Other != Owner))
        {
            Other.TakeDamage(HitDamage * mult, Pawn(Owner), HitLocation, 1000.0*X, damageType);
            if (bHandToHand)
                SpawnEffects(HitLocation, HitNormal, Other, HitDamage * mult);

            if (bPenetrating && Other.IsA('Pawn') && !Other.IsA('Robot'))
                SpawnBlood(HitLocation, HitNormal);
        }
    }
}

// Finish a firing sequence (ripped off and modified from Engine\Weapon.uc)
function Finish()
{
    if (bHasMuzzleFlash)
        EraseMuzzleFlashTexture();

    if (bChangeWeapon)
    {
        GotoState('DownWeapon');
        return;
    }

    if (Pawn(Owner) == None)
    {
        GotoState('Idle');
        return;
    }

    if (PlayerPawn(Owner) == None)
    {
        //bFireMem = false;
        //bAltFireMem = false;
        if (((AmmoType==None) || (AmmoType.AmmoAmount<=0)) && ReloadCount!=0)
        {
            Pawn(Owner).Controller.StopFiring();
            Pawn(Owner).SwitchToBestWeapon();
        }
        else if ((Pawn(Owner).Controller.bFire != 0) && (FRand() < RefireRate))
            Global.Fire(0);
        else if ((Pawn(Owner).Controller.bAltFire != 0) && (FRand() < AltRefireRate))
            Global.AltFire(0);  
        else 
        {
            Pawn(Owner).Controller.StopFiring();
            GotoState('Idle');
        }
        return;
    }
    if (((AmmoType==None) || (AmmoType.AmmoAmount<=0)) || (Pawn(Owner).Weapon != self))
        GotoState('Idle');
    else if ( /*bFireMem ||*/ Pawn(Owner).Controller.bFire!=0)
        Global.Fire(0);
    else if ( /*bAltFireMem ||*/ Pawn(Owner).Controller.bAltFire!=0)
        Global.AltFire(0);
    else 
        GotoState('Idle');
}

// ----------------------------------------------------------------------
// UpdateInfo()
// ----------------------------------------------------------------------
function bool UpdateInfo(Object winObject);

// ----------------------------------------------------------------------
// UpdateAmmoInfo()
// ----------------------------------------------------------------------
function UpdateAmmoInfo(Object winObject, class<DeusExAmmo> ammoClass);


final function String BuildPercentString(Float value)
{
    local string str;

    str = String(Int(Abs(value * 100.0)));
    if (value < 0.0)
        str = "-" $ str;
    else
        str = "+" $ str;

    return ("(" $ str $ "%)");
}

function String FormatFloatString(float value, float precision)
{
    local string str;

    if (precision == 0.0)
        return "ERR";

    // build integer part
    str = String(Int(value));

    // build decimal part
    if (precision < 1.0)
    {
        value -= Int(value);
        str = str $ "." $ String(Int((0.5 * precision) + value * (1.0 / precision)));
    }

    return str;
}

function String CR()
{
    return Chr(13) $ Chr(10);
}

function bool HasReloadMod()
{
    return (ModReloadTime != 0.0);
}

function bool HasMaxReloadMod()
{
    return (ModReloadTime == -0.5);
}

function bool HasClipMod()
{
    return (ModReloadCount != 0.0);
}

function bool HasMaxClipMod()
{
    return (ModReloadCount == 0.5);
}

function bool HasRangeMod()
{
    return (ModAccurateRange != 0.0);
}

function bool HasMaxRangeMod()
{
    return (ModAccurateRange == 0.5);
}

function bool HasAccuracyMod()
{
    return (ModBaseAccuracy != 0.0);
}

function bool HasMaxAccuracyMod()
{
    return (ModBaseAccuracy == 0.5);
}

function bool HasRecoilMod()
{
    return (ModRecoilStrength != 0.0);
}

function bool HasMaxRecoilMod()
{
    return (ModRecoilStrength == -0.5);
}

//
// weapon states
//

state NormalFire
{
    function AnimEnd(int Channel)
    {
        if (bAutomatic)
        {
            if ((Pawn(Owner).Controller.bFire != 0) && (AmmoType.AmmoAmount > 0))
            {
                if (PlayerPawn(Owner) != None)
                    Global.Fire(0);
                else 
                    GotoState('FinishFire');
            }
            else 
                GotoState('FinishFire');
        }
        else
        {
            // if we are a thrown weapon and we run out of ammo, destroy the weapon
            if (bHandToHand && (ReloadCount > 0) && (AmmoType.AmmoAmount <= 0))
                Destroy();
        }
    }

    function float GetShotTime()
    {
        local float mult;

        if (ScriptedPawn(Owner) != None)
            return ShotTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
        else
        {
            // AugCombat decreases shot time
            mult = 1.0;
            if (bHandToHand && DeusExPlayer(Owner) != None)
            {
                mult = 1.0 / DeusExPlayer(Owner).AugmentationSystem.GetAugLevelValue(class'AugCombat');
                if (mult == -1.0)
                    mult = 1.0;
            }
            return (ShotTime * mult);
        }
    }

Begin:
    if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
    {
        if (!bAutomatic)
        {
            bFiring = False;
            FinishAnim();
        }
        if (Owner != None)
        {
            if (Owner.IsA('DeusExPlayer'))
            {
                bFiring = False;

                // should we autoreload?
                if (DeusExPlayer(Owner).bAutoReload)
                {
                    // auto switch ammo if we're out of ammo and
                    // we're not using the primary ammo
                    if ((AmmoType.AmmoAmount == 0) && (AmmoName != AmmoNames[0]))
                        CycleAmmo();

                        ReloadAmmo();

                }
                else
                {
                    if (bHasMuzzleFlash)
                        EraseMuzzleFlashTexture();
                    GotoState('Idle'); 
                }
            }
            else if (Owner.IsA('ScriptedPawn'))
            {
                bFiring = False;
                ReloadAmmo();
            }
        }
        else
        {
            if (bHasMuzzleFlash)
                EraseMuzzleFlashTexture();
            GotoState('Idle');
        }
    }

    Sleep(GetShotTime());
    if (bAutomatic)
    {
        GenerateBullet();
        Sleep(holdShotTime);
        Goto('Begin');
    }
    bFiring = False;
    FinishAnim();

    // if ReloadCount is 0 and we're not hand to hand, then this is a
    // single-use weapon so destroy it after firing once
    if ((ReloadCount == 0) && !bHandToHand)
    {
        if (DeusExPlayer(Owner) != None)
            DeusExPlayer(Owner).RemoveItemFromSlot(Self);   // remove it from the inventory grid

        DropUsedWeapon(); // DXR: Бросить использованное одноразовое оружие.
        Destroy();
    }

    ReadyToFire();

Done:
    bFiring = False;
    Finish();
}

state FinishFire
{
Begin:
    bFiring = False;
    Finish();
}

state Pickup
{
    function BeginState()
    {
        // alert NPCs that I'm putting away my gun
        class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);

        Super.BeginState();
    }
}

state Reload
{
ignores Fire, AltFire;

    function float GetReloadTime()
    {
        local float val;

        val = ReloadTime;

        if (ScriptedPawn(Owner) != None)
        {
            val = ReloadTime * (ScriptedPawn(Owner).BaseAccuracy*2+1);
        }
        else if (DeusExPlayer(Owner) != None)
        {
            // check for skill use if we are the player
            val = GetWeaponSkill();
            val = ReloadTime + (val*ReloadTime);
        }

        return val;
    }

    function NotifyOwner(bool bStart)
    {
        local DeusExPlayer player;
        local ScriptedPawn pawn;

        player = DeusExPlayer(Owner);
        pawn   = ScriptedPawn(Owner);

        if (player != None)
        {
            if (bStart)
                player.Reloading(self, GetReloadTime()+(1.0/GetAnimRate()));
            else
                player.DoneReloading(self);
        }
        else if (pawn != None)
        {
            if (bStart)
                DXRAIController(pawn.Controller).Reloading(self, GetReloadTime()+(1.0/GetAnimRate()));
            else
                DXRAIController(pawn.Controller).DoneReloading(self);
        }
    }

Begin:
    FinishAnim();

    bWasZoomed = bZoomed;
    if (bWasZoomed)
        ScopeOff();

    // only reload if we have ammo left
    if (AmmoType.AmmoAmount > 0)
    {
        Owner.PlaySound(GetReloadBeginSound()/*CockingSound*/, SLOT_Misc,,, 1024);       // CockingSound is reloadbegin
        PlayAnim('ReloadBegin');
        NotifyOwner(True);
        FinishAnim();
        LoopAnim('Reload');
        Sleep(GetReloadTime());
        Owner.PlaySound(GetReloadEndSound()/*ReloadEndSound*/, SLOT_Misc,,, 1024);       // AltFireSound is reloadend
        PlayAnim('ReloadEnd');
        FinishAnim();
        NotifyOwner(False);
    }

    if (bWasZoomed)
        ScopeOn();

    // don't actually complete the reload until AFTER the anims/sleep have finished
    ClipCount = 0;
    GotoState('Idle');
}

state Idle
{
    function bool PutDown()
    {
        // alert NPCs that I'm putting away my gun
        class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);
        return Super.PutDown();
    }

    function AnimEnd(int channel)
    {
        
    }

    event Timer()
    {
        PlayIdleAnim();
    }

Begin:
    ReadyToFire();
    if (!bNearWall)
        PlayAnim('Idle1',,0.1);
    SetTimer(3.0, True);
}


state Active
{
    function bool PutDown()
    {
        // alert NPCs that I'm putting away my gun
        class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);
        return Super.PutDown();
    }

Begin:
    if (!Owner.IsA('ScriptedPawn'))
        FinishAnim();
    if (bChangeWeapon)
        GotoState('DownWeapon');
    bWeaponUp = True;
    PlayPostSelect();
    if (!Owner.IsA('ScriptedPawn'))
        FinishAnim();

    // reload the weapon if it's empty and autoreload is true
    if ((ClipCount >= ReloadCount) && (ReloadCount != 0))
        if (Owner.IsA('ScriptedPawn') || ((DeusExPlayer(Owner) != None) && DeusExPlayer(Owner).bAutoReload))
            ReloadAmmo();

    Finish();
}


state DownWeapon
{
ignores Fire, AltFire;

    function bool PutDown()
    {
        // alert NPCs that I'm putting away my gun
        class'EventManager'.static.AIEndEvent(self,'WeaponDrawn', EAITYPE_Visual);
        return Super.PutDown();
    }

Begin:
    ScopeOff();
    LaserOff();
    TweenDown();
    FinishAnim();
    bOnlyOwnerSee = false;
    if (Pawn(Owner) != None)
        Pawn(Owner).ChangedWeapon();
}

/*-------------------------------------------------------------------------------------*/
function int GetinvSlotsX()         // Number of horizontal inv. slots this item takes
{return invSlotsX;}

function int GetinvSlotsY()         // Number of vertical inv. slots this item takes
{return invSlotsY;}

function int GetbeltPos()           // Position on the object belt
{return beltPos;}

function SetbeltPos(int position)           // Position on the object belt
{beltPos = position;}

function string GetDescription()
{return description;}

function string GetbeltDescription()  // Description used on the object belt
{return beltdescription;}

function float GetlargeIconWidth()
{return largeIconWidth;}

function float GetlargeIconHeight()
{return largeIconHeight;}

function int GetinvPosX() // X position on the inventory window
{return invPosX;}

function int GetinvPosY() // Y position on the inventory window
{return invPosY;}

function SetinvPosX(int position) // X position on the inventory window
{
//  log(self$" invPosX="$position);
  invPosX = position;
}

function SetinvPosY(int position) // Y position on the inventory window
{
//  log(self$" invPosY="$position);
  invPosY = position;
}

function texture GetIcon()
{return icon;}

function texture GetLargeIcon()
{return largeIcon;}


defaultproperties
{
    bReadyToFire=True
    LowAmmoWaterMark=10
    NoiseLevel=1.00
    ShotTime=0.50
    reloadTime=1.00
    HitDamage=10
    maxRange=9600
    AccurateRange=4800
    BaseAccuracy=0.50
    ScopeFOV=10
    bPenetrating=True
    bHasMuzzleFlash=True
    bEmitWeaponDrawn=True
    bUseWhileCrouched=True
    bUseAsDrawnWeapon=True
    msgCannotBeReloaded="This weapon can't be reloaded"
    msgOutOf="Out of %s"
    msgNowHas="%s now has %s loaded"
    msgAlreadyHas="%s already has %s loaded"
    msgNone="NONE"
    msgLockInvalid="INVALID"
    msgLockRange="RANGE"
    msgLockAcquire="ACQUIRE"
    msgLockLocked="LOCKED"
    msgRangeUnit="FT"
    msgTimeUnit="SEC"
    msgMassUnit="LBS"
    msgNotWorking="This weapon doesn't work underwater"
    msgInfoAmmoLoaded="Ammo loaded:"
    msgInfoAmmo="Ammo type(s):"
    msgInfoDamage="Base damage:"
    msgInfoClip="Clip size:"
    msgInfoROF="Rate of fire:"
    msgInfoReload="Reload time:"
    msgInfoRecoil="Recoil:"
    msgInfoAccuracy="Base Accuracy:"
    msgInfoAccRange="Acc. range:"
    msgInfoMaxRange="Max. range:"
    msgInfoMass="Mass:"
    msgInfoLaser="Laser sight:"
    msgInfoScope="Scope:"
    msgInfoSilencer="Silencer:"
    msgInfoNA="N/A"
    msgInfoYes="YES"
    msgInfoNo="NO"
    msgInfoAuto="AUTO"
    msgInfoSingle="SINGLE"
    msgInfoRounds="RDS"
    msgInfoRoundsPerSec="RDS/SEC"
    msgInfoSkill="Skill:"
    msgInfoWeaponStats="Weapon Stats:"
    ReloadCount=10
//    shakevert=10.00
    Misc1Sound=Sound'DeusExSounds.Generic.DryFire'
    AutoSwitchPriority=0
    PickupMessage="You found"
    ItemName="DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
    LandSound=Sound'DeusExSounds.Generic.DropSmallWeapon'
    Mass=10.00
    Buoyancy=5.00

    invSlotsX=1
    invSlotsY=1

    bCanThrow=true
    bDisplayableinv=true
    PlayerViewPivot=(Pitch=0,Roll=0,Yaw=-32768)

    ShakeRotMag=(X=50.000000,Y=50.000000,Z=50.000000)
    ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
    ShakeRotTime=2.000000
    ShakeOffsetMag=(X=1.000000,Y=1.000000,Z=1.000000)
    ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
    ShakeOffsetTime=2.000000

    TransientSoundVolume=1.00
    ShellCasingDrawScale=0.2
}

