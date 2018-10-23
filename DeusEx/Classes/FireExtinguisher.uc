//=============================================================================
// FireExtinguisher.
//=============================================================================
class FireExtinguisher extends DeusExPickup;

#exec OBJ LOAD FILE=Ambient

defaultproperties
{
    InventoryType=class'FireExtinguisherInv'
    ItemName="Fire Extinguisher"
    Mesh=Mesh'DeusExItems.FireExtinguisher'
    CollisionRadius=8.000000
    CollisionHeight=10.270000
    Mass=30.000000
    Buoyancy=20.000000
}
