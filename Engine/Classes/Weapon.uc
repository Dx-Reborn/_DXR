//
//
//

class Weapon extends Inventory
    abstract
    native
    nativereplication
    HideDropDown;
//  CacheExempt;

#exec Texture Import File=Textures\S_Weapon.tga Name=S_Weapon Mips=Off Alpha=true

replication
{
    // Things the server should send to the client.
    reliable if( Role==ROLE_Authority )
        Ammo, AmmoCharge;

    // Functions called by server on client
    reliable if( Role==ROLE_Authority )
        ClientWeaponSet, ClientWeaponThrown, ClientForceAmmoUpdate, ClientWriteStats, ClientWriteFire;

    // functions called by client on server
    reliable if( Role<ROLE_Authority )
        ServerStartFire, ServerStopFire;
}

const NUM_FIRE_MODES = 2;

var() transient class<WeaponFire> FireModeClass[NUM_FIRE_MODES];
var() /*protected*/ WeaponFire FireMode[NUM_FIRE_MODES];
var() /*protected*/ Ammunition Ammo[NUM_FIRE_MODES];

// animation //
var() Name IdleAnim;
var() Name RestAnim;
var() Name AimAnim;
var() Name RunAnim;
var() Name SelectAnim;
var() Name PutDownAnim;

var() float IdleAnimRate;
var() float RestAnimRate;
var() float AimAnimRate;
var() float RunAnimRate;
var() float SelectAnimRate;
var() float PutDownAnimRate;
var float PutDownTime;
var float BringUpTime;

var() Sound SelectSound;
var() String SelectForce;  // jdf

// AI //
var()   int     BotMode; // the fire Mode currently being used for bots
var()   float   AIRating;
var     float   CurrentRating;  // rating result from most recent RateSelf()
var()   bool    bMeleeWeapon;
var()   bool    bSniping;

// other useful stuff //
var   bool bShowChargingBar;
var   bool bMatchWeapons;   // OBSOLETE - see WeaponAttachment
var() bool bCanThrow;
var() bool bForceSwitch; // if true, this weapon will prevent any other weapon from delaying the switch to it (bomb launcher)
var() deprecated bool bNotInPriorityList; // Should be displayed in a GUI weapon list   -   refer to 'Description' documentation
var   bool bNotInDemo;
var   bool bNoVoluntarySwitch;
var   bool bSpectated;
var   bool bDebugging;
var   bool bNoInstagibReplace;
var   bool bInitOldMesh;
var config bool bUseOldWeaponMesh;
var   bool  bEndOfRound;    // don't allow firing
var bool bNoAmmoInstances;  // if true, replicated ammocount using the Weapons AmmoCharge property - true by default, included to allow mod authors to fallback to old style
var bool bBerserk;

// properties needed if no instantiated ammunition
var travel int AmmoCharge[2];
var class<Ammunition> AmmoClass[2];

var Mesh OldMesh;
var string OldPickup;
var(OldFirstPerson) float OldDrawScale, OldCenteredOffsetY;
var(OldFirstPerson) vector OldPlayerViewOffset, OldSmallViewOffset;
var(OldFirstPerson) rotator OldPlayerViewPivot;
var(OldFirstPerson) int OldCenteredRoll, OldCenteredYaw;

/*
    A note about weapons & the caching system:
    You must now perform two commands on your mod's final package file:

    'ucc dumpint <PackageFileName.u>' - this exports the localized text to a localization file, which is used by the caching system to load the ItemName and Description
    'ucc exportcache <PackageName.u>' - this exports the information that will be used to load the weapon into the caching system.  Type 'ucc help exportcache' at the command-line for more info.

    Ex: (ACoolWeaponMod.u)

    ucc dumpint ACoolWeaponMod.u
    - creates 'ACoolWeaponMod.int' file, (file extension will vary if a different language is specified in the UT2004.ini file)

    ucc exportcache ACoolWeaponMod.u
    - creates an entry in the 'CacheRecords.ucl' file, containing caching information for your package

    Weapons must have values for both ItemName & Description in order to appear in the game.  The caching system will not recognize inherited values for these properties.
    If creating a custom crosshair for your weapon, it will FIXME
    -- rjp
*/
var() localized /*cache*/ string Description;

