//=============================================================================
// BallisticArmor.
//=============================================================================
class BallisticArmor extends ChargedPickup;

//
// Reduces ballistic damage
//

defaultproperties
{
     InventoryType=class'BallisticArmorInv'
     ItemName="Ballistic Armor"
     Mesh=Mesh'DeusExItems.BallisticArmor'
     CollisionRadius=11.500000
     CollisionHeight=13.810000
     Mass=40.000000
     Buoyancy=30.000000
}
