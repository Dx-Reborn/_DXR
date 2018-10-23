//=============================================================================
// AugmentationCannister.
//=============================================================================
class AugmentationCannister extends DeusExPickup;

var() Name AddAugs[2];

defaultproperties
{
     InventoryType=class'AugmentationCannisterInv'
     ItemName="Augmentation Canister"
     Mesh=Mesh'DeusExItems.AugmentationCannister'
     CollisionRadius=4.310000
     CollisionHeight=10.240000
     Mass=10.000000
     Buoyancy=12.000000
}