var class<Weapon> DemoReplacement;
var transient bool bPendingSwitch;
var(FirstPerson) vector EffectOffset; // where muzzle flashes and smoke appear. replace by bone reference eventually
var() Localized string MessageNoAmmo;
var(FirstPerson) float DisplayFOV;
var() enum EWeaponClientState
{
    WS_None,
    WS_Hidden,
    WS_BringUp,
    WS_PutDown,
    WS_ReadyToFire
} ClientState; // this will always be None on the server

var() config byte ExchangeFireModes;
var() config byte Priority;

var() deprecated byte DefaultPriority;

var float Hand;
var float RenderedHand;
var Color HudColor;
var Weapon OldWeapon;
var(FirstPerson)    vector      SmallViewOffset;   // Offset from view center with small weapons option.
var(FirstPerson) vector SmallEffectOffset;
var(FirstPerson) float CenteredOffsetY;
var(FirstPerson) int CenteredRoll, CenteredYaw;
var config int CustomCrosshair;
var config color CustomCrossHairColor;
var config float CustomCrossHairScale;
var config string CustomCrossHairTextureName;
var texture CustomCrossHairTexture;

var float DownDelay, MinReloadPct;      // Used to delay putting down weapons which have jsut been fired

native final function InitWeaponFires();

simulated function float ChargeBar();

//=========================================================================
// Ammunition Interface (to remove the need for instantiated ammunition)

simulated function class<Ammunition> GetAmmoClass(int mode);
simulated function MaxOutAmmo();
simulated function SuperMaxOutAmmo();
simulated function int MaxAmmo(int mode);
simulated function FillToInitialAmmo();
simulated function int AmmoAmount(int mode);

simulated function class<Pickup> AmmoPickupClass(int mode)
{
    return None;
}

simulated function bool AmmoMaxed(int mode);
simulated function GetAmmoCount(out float MaxAmmoPrimary, out float CurAmmoPrimary);
simulated function float AmmoStatus(optional int Mode); // returns float value for ammo amount
simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax);

function bool AddAmmo(int AmmoToAdd, int Mode);

simulated function bool HasAmmo();

// for AI
simulated function bool NeedAmmo(int mode);


simulated function float DesireAmmo(class<Inventory> NewAmmoClass, bool bDetour);

simulated function CheckOutOfAmmo();

simulated function PostNetReceive()
{
    CheckOutOfAmmo();
}

//=========================================================================

simulated function DrawWeaponInfo(Canvas C);
simulated function NewDrawWeaponInfo(Canvas C, float YPos);

function StartDebugging()
{
}

simulated function ClientWriteStats(byte Mode, bool bMatch, bool bAllowFire, bool bDelay, bool bAlt, float wait)
{
    log(self$" Same weapon "$bMatch$" Mode "$Mode$" Allow fire "$bAllowFire$" delay start fire "$bDelay$" alt firing "$bAlt$" next fire wait "$wait);
}

function class<DamageType> GetDamageType();

function HackPlayFireSound();

//=================================================================
// AI functions

function float RangedAttackTime()
{
    return 0;
}

function bool RecommendRangedAttack()
{
    return false;
}

function bool RecommendLongRangedAttack()
{
    return false;
}

function bool FocusOnLeader(bool bLeaderFiring)
{
    return false;
}

function FireHack(byte Mode);

// return true if weapon effect has splash damage (if significant)
// use by bot to avoid hurting self
// should be based on current firing Mode if active
function bool SplashDamage()
{
    return FireMode[BotMode].bSplashDamage;
}

// return true if weapon should be fired to take advantage of splash damage
// For example, rockets should be fired at enemy feet
function bool RecommendSplashDamage();

function float GetDamageRadius();

// Repeater weapons like minigun should be 0.99, other weapons based on likelihood
// of firing again right away
function float RefireRateA();


