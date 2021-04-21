/*
   Old-style ammo class.
*/

class RuntimeAmmunition extends Ammunition
                              HideDropdown
                                  abstract
                                 placeable;

var() class<ammunition> ParentAmmo;    // Class of ammo to be represented in inventory
var() sound PickupSound;
var sound LandSound;
var localized string PickupMessage;

event SetInitialState()
{
   bCollideWorld = true;
   Super.SetInitialState();
}

// DEUS_EX STM - added
function PlayLandingSound()
{
    if (LandSound != None)
        PlaySound(LandSound);
}

function bool AddAmmo(int AmmoToAdd)
{
    if (AmmoAmount >= MaxAmmo) return false;
    AmmoAmount += AmmoToAdd;
    if (AmmoAmount > MaxAmmo) AmmoAmount = MaxAmmo;
    return true;
}

function bool HandlePickupQuery(inventory Item)
{
//  log("HandlePickupQuery "$item);

    if ((class == item.class) || (ClassIsChildOf(item.class, class'Ammunition') && (class == RuntimeAmmunition(item).parentammo)))
    {
        if (AmmoAmount==MaxAmmo)
        return true;

        Pawn(Owner).ClientMessage(PickupMessage @ ItemName, 'Pickup');

        if (RuntimeAmmunition(Item) != None)
            RuntimeAmmunition(Item).PlaySound(PickupSound);

        AddAmmo(Ammunition(item).AmmoAmount);
        item.Destroy();
        return true;                
    }
    if (Inventory == None)
        return false;

    return Inventory.HandlePickupQuery(Item);
}


function Frob(actor Other, inventory FrobWith)
{
   if (Level.Game.PickupQuery(Pawn(Other), self))
       SpawnCopy(Pawn(Other));
}

function inventory SpawnCopy(pawn Other)
{
    local inventory Copy;

    Copy = self;
    Copy.GiveTo(Other);
    return Copy;
}

function GiveTo(pawn Other)
{
    Instigator = Other;
    BecomeItem();
    Other.AddInventory(Self);
    GotoState('Idle2');
}

function BecomePickup()
{
    if (Physics != PHYS_Falling)
        RemoteRole    = ROLE_SimulatedProxy;

    bOnlyOwnerSee = false;
    bHidden       = false;
    NetPriority   = 1.4;
//    SetCollision(true, true, false);       // make things block actors as well - DEUS_EX CNN
    SetCollision(true, false, false);       // make things block actors as well - DEUS_EX CNN
}

function BecomeItem()
{
//  log(self$" becomeItem ?");
    RemoteRole    = ROLE_SimulatedProxy;
//  Mesh          = PlayerViewMesh;
//  DrawScale     = PlayerViewScale;
    bOnlyOwnerSee = true;
    bHidden       = true;
//  bCarriedItem  = true;
    NetPriority   = 1.4;
    SetCollision(false, false, false);
    SetPhysics(PHYS_None);
    AmbientGlow = 0;
}

auto state Pickup
{
    singular event PhysicsVolumeChange(PhysicsVolume NewZone)
    {
        local float splashsize;
        local actor splash;

        if(NewZone.bWaterVolume && !PhysicsVolume.bWaterVolume)
        {
            splashSize = 0.000025 * Mass * (250 - 0.5 * Velocity.Z);
            if (NewZone.EntrySound != None)
                PlaySound(NewZone.EntrySound, SLOT_Interact, splashSize);
            if (NewZone.EntryActor != None)
            {
                splash = Spawn(NewZone.EntryActor); 
                if (splash != None)
                    splash.SetDrawScale(2 * splashSize);
            }
        }
    }

    // Validate touch, and if valid trigger event.
    function bool ValidTouch(actor Other)
    {
        local Actor A;

        if(Other.IsA('Pawn') && Pawn(Other).Controller.bIsPlayer && (Pawn(Other).Health > 0) && Level.Game.PickupQuery(Pawn(Other), self))
        {
            if (Event != '')
                foreach AllActors( class 'Actor', A, Event )
                        A.Trigger( Other, Other.Instigator );
            return true;
        }
        return false;
    }
        
    // When touched by an actor.
    // Now, when frobbed by an actor - DEUS_EX CNN
    function Frob(Actor Other, Inventory frobWith)
    {
        // If touched by a player pawn, let him pick this up.
        if( ValidTouch(Other) )
        {
            SpawnCopy(Pawn(Other));
            Pawn(Other).ClientMessage(PickupMessage @ itemName, 'Pickup');
            PlaySound(PickupSound);        
        }
        else if (bTossedOut && (Other.Class == Class) && Inventory(Other).bTossedOut )
                 Destroy();
    }

    // Landed on ground.
    function Landed(Vector HitNormal)
    {
        local rotator newRot;
        newRot = Rotation;
        newRot.pitch = 0;
        SetRotation(newRot);
        if (Level.TimeSeconds > 2) //DXR: Не воспроизводить звук падения сразу после загрузки.
            PlayLandingSound();  // DEUS_EX STM - added
    }

    // Make sure no pawn already touching (while touch was disabled in sleep).
    function CheckTouching()
    {
        local int i;

        for (i=0; i<4; i++)
            if ((Touching[i] != None) && Touching[i].IsA('Pawn'))
                Touch(Touching[i]);
    }

    event BeginState()
    {
        BecomePickup();
        bCollideWorld = true;
        if (Level.bStartup)
            bAlwaysRelevant = true;
    }

    event EndState()
    {
        bCollideWorld = false;
    }

Begin:
    BecomePickup();

Dropped:
}




defaultproperties
{
    bUseDynamicLights=true
    PickupMessage="Found ammo:"
    bCollideActors=false
    bOrientOnSlope=true
    bCollideWorld=true
    bUseCylinderCollision=true
}
