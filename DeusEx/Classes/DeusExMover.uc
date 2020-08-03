//=============================================================================
// DeusExMover.
//=============================================================================
class DeusExMover extends Mover;

// DEUS_EX AMSD Added to make vision aug run faster.  If true, the vision aug needs to check this object more closely.
// Used for heat sources as well as things that blind.
var bool bVisionImportant;

var() bool              bOneWay;                // this door can only be opened from one side
var() bool              bLocked;                // this door is locked
var() bool              bPickable;              // this lock can be picked
var() float             lockStrength;           // "toughness" of the lock on this door - 0.0 is easy, 1.0 is hard
var() bool              bBreakable;             // this door can be destroyed
var() float             doorStrength;           // "toughness" of this door - 0.0 is weak, 1.0 is strong
var() name              KeyIDNeeded;            // key ID code to open the door
var() bool              bHighlight;             // should this door highlight when focused?
var() bool              bFrobbable;             // this door can be frobbed

var bool                bPicking;               // a lockpick is currently being used
var float               pickValue;              // how much this lockpick is currently picking
var float               pickTime;               // how much time it takes to use a single lockpick
var int                 numPicks;               // how many times to reduce hack strength
var float            TicksSinceLastPick; //num ticks done since last pickstrength update(includes partials)
var float            TicksPerPick;       // num ticks needed for a hackstrength update (includes partials)
var float            LastTickTime;       // Time at which last tick occurred.

var DeusExPlayer        pickPlayer;             // the player that is picking
var LockPick         curPick;                // the lockpick that is being used // Вариант для инвентаря!

var() int               minDamageThreshold;     // damage below this amount doesn't count
var bool                bDestroyed;             // has this mover already been destroyed?

var() int               NumFragments;           // number of fragments to spew on destroy
var() float             FragmentScale;          // scale of fragments
var() int               FragmentSpread;         // distance fragments will be thrown
var() class<DeusExFragment> FragmentClass;          // which fragment // Использую этот
var() texture           FragmentTexture;        // what texture to use on fragments
var() bool              bFragmentTranslucent;   // are these fragments translucent?
var() bool              bFragmentUnlit;         // are these fragments unlit?
var() sound             ExplodeSound1;          // small explosion sound
var() sound             ExplodeSound2;          // large explosion sound
var() bool              bDrawExplosion;         // should we draw an explosion?
var() bool              bIsDoor;                // is this mover an actual door?

var() bool              bUseDXCollision; // Использовать отключение коллизии пока Mover движется?
var       Pawn          WaitingPawn;


var localized string    msgKeyLocked;           // message when key locked door
var localized string    msgKeyUnlocked;         // message when key unlocked door
var localized string    msgLockpickSuccess;     // message when lock is picked
var localized string    msgOneWayFail;          // message when one-way door can't be opened
var localized string    msgLocked;              // message when the door is locked
var localized string    msgPicking;             // message when the door is being picked
var localized string    msgAlreadyUnlocked;     // message when the door is already unlocked
var localized string    msgNoNanoKey;           // message when the player doesn't have the right nanokey

// Для размера рамки на ГДИ (16 или 8).
final function bool GetBoundingBoxSize(out vector boxSize)
{
  local box korobka;

  korobka = class'ObjectManager'.static.GetMoverBoundingBox(self);

  boxSize = /*korobka.Min +*/ korobka.Max;

  return (korobka.IsValid > 0);
}

// Actor
final function bool GetBoundingBox(out vector MinVect, out vector MaxVect)
{
  local box korobka;

  korobka = class'ObjectManager'.static.GetActorBoundingBox(self);

  MinVect = korobka.Min + location;
  MaxVect = korobka.Max + location;

  return (korobka.IsValid > 0);
}

// Mover
private final function bool GetBoundingBoxForAI(out vector MinVect, out vector MaxVect)
{
  local box korobka;

  korobka = class'ObjectManager'.static.GetMoverBoundingBox(self);

  MinVect = korobka.Min;
  MaxVect = korobka.Max;

  return (korobka.IsValid > 0);
}