// tells AI that it needs to release the fire button for this weapon to do anything
function bool FireOnRelease();

simulated function Loaded();

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
//    local int i;
    local string T;
    local name Anim;
    local float frame,rate;

    Canvas.SetDrawColor(0,255,0);
    if ( (Pawn(Owner) != None) && (Pawn(Owner).PlayerReplicationInfo != None) )
        Canvas.DrawText("WEAPON "$GetItemName(string(self))$" Owner "$Pawn(Owner).PlayerReplicationInfo.PlayerName);
    else
        Canvas.DrawText("WEAPON "$GetItemName(string(self))$" Owner "$Owner);
    YPos += YL;
    Canvas.SetPos(4,YPos);

    T = "     STATE: "$GetStateName()$" Timer: "$TimerCounter$" Client State ";

    Switch( ClientState )
    {
        case WS_None: T=T$"WS_None"; break;
        case WS_Hidden: T=T$"WS_Hidden"; break;
        case WS_BringUp: T=T$"WS_BringUp"; break;
        case WS_PutDown: T=T$"WS_PutDown"; break;
        case WS_ReadyToFire: T=T$"WS_ReadyToFire"; break;
    }

    Canvas.DrawText(T, false);
    YPos += YL;
    Canvas.SetPos(4,YPos);

    if ( DrawType == DT_StaticMesh )
        Canvas.DrawText("     StaticMesh "$GetItemName(string(StaticMesh))$" AmbientSound "$AmbientSound, false);
    else
        Canvas.DrawText("     Mesh "$GetItemName(string(Mesh))$" AmbientSound "$AmbientSound, false);
    YPos += YL;
    Canvas.SetPos(4,YPos);
    if ( Mesh != None )
    {
        // mesh animation
        GetAnimParams(0,Anim,frame,rate);
        T = "     AnimSequence "$Anim$" Frame "$frame$" Rate "$rate;
        if ( bAnimByOwner )
            T= T$" Anim by Owner";

        Canvas.DrawText(T, false);
        YPos += YL;
        Canvas.SetPos(4,YPos);

        T = "Eyeheight "$Instigator.EyeHeight$" base "$Instigator.BaseEyeheight$" landbob "$Instigator.Landbob$" just landed "$Instigator.bJustLanded$" land recover "$Instigator.bLandRecovery;
        Canvas.DrawText(T, false);
        YPos += YL;
        Canvas.SetPos(4,YPos);
    }

/*    for ( i=0; i<NUM_FIRE_MODES; i++ )
    {
        if ( FireMode[i] == None )
        {
            Canvas.DrawText("NO FIREMODE "$i);
            YPos += YL;
            Canvas.SetPos(4,YPos);
        }
        else
            FireMode[i].DisplayDebug(Canvas,YL,YPos);

        Canvas.DrawText("Ammunition "$i$" amount "$AmmoAmount(i));
        YPos += YL;
        Canvas.SetPos(4,YPos);
    }*/
}

simulated function Weapon RecommendWeapon( out float rating )
{
    local Weapon Recommended;
    local float oldRating;

    if ( (Instigator == None) || (Instigator.Controller == None) )
        rating = -2;
    else
        rating = RateSelf() + Instigator.Controller.WeaponPreference(self);

    if ( inventory != None )
    {
        Recommended = inventory.RecommendWeapon(oldRating);
        if ( (Recommended != None) && (oldRating > rating) )
        {
            rating = oldRating;
            return Recommended;
        }
    }
    return self;
}

function SetAITarget(Actor T);

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
    if ( Instigator.Controller.bFire != 0 )
        return 0;
    else if ( Instigator.Controller.bAltFire != 0 )
        return 1;
    if ( FRand() < 0.5 )
        return 1;
    return 0;
}

