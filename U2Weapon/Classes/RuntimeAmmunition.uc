/*
  ...sigh
*/

class RuntimeAmmunition extends Ammunition abstract
                                           placeable;

var() class<ammunition> ParentAmmo;    // Class of ammo to be represented in inventory
var() sound PickupSound;
var sound LandSound;
var localized string PickupMessage;


function bool AddAmmo(int AmmoToAdd)
{
    If (AmmoAmount >= MaxAmmo) return false;
    AmmoAmount += AmmoToAdd;
    if (AmmoAmount > MaxAmmo) AmmoAmount = MaxAmmo;
    return true;
}

function bool HandlePickupQuery( inventory Item )
{
//  log("HandlePickupQuery "$item);

    if ((class == item.class) || (ClassIsChildOf(item.class, class'Ammunition') && (class == RuntimeAmmunition(item).parentammo)))
    {
        if (AmmoAmount==MaxAmmo)
        return true;

            Pawn(Owner).ClientMessage(PickupMessage @ ItemName, 'Pickup');

        PlaySound(PickupSound);
        AddAmmo(Ammunition(item).AmmoAmount);
        item.Destroy();
        return true;                
    }
    if ( Inventory == None )
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



defaultproperties
{
  bCollideWorld=true
   bUseDynamicLights=true
   PickupMessage="Found ammo:"
}