function ComputeMovementArea(out vector center, out vector area)
{
    local int     i, j;
    local float   mult;
    local int     count;
    local vector  box1, box2;
    local vector  minVect;
    local vector  maxVect;
    local vector  newLocation;
    local rotator newRotation;

    if (NumKeys > 0)  // better safe than silly
    {
        // Initialize our bounding box
      GetBoundingBoxForAI(box1, box2);
//        GetBoundingBox(box1, box2);

        // Compute the total area of our bounding box
        for (i=1; i<NumKeys; i++)
        {
            if (KeyRot[i] == KeyRot[i-1])
                count = 1;
            else
                count = 3;
            for (j=0; j<count; j++)
            {
                mult = float(j+1)/count;
                newLocation = BasePos + (KeyPos[i]-KeyPos[i-1])*mult + KeyPos[i-1];
                newRotation = BaseRot + (KeyRot[i]-KeyRot[i-1])*mult + KeyRot[i-1];
                if (GetBoundingBox(minVect, maxVect))
                {
                    // Expand the bounding box
                    box1.X = FMin(FMin(box1.X, maxVect.X), minVect.X);
                    box1.Y = FMin(FMin(box1.Y, maxVect.Y), minVect.Y);
                    box1.Z = FMin(FMin(box1.Z, maxVect.Z), minVect.Z);
                    box2.X = FMax(FMax(box2.X, maxVect.X), minVect.X);
                    box2.Y = FMax(FMax(box2.Y, maxVect.Y), minVect.Y);
                    box2.Z = FMax(FMax(box2.Z, maxVect.Z), minVect.Z);
                }
            }
        }
    }

    // Fallback
    else
    {
        box1 = vect(0,0,0);
        box2 = vect(0,0,0);
    }

    // Compute center/area of the bounding box and return
    center = (box1+box2)/2;
    area = box2 - center;
}

//
// FinishNotify() - overridden from Mover; called when mover has finished moving
//
function FinishNotify()
{
    local Pawn   curPawn;
    local vector box1, box2;
    local vector center, area;
    local float  distX, distY, distZ;
    local float  maxX, maxY, maxZ;
    local float  maxDist;
    local vector tempVect;
    local bool   bNotify;

    Super.FinishNotify();

    if ((NumKeys > 0) && (MoverEncroachType == ME_IgnoreWhenEncroach))
    {
        GetBoundingBox(box1, box2);
        center  = (box1+box2)/2;
        area    = box2 - center;
        maxDist = VSize(area)+200;
        foreach RadiusActors(Class'Pawn', curPawn, maxDist)
        {
            bNotify = false;
            distZ = Abs(center.Z - curPawn.Location.Z);
            maxZ  = area.Z + curPawn.CollisionHeight;
            if (distZ < maxZ)
            {
                distX = Abs(center.X - curPawn.Location.X);
                distY = Abs(center.Y - curPawn.Location.Y);
                maxX  = area.X + curPawn.CollisionRadius;
                maxY  = area.Y + curPawn.CollisionRadius;
                if ((distX < maxX) && (distY < maxY))
                {
                    if ((distX >= area.X) && (distY >= area.Y))
                    {
                        tempVect.X = distX-area.X;
                        tempVect.Y = distY-area.Y;
                        tempVect.Z = 0;
                        if (VSize(tempVect) < CollisionRadius)
                            bNotify = true;
                    }
                    else
                        bNotify = true;
                }
            }
            if (bNotify)
                curPawn.EncroachedByMover(self);
        }
    }
}


function PostBeginPlay()
{
    Super.PostBeginPlay();

    // keep these within limits
    lockStrength = FClamp(lockStrength, 0.0, 1.0);
    doorStrength = FClamp(doorStrength, 0.0, 1.0);

    if (!bPickable)
        lockStrength = 1.0;
    if (!bBreakable)
        doorStrength = 1.0;
}