/* BotFire()
called by NPC firing weapon. Weapon chooses appropriate firing Mode to use (typically no change)
bFinished should only be true if called from the Finished() function
FiringMode can be passed in to specify a firing Mode (used by scripted sequences)
*/
function bool BotFire(bool bFinished, optional name FiringMode)
{
    local int newmode;
    local Controller C;

    C = Instigator.Controller;
    newMode = BestMode();

    if ( newMode == 0 )
    {
        C.bFire = 1;
        C.bAltFire = 0;
    }
    else
    {
        C.bFire = 0;
        C.bAltFire = 1;
    }

/*  if ( bFinished )
        return true;

    if ( FireMode[BotMode].IsFiring() )
    {
        if (BotMode == newMode)
            return true;
        else
            StopFire(BotMode);
    }

    if ( !ReadyToFire(newMode) || ClientState != WS_ReadyToFire )
        return false;

    BotMode = NewMode;
    StartFire(NewMode);*/
    return true;
}

// this returns the actual projectile spawn location or trace start
simulated function vector GetFireStart(vector X, vector Y, vector Z);

// need to figure out modified rating based on enemy/tactical situation
simulated function float RateSelf()
{
    if ( !HasAmmo() )
        CurrentRating = -2;
    else if ( Instigator.Controller == None )
        return 0;
    else
        CurrentRating = Instigator.Controller.RateWeapon(self);
    return CurrentRating;
}

function float GetAIRating()
{
    return AIRating;
}

// tells bot whether to charge or back off while using this weapon
function float SuggestAttackStyle()
{
    return 0.0;
}

// tells bot whether to charge or back off while defending against this weapon
function float SuggestDefenseStyle()
{
    return 0.0;
}

// return true if recommend jumping while firing to improve splash damage (by shooting at feet)
// true for R.L., for example
function bool SplashJump();


// return false if out of range, can't see target, etc.
function bool CanAttack(Actor Other);


//=================================================================

simulated function PostBeginPlay()
{
  Super.PostBeginPlay();

    if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
        MaxLights = Min(4,MaxLights);

    if ( SmallViewOffset == vect(0,0,0) )
        SmallViewOffset = Default.PlayerviewOffset;

    if ( SmallEffectOffset == vect(0,0,0) )
        SmallEffectOffset = EffectOffset + Default.PlayerViewOffset - SmallViewOffset;

    if ( bUseOldWeaponMesh && (OldMesh != None) )
    {
        bInitOldMesh = true;
        LinkMesh(OldMesh);
    }
    if ( Level.GRI != None )
        CheckSuperBerserk();
}

simulated function SetGRI(GameReplicationInfo G)
{
    CheckSuperBerserk();
}

simulated function Destroyed()
{
    Super.Destroyed();
}

simulated function Reselect()
{
}

simulated function bool WeaponCentered()
{
    return ( bSpectated || (Hand > 1) );
}

