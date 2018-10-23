/*
   Replacement for Pickup class, so UnrealEd will not place InventorySpots. Wtf, why i can't turn these inventorySpots off?!
   Not all inventory items can be placed to map directly from UnrealEd, so this class will spawn inventory items automatically.
   Only VertMesh for weapon items !

   This class is for compatibility with original DeusEx maps (since replacing all inventory items on all maps will take lot of
   time o_0). When creating new maps, use regular inventory items, as usually, excluding weapons (!!!).
*/

class PlaceableInventory extends Actor
                                 placeable
                                 abstract;

var() string ItemName; // Only for map designers
var() class<Inventory> InventoryType; // What inventory item should be spawned?
var inventory inv_ptr;

function PostBeginPlay()
{
  SetCollision(false,false,false);
  Super.PostBeginPlay();

    // We need to just spawn Inventory item, everything else is in inventory item itself.
    inv_ptr = spawn(inventoryType,,,location,rotation);
      if (inv_ptr == none)
         {
           log(self@"Warning! Failed to spawn"@InventoryType@"!!! Possible cause: invalid class or not enough space to spawn. Theoretically.");
         }
         else
          {
           if (inv_ptr.IsA('RuntimePickup'))
               RuntimePickup(inv_ptr).RestoreProperties(self);

           destroy(); // Our work is done.
          }
}

defaultproperties
{
  bCollideWorld=true
  drawType=DT_Mesh // vertMesh or SkeletalMesh (mesh). 
  CollisionHeight=5 // These should match with inventory item's collision size
  CollisionRadius=5 
  Physics=PHYS_Falling
}