//
// DropThings() - drops everything that is based on this mover
//
function DropThings()
{
    local actor A;

    // drop everything that is on us
    foreach BasedActors(class'Actor', A)
        A.SetPhysics(PHYS_Falling);
}

//
// "Destroy" the mover
//

function BlowItUp(Pawn instigatedBy)
{
    local int i;
    local DeusExFragment frag;
    local Actor A;
    local DeusExDecal D;
    local Vector spawnLoc;
    local ExplosionLight light;

    // force the mover to stop
    if (Leader != None)
        Leader.MakeGroupStop();

    Instigator = instigatedBy;

    // trigger our event
    if (Event != '')
        foreach AllActors(class'Actor', A, Event)
            if (A != None)
                A.Trigger(Self, instigatedBy);

    // destroy all effects that are on us
    foreach BasedActors(class'DeusExDecal', D)
        D.Destroy();

    DropThings();

    // get the origin of the mover
    spawnLoc = Location - (PrePivot >> Rotation);

    // spawn some fragments and make a sound
    for (i=0; i<NumFragments; i++)
    {
        frag = Spawn(FragmentClass,,, spawnLoc + FragmentSpread * VRand());
        if (frag != None)
        {
            frag.Instigator = instigatedBy;

            // make the last fragment just drop down so we have something to attach the sound to
            if (i == NumFragments - 1)
                frag.Velocity = vect(0,0,0);
            else
                frag.CalcVelocity(VRand(), FragmentSpread);

            frag.SetDrawScale(FragmentScale);
            if (FragmentTexture != None)
                frag.Skins[0] = FragmentTexture;
            if (bFragmentTranslucent)
            {
                frag.Style = STY_Translucent;
                frag.Skins[0] = frag.CreateTranslucentMaterial(); // DXR: Прозрачные фрагменты
            }
            if (bFragmentUnlit)
                frag.bUnlit = True;
        }
    }

    // should we draw explosion effects?
    if (bDrawExplosion)
    {
        light = Spawn(class'ExplosionLight',,, spawnLoc);
        if (FragmentSpread < 64)
        {
            Spawn(class'ExplosionSmall',,, spawnLoc);
            if (light != None)
                light.size = 2;
        }
        else if (FragmentSpread < 128)
        {
            Spawn(class'ExplosionMedium',,, spawnLoc);
            if (light != None)
                light.size = 4;
        }
        else
        {
            Spawn(class'ExplosionLarge',,, spawnLoc);
            if (light != None)
                light.size = 8;
        }
    }

    // alert NPCs that I'm breaking
    class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, 2.0, FragmentSpread * 16);

    MakeNoise(2.0);
    if (frag != None)
    {
        if (NumFragments <= 5)
            frag.PlaySound(ExplodeSound1, SLOT_None, 2.0,, FragmentSpread*256);
        else
            frag.PlaySound(ExplodeSound2, SLOT_None, 2.0,, FragmentSpread*256);
    }

   //DEUS_EX AMSD Mover is dead, make it a dumb proxy so location updates
    RemoteRole = ROLE_DumbProxy;
    SetLocation(Location+vect(0,0,20000));      // move it out of the way
    SetCollision(False, False, False);          // and make it non-colliding
    bDestroyed = True;
}

//
// Copied from Engine.Mover
//
function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    if (bDestroyed)
        return;

    if ((damageType == class'DM_TearGas') || (damageType == class'DM_PoisonGas') || (damageType == class'DM_HalonGas'))
        return;

    if ((damageType == class'DM_Stunned') || (damageType == class'DM_Radiation'))
        return;

    if ((DamageType == class'DM_EMP') || (DamageType == class'DM_NanoVirus') || (DamageType == class'DM_Shocked'))
        return;

    if (bBreakable)
    {
        // add up the damage
        if (Damage >= minDamageThreshold)
            doorStrength -= Damage * 0.01;
//      else
//          doorStrength -= Damage * 0.001;     // damage below the threshold does 1/10th the damage

        doorStrength = FClamp(doorStrength, 0.0, 1.0);
        if (doorStrength ~= 0.0)
            BlowItUp(EventInstigator);
    }
}