simulated event RenderOverlays( Canvas Canvas )
{
//    local int m;
    local vector NewScale3D;
    local rotator CenteredRotation;
    local name AnimSeq;
    local float frame,rate;

    if (Instigator == None)
        return;

    if ( Instigator.Controller != None )
        Hand = Instigator.Controller.Handedness;

    if ((Hand < -1.0) || (Hand > 1.0))
        return;

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
/*    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }*/

    if ( (OldMesh != None) && (bUseOldWeaponMesh != (OldMesh == Mesh)) )
    {
        GetAnimParams(0,AnimSeq,frame,rate);
        bInitOldMesh = true;
        if ( bUseOldWeaponMesh )
            LinkMesh(OldMesh);
        else
            LinkMesh(Default.Mesh);
        PlayAnim(AnimSeq,rate,0.0);
    }

    if ( (Hand != RenderedHand) || bInitOldMesh )
    {
        newScale3D = Default.DrawScale3D;
        if ( Hand != 0 )
            newScale3D.Y *= Hand;
        SetDrawScale3D(newScale3D);
        SetDrawScale(Default.DrawScale);
        CenteredRoll = Default.CenteredRoll;
        CenteredYaw = Default.CenteredYaw;
        CenteredOffsetY = Default.CenteredOffsetY;
        PlayerViewPivot = Default.PlayerViewPivot;
        SmallViewOffset = Default.SmallViewOffset;
        if ( SmallViewOffset == vect(0,0,0) )
            SmallViewOffset = Default.PlayerviewOffset;
        bInitOldMesh = false;
        if ( Default.SmallEffectOffset == vect(0,0,0) )
            SmallEffectOffset = EffectOffset + Default.PlayerViewOffset - SmallViewOffset;
        else
            SmallEffectOffset = Default.SmallEffectOffset;
        if ( Mesh == OldMesh )
        {
            SmallEffectOffset = EffectOffset + OldPlayerViewOffset - OldSmallViewOffset;
            PlayerViewPivot = OldPlayerViewPivot;
            SmallViewOffset = OldSmallViewOffset;
            if ( Hand != 0 )
            {
                PlayerViewPivot.Roll *= Hand;
                PlayerViewPivot.Yaw *= Hand;
            }
            CenteredRoll = OldCenteredRoll;
            CenteredYaw = OldCenteredYaw;
            CenteredOffsetY = OldCenteredOffsetY;
            SetDrawScale(OldDrawScale);
        }
        else if ( Hand == 0 )
        {
            PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll;
            PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw;
        }
        else
        {
            PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll * Hand;
            PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw * Hand;
        }
        RenderedHand = Hand;
    }
    if ( class'PlayerController'.Default.bSmallWeapons )
        PlayerViewOffset = SmallViewOffset;
    else if ( Mesh == OldMesh )
        PlayerViewOffset = OldPlayerViewOffset;
    else
        PlayerViewOffset = Default.PlayerViewOffset;
    if ( Hand == 0 )
        PlayerViewOffset.Y = CenteredOffsetY;
    else
        PlayerViewOffset.Y *= Hand;

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    if ( Hand == 0 )
    {
        CenteredRotation = Instigator.GetViewRotation();
        CenteredRotation.Yaw += CenteredYaw;
        CenteredRotation.Roll = CenteredRoll;
        SetRotation(CenteredRotation);
    }
    else
        SetRotation( Instigator.GetViewRotation() );

    PreDrawFPWeapon();  // Laurent -- Hook to override things before render (like rotation if using a staticmesh)

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
    if ( Hand == 0 )
        PlayerViewOffset.Y = 0;
}

simulated function PreDrawFPWeapon();

simulated function SetHand(float InHand)
{
    Hand = InHand;
}

simulated function GetViewAxes( out vector xaxis, out vector yaxis, out vector zaxis )
{
    if ( Instigator.Controller == None )
        GetAxes( Instigator.Rotation, xaxis, yaxis, zaxis );
    else
        GetAxes( Instigator.Controller.Rotation, xaxis, yaxis, zaxis );
}

simulated function vector CenteredEffectStart()
{
    return Instigator.Location;
}

simulated function vector GetEffectStart()
{
    local Vector X,Y,Z;

    // jjs - this function should actually never be called in third person views
    // any effect that needs a 3rdp weapon offset should figure it out itself

    // 1st person
    if (Instigator.IsFirstPerson())
    {
        if ( WeaponCentered() )
            return CenteredEffectStart();

        GetViewAxes(X, Y, Z);
        if ( class'PlayerController'.Default.bSmallWeapons )
            return (Instigator.Location +
                Instigator.CalcDrawOffset(self) +
                SmallEffectOffset.X * X  +
                SmallEffectOffset.Y * Y * Hand +
                SmallEffectOffset.Z * Z);
        else
            return (Instigator.Location +
                Instigator.CalcDrawOffset(self) +
                EffectOffset.X * X +
                EffectOffset.Y * Y * Hand +
                EffectOffset.Z * Z);
    }
    // 3rd person
    else
    {
        return (Instigator.Location +
            Instigator.EyeHeight*Vect(0,0,0.5) +
            Vector(Instigator.Rotation) * 40.0);
    }
}

