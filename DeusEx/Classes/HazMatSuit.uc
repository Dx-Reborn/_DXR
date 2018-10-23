//=============================================================================
// HazMatSuit.
//=============================================================================
class HazMatSuit extends ChargedPickup;

//
// Reduces poison gas, tear gas, and radiation damage
//

defaultproperties
{
     InventoryType=class'HazMatSuitInv'
     ItemName="Hazmat Suit"
     Mesh=Mesh'DeusExItems.HazMatSuit'
     CollisionRadius=17.000000
     CollisionHeight=11.520000
     Mass=20.000000
     Buoyancy=12.000000
}