// Return true to abort, false to continue.
function bool EncroachingOn(actor Other)
{
    local Pawn P;
    if (Other.IsA('Carcass') || Other.IsA('Decoration'))
    {
        Other.TakeDamage(10000, None, Other.Location, vect(0,0,0), class'Crushed');
        return false;
    }
    // DEUS_EX CNN - Don't destroy inventory items when encroached!
//  if ( Other.IsA('Fragment') || (Other.IsA('Inventory') && (Other.Owner == None)) )
    if (Other.IsA('Fragment'))
    {
        Other.Destroy();
        return false;
    }

    // DEUS_EX CNN - make based actors not stop movers
    if (Other.Base == Self)
    {
        return False;
    }

    // Damage the encroached actor.
    if( EncroachDamage != 0 )
        Other.TakeDamage( EncroachDamage, Instigator, Other.Location, vect(0,0,0), class'Crushed' );

    // If we have a bump-player event, and Other is a pawn, do the bump thing.
    P = Pawn(Other);
    if(P!=None && P.IsPlayerPawn()) // P.bIsPlayer )
    {
        if (PlayerBumpEvent!='')
            Bump( Other );
        if ((MyMarker != None) && (P.Base != self) && (P.Location.Z < MyMarker.Location.Z - P.CollisionHeight - 0.7 * MyMarker.CollisionHeight) )
            // pawn is under lift - tell him to move
            P.Controller.UnderLift(self);
    }

    // Stop, return, or whatever.
    if(MoverEncroachType == ME_StopWhenEncroach)
    {
        Leader.MakeGroupStop();
        return true;
    }
    else if( MoverEncroachType == ME_ReturnWhenEncroach )
    {
        Leader.MakeGroupReturn();
        if ( Other.IsA('Pawn') )
        {
            if (Pawn(Other).IsPlayerPawn()) //bIsPlayer )
            Pawn(Other).PlayMoverHitSound();
//              Pawn(Other).PlaySound(Pawn(Other).Land, SLOT_None);         // DEUS_EX CNN - Changed from SLOT_Talk
            else
            Pawn(Other).PlayMoverHitSound();
//              Pawn(Other).PlaySound(Pawn(Other).HitSound1, SLOT_None);    // DEUS_EX CNN - Changed from SLOT_Talk
        }   
        return true;
    }
    else if(MoverEncroachType == ME_CrushWhenEncroach)
    {
        // Kill it.
        Other.KilledBy(Instigator);
        return false;
    }
    else if(MoverEncroachType == ME_IgnoreWhenEncroach)
    {
        // Ignore it.
        return false;
    }
}

// native(262) final function SetCollision( optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers ); // NOTE - bBlockPlayers is obsolete
// Несмотря на параметр MoverEncroachType == ME_IgnoreWhenEncroach, двери все равно тащат игрока за собой!
// Нужно попробовать избавиться от этого.
event Tick(float deltatime)
{
    Super.tick(deltatime);

    If (bUseDXCollision)
    {
        if ((bInterpolating) && (MoverEncroachType == ME_IgnoreWhenEncroach))
        {
            SetCollision(true,false); // Выключить коллизию
        }
        else
            SetCollision(default.bCollideActors,default.bBlockActors); // Коллизия восстановлена в стандартное значение.
    }
}