simulated function IncrementFlashCount(int Mode)
{
    if ( WeaponAttachment(ThirdPersonActor) != None )
    {
        if (Mode == 0)
            WeaponAttachment(ThirdPersonActor).FiringMode = 0;
        else
            WeaponAttachment(ThirdPersonActor).FiringMode = 1;
        ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
        WeaponAttachment(ThirdPersonActor).FlashCount++;
        WeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
    }
}

simulated function ZeroFlashCount(int Mode)
{
    if ( WeaponAttachment(ThirdPersonActor) != None )
    {
        if (Mode == 0)
            WeaponAttachment(ThirdPersonActor).FiringMode = 0;
        else
            WeaponAttachment(ThirdPersonActor).FiringMode = 1;
        ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
        WeaponAttachment(ThirdPersonActor).FlashCount = 0;
        WeaponAttachment(ThirdPersonActor).ThirdPersonEffects();
    }
}

simulated function Weapon WeaponChange(byte F, bool bSilent)
{
    if ( InventoryGroup == F )
    {
            return self;
    }
    else if ( Inventory == None )
        return None;
    else
        return Inventory.WeaponChange(F,bSilent);
}

simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if ( HasAmmo() )
    {
        if ( (CurrentChoice == None) )
        {
            if ( CurrentWeapon != self )
                CurrentChoice = self;
        }
        else if ( InventoryGroup == CurrentWeapon.InventoryGroup )
        {
            if ( (GroupOffset < CurrentWeapon.GroupOffset)
                && ((CurrentChoice.InventoryGroup != InventoryGroup) || (GroupOffset > CurrentChoice.GroupOffset)) )
                CurrentChoice = self;
        }
        else if ( InventoryGroup == CurrentChoice.InventoryGroup )
        {
            if ( GroupOffset > CurrentChoice.GroupOffset )
                CurrentChoice = self;
        }
        else if ( InventoryGroup > CurrentChoice.InventoryGroup )
        {
            if ( (InventoryGroup < CurrentWeapon.InventoryGroup)
                || (CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup) )
                CurrentChoice = self;
        }
        else if ( (CurrentChoice.InventoryGroup > CurrentWeapon.InventoryGroup)
                && (InventoryGroup < CurrentWeapon.InventoryGroup) )
            CurrentChoice = self;
    }
    if ( Inventory == None )
        return CurrentChoice;
    else
        return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if ( HasAmmo() )
    {
        if ( (CurrentChoice == None) )
        {
            if ( CurrentWeapon != self )
                CurrentChoice = self;
        }
        else if ( InventoryGroup == CurrentWeapon.InventoryGroup )
        {
            if ( (GroupOffset > CurrentWeapon.GroupOffset)
                && ((CurrentChoice.InventoryGroup != InventoryGroup) || (GroupOffset < CurrentChoice.GroupOffset)) )
                CurrentChoice = self;
        }
        else if ( InventoryGroup == CurrentChoice.InventoryGroup )
        {
            if ( GroupOffset < CurrentChoice.GroupOffset )
                CurrentChoice = self;
        }

        else if ( InventoryGroup < CurrentChoice.InventoryGroup )
        {
            if ( (InventoryGroup > CurrentWeapon.InventoryGroup)
                || (CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup) )
                CurrentChoice = self;
        }
        else if ( (CurrentChoice.InventoryGroup < CurrentWeapon.InventoryGroup)
                && (InventoryGroup > CurrentWeapon.InventoryGroup) )
            CurrentChoice = self;
    }
    if ( Inventory == None )
        return CurrentChoice;
    else
        return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);
}


function HolderDied();

simulated function bool CanThrow()
{
    return bCanThrow;
}

function DropFrom(vector StartLocation)
{
//    local int m;
    local Pickup Pickup;

    ClientWeaponThrown();

/*    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
            StopFire(m);
    }*/

    if ( Instigator != None )
    {
        DetachFromPawn(Instigator);
    }

    Pickup = Spawn(PickupClass,,, StartLocation);
    if ( Pickup != None )
    {
        Pickup.InitDroppedPickupFor(self);
        Pickup.Velocity = Velocity;
        if (Instigator.Health > 0)
            WeaponPickup(Pickup).bThrown = true;
    }
    Destroy();
}

