//=============================================================================
// DeusExWeapon.
//=============================================================================
class DeusExWeapon extends PlaceableInventory; //WeaponPickUp

defaultproperties
{
     ItemName="DEFAULT WEAPON NAME - REPORT THIS AS A BUG"
     DrawType=DT_Mesh
     Mass=10.000000
     Buoyancy=5.000000
     bHidden=false
     bCollideActors=True
     bBlockActors=false //True

     Physics=PHYS_Falling
}