//
// Called every 0.1 seconds while the pick is actually picking
//
event Timer()
{
    local DeusExMover M;

    if (bPicking)
    {
        numPicks--;
        curPick.PlayUseAnim();
        lockStrength -= pickValue * (0.1 / pickTime);
        lockStrength = FClamp(lockStrength, 0.0, 1.0);

        // pick all like-tagged movers at once (for double doors and such)
        if ((Tag != '') && (Tag != 'DeusExMover'))
            foreach AllActors(class'DeusExMover', M, Tag)
                if (M != Self)
                    M.lockStrength = lockStrength;

        // did we unlock it?
        if (lockStrength ~= 0.0)
        {
            lockStrength = 0.0;
            bLocked = False;

            // unlock all like-tagged movers at once (for double doors and such)
            if ((Tag != '') && (Tag != 'DeusExMover'))
                foreach AllActors(class'DeusExMover', M, Tag)
                    if (M != Self)
                        M.bLocked = False;

            pickPlayer.ClientMessage(msgLockpickSuccess);
            StopPicking();
        }

        // are we done with this pick?
        else
            if (numPicks <= 0)
            StopPicking();

        // check to see if we've moved too far away from the door to continue
        else if (pickPlayer.frobTarget != Self)
             StopPicking();

        // check to see if we've put the lockpick away
        else if (pickPlayer.inHand != curPick)
             StopPicking();
    }
}


//
// Stops the current pick-in-progress
//

function StopPicking()
{
    // alert NPCs that I'm not messing with stuff anymore
    class'EventManager'.static.AIEndEvent(self,'MegaFutz', EAITYPE_Visual);
    bPicking = False;
    if (curPick != None)
    {
        curPick.StopUseAnim();
        curPick.bBeingUsed = False;
        curPick.UseOnce();
    }
    curPick = None;
    SetTimer(0.1, False);
}

//
// The main logic function for doors
//
function Frob(Actor Frobber, Inventory frobWith)
{
    local Pawn P;
    local DeusExPlayer Player;
    local bool bOpenIt, bDone;
    local string msg;
    local Vector X, Y, Z;
    local float dotp;
    local DeusExMover M;

    // if we shouldn't be frobbed, get out
    if (!bFrobbable)
        return;

    // if we are destroyed, don't do anything
    if (bDestroyed)
        return;

    // make sure we frob our leader if we are a slave
    if (bSlave)
        if (Leader != None)
            Leader.Frob(Frobber, frobWith);

    P = Pawn(Frobber);
    Player = DeusExPlayer(P);
    bOpenIt = False;
    bDone = False;
    msg = msgLocked;

    // make sure someone is trying to open the door
    if (P == None)
        return;

    // ugly hack, so animals can't open doors
    if (P.IsA('Animal'))
        return;

    // Let any non-player pawn open any door for now
    if (Player == None)
    {
        bOpenIt = True;
        msg = "";
        bDone = True;
    }

    // If we are already trying to pick it, print a message
    if (bPicking)
    {
        msg = msgPicking;
        bDone = True;
    }

    // If the door is not closed, it can always be closed no matter what
    if ((KeyNum != 0) || (PrevKeyNum != 0))
    {
        bOpenIt = True;
        msg = "";
        bDone = True;
    }

    // check to see if this is a one-way door
    if (!bDone && bOneWay)
    {
        GetAxes(Rotation, X, Y, Z);
        dotp = (Location - Frobber.Location) dot X;

        // if we're on the wrong side of the door, then don't open
        if (dotp > 0.0)
        {
            bOpenIt = False;
            msg = msgOneWayFail;
            bDone = True;
        }
    }

    //
    // If the door is locked, the player must do one of the following to open it
    // without triggers or explosions:
    // 1. Use the KeyIDNeeded 
    // 2. Use the Lockpick and SkillLockpicking
    //
    if (!bDone)
    {
        // Get what's in the player's hand
        if (frobWith != None)
        {
            // check for the use of lockpicks
            if (bPickable && frobWith.IsA('LockPick') && (Player.SkillSystem != None))
            {
                if (bLocked)
                {
                    // alert NPCs that I'm messing with stuff
                    class'EventManager'.static.AIStartEvent(self, 'MegaFutz', EAITYPE_Visual);

                    pickValue = Player.SkillSystem.GetSkillLevelValue(class'SkillLockpicking');
                    pickPlayer = Player;
                    curPick = LockPick(frobWith);
                    curPick.bBeingUsed = True;
                    curPick.PlayUseAnim();
                    bPicking = True;
                    numPicks = pickTime * 10.0;
                    SetTimer(0.1, True);
                    msg = msgPicking;
                }
                else
                {
                    msg = msgAlreadyUnlocked;
                }
            }
            else if ((KeyIDNeeded != '') && frobWith.IsA('NanoKeyRing') && (lockStrength > 0.0))
            {
                // check for the correct key use
                NanoKeyRing(frobWith).PlayUseAnim();
                if (NanoKeyRing(frobWith).HasKey(KeyIDNeeded))
                {
                    bLocked = !bLocked;     // toggle the lock state

                    // toggle the lock state for all like-tagged movers at once (for double doors and such)
                    if ((Tag != '') && (Tag != 'DeusExMover'))
                        foreach AllActors(class'DeusExMover', M, Tag)
                            if (M != Self)
                                M.bLocked = !M.bLocked;

                    bOpenIt = False;
                    if (bLocked)
                        msg = msgKeyLocked;
                    else
                        msg = msgKeyUnlocked;
                }
                else if (bLocked)
                {
                    bOpenIt = False;
                    msg = msgNoNanoKey;
                }
                else
                {
                    msg = msgAlreadyUnlocked;
                }
            }
            else if (!bLocked)
            {
                bOpenIt = True;
                msg = "";
            }
        }
        else if (!bLocked)
        {
            bOpenIt = True;
            msg = "";
        }
    }

    // give the player a message
    if ((Player != None) && (msg != ""))
        Player.ClientMessage(msg);

    // open it!
    if (bOpenIt)
    {
        Super.Frob(Frobber, frobWith);
        Trigger(Frobber, P);

        // trigger all like-tagged movers at once (for double doors and such)
        if ((Tag != '') && (Tag != 'DeusExMover'))
            foreach AllActors(class'DeusExMover', M, Tag)
                if (M != Self)
                    M.Trigger(Frobber, P);
    }
}