simulated function DetachFromPawn(Pawn P)
{
    Super.DetachFromPawn(P);
    P.AmbientSound = None;
}

simulated function ClientWeaponThrown()
{
    AmbientSound = None;
    Instigator.AmbientSound = None;

    if( Level.NetMode != NM_Client )
        return;

    Instigator.DeleteInventory(self);
}

function GiveTo(Pawn Other);//, optional Pickup Pickup)
/*{
    Super.GiveTo(Other);
    bTossedOut = false;
    Instigator = Other;
    GiveAmmo(Other);
    ClientWeaponSet(true);
}*/

function GiveAmmoA(int m, WeaponPickup WP, bool bJustSpawned);

simulated function ClientWeaponSet(bool bPossiblySwitch);


// jdf ---
simulated function ClientPlayForceFeedback( String EffectName )
{
    local PlayerController PC;

    PC = PlayerController(Instigator.Controller);
    if ( PC != None && PC.bEnableWeaponForceFeedback )
    {
        PC.ClientPlayForceFeedback( EffectName );
    }
}

simulated function StopForceFeedback( String EffectName )
{
    local PlayerController PC;

    PC = PlayerController(Instigator.Controller);
    if ( PC != None && PC.bEnableWeaponForceFeedback )
    {
        PC.StopForceFeedback( EffectName );
    }
}
// --- jdf

simulated function BringUp(optional Weapon PrevWeapon);
/*{
   local int Mode;

    if ( ClientState == WS_Hidden )
    {
        PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
        ClientPlayForceFeedback(SelectForce);  // jdf

        if ( Instigator.IsLocallyControlled() )
        {
            if ( (Mesh!=None) && HasAnim(SelectAnim) )
                PlayAnim(SelectAnim, SelectAnimRate, 0.0);
        }

        ClientState = WS_BringUp;
        SetTimer(BringUpTime, false);
    }
       if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
        OldWeapon = PrevWeapon;
    else
        OldWeapon = None;

}*/

simulated function bool PutDown();
/*{
  instigator.weapon = none;
        GotoState('DownWeapon');
        return True;
} */

simulated function Fire(float F)
{
}

simulated function AltFire(float F)
{
}

simulated event WeaponTick(float dt); // only called on currently held weapon

simulated function OutOfAmmo()
{
    if (Instigator == None || !Instigator.IsLocallyControlled() || HasAmmo())
        return;
}

simulated function DoAutoSwitch();

//// client only ////
simulated event ClientStartFire(int Mode)
{
    if ( Pawn(Owner).Controller.IsInState('GameEnded') || Pawn(Owner).Controller.IsInState('RoundEnded') )
        return;
    if (Role < ROLE_Authority)
    {
        if (StartFire(Mode))
        {
            ServerStartFire(Mode);
        }
    }
    else
    {
        StartFire(Mode);
    }
}

simulated event ClientStopFire(int Mode)
{
/*    if (Role < ROLE_Authority)
    {
        //Log("ClientStopFire"@Level.TimeSeconds);
        StopFire(Mode);
    }
    ServerStopFire(Mode);*/
}

simulated function ClientWriteFire(string Result)
{
    log(self$" ServerStartFire! "$Result);
}

//// server only ////
event ServerStartFire(byte Mode);


simulated function ClientForceAmmoUpdate(int Mode, int NewAmount);

function SynchronizeWeapon(Weapon ClientWeapon)
{
    Instigator.ServerChangedWeapon(self,ClientWeapon);
}

function ServerStopFire(byte Mode);

simulated function /*bool*/ ReadyToFire();//optional int Mode);


//// client & server ////
simulated function bool StartFire(int Mode);

simulated event StopFire(int Mode);

//hack to stop all firing and release any charging firemodes RIGHT THIS INSTANT
//used when getting into vehicles
simulated function ImmediateStopFire();
simulated function Timer();
simulated function bool IsFiring(); // called by pawn animation, mostly
function bool IsRapidFire(); // called by pawn animation

// called every time owner takes damage while holding this weapon - used by shield gun
function AdjustPlayerDamage( out int Damage, Pawn InstigatedBy, Vector HitLocation,out Vector Momentum, class<DamageType> DamageType);
simulated function CheckSuperBerserk();
simulated function StartBerserk();
simulated function StopBerserk();
simulated function AnimEnd(int channel);

simulated function PlayIdle()
{
    LoopAnim(IdleAnim, IdleAnimRate, 0.2);
}

/*state PendingClientWeaponSet
{
    simulated function Timer()
    {
        if ( Pawn(Owner) != None )
            ClientWeaponSet(false);
    }

    simulated function BeginState()
    {
        SetTimer(0.05, true);
    }

    simulated function EndState()
    {
        SetTimer(0.0, false);
    }
} */

/*state Hidden
{
}

state Idle
{
}

state DownWeapon
{
}     */

function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int AmmoDrain )
{
    return false;
}

function DoReflectEffect(int Drain)
{

}

function bool HandlePickupQuery(/* pickup*/ Inventory Item);
/*{
    return Inventory.HandlePickupQuery(Item);
} */

simulated function bool WantsZoomFade()
{
    return false;
}

/* CanHeal()
used by bot AI
should return true if this weapon is able to heal Other
*/
function bool CanHeal(Actor Other)
{
    return false;
}

//called by AI when camping/defending
//return true if it is useful to fire this weapon even though bot doesn't have a target
//for example, a weapon that launches turrets or mines
function bool ShouldFireWithoutTarget()
{
    return false;
}

// ugly hack for tutorial
function bool ShootHoop(Controller B, Vector ShootLoc)
{
    return false;
}

simulated function PawnUnpossessed();


// FIXME - hack to get classes building again after fixing the bug that was allowing all protected variables to
// be referenced in other classes - maybe there's already an accessor that does this and I just don't know about it
// ...in that case, just remove this function -- rjp
simulated function WeaponFire GetFireMode( byte Mode )
{
    return None;
}

function int GetPickUpAmmoCount()
{
   return 10;
}

function int GetReloadCount()
{
   return 10;
}

function GiveAmmo(Pawn Other);

defaultproperties
{
    DrawType=DT_Mesh
    Style=STY_Normal
    PlayerViewOffset=(X=0,Y=0,Z=0)
    InventoryGroup=1

    FireModeClass(0)=None
    FireModeClass(1)=None

    // animation //
    IdleAnim=Idle
    RestAnim=Rest
    AimAnim=Aim
    RunAnim=Run
    SelectAnim=Select
    PutDownAnim=Down

    IdleAnimRate=1.0
    RestAnimRate=1.0
    AimAnimRate=1.0
    RunAnimRate=1.0

    // other useful stuff //
    MessageNoAmmo=" has no ammo"
    DisplayFOV=90.0
    bCanThrow=true

    AIRating=0.5
    CurrentRating=0.5

    AttachmentClass=class'WeaponAttachment'

    NetPriority=3.0
    ScaleGlow=1.5
    AmbientGlow=20
    MaxLights=6
    SoundVolume=255
    HudColor=(r=255,g=255,b=0,a=255)

    CenteredOffsetY=-10.0
    CenteredRoll=2000
    CenteredYaw=0

    bUseOldWeaponMesh=False
    ExchangeFireModes=0
    CustomCrosshair=0
    CustomCrossHairColor=(R=255,G=255,B=255,A=255)
    CustomCrossHairScale=+1.0
    CustomCrossHairTexture=None
    CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Cross1"

    OldCenteredOffsetY=-10.0
    OldCenteredRoll=2000
    OldCenteredYaw=0
    OldDrawScale=+1.0

    SelectAnimRate=1.3636
    PutDownAnimRate=1.3636
    BringUpTime=+0.33
    PutDownTime=+0.33

    MinReloadPct=+0.5
    NetUpdateFrequency=2

    bNoAmmoInstances=true
    bNetNotify=true
}