//
// make sure we can't be triggered after we've been destroyed
//
state() TriggerOpenTimed
{
    function Trigger( actor Other, pawn EventInstigator )
    {
        if (!bDestroyed)
            Super.Trigger(Other, EventInstigator);
    }
}

state() TriggerToggle
{
    function Trigger( actor Other, pawn EventInstigator )
    {
        if (!bDestroyed)
            Super.Trigger(Other, EventInstigator);
    }
}

state() TriggerControl
{
    function Trigger( actor Other, pawn EventInstigator )
    {
        if (!bDestroyed)
            Super.Trigger(Other, EventInstigator);
    }
}

state() TriggerPound
{
    function Trigger( actor Other, pawn EventInstigator )
    {
        if (!bDestroyed)
            Super.Trigger(Other, EventInstigator);
    }
}


defaultproperties
{
     bUseDXCollision=true // on by default
     bPathColliding=false // Don't block paths
     bBlockSight=True
     bPickable=True
     lockStrength=0.200000
     doorStrength=0.250000
     bHighlight=True
     bFrobbable=True
     pickTime=4.000000
     minDamageThreshold=10
     NumFragments=16
     FragmentScale=2.000000
     FragmentSpread=32
     FragmentClass=Class'DeusEx.WoodFragment'
     ExplodeSound1=Sound'DeusExSounds.Generic.WoodBreakSmall'
     ExplodeSound2=Sound'DeusExSounds.Generic.WoodBreakLarge'
     msgKeyLocked="Your NanoKey Ring locked it"
     msgKeyUnlocked="Your NanoKey Ring unlocked it"
     msgLockpickSuccess="You picked the lock"
     msgOneWayFail="It won't open from this side"
     msgLocked="It's locked"
     msgPicking="Picking the lock..."
     msgAlreadyUnlocked="It's already unlocked"
     msgNoNanoKey="Your NanoKey Ring doesn't have the right code"
     MoverEncroachType=ME_StopWhenEncroach
     BumpType=BT_PawnBump
     InitialState=TriggerToggle
     bDirectional=True
     bUseDynamicLights=true // Чтобы более-менее освещались от AugLight
     bAcceptsProjectors=true
}
