//=============================================================================
// DeusExPickup.
//=============================================================================
class DeusExPickup extends PlaceableInventory;//Pickup;
//  abstract;

#exec OBJ LOAD FILE=DeusExItems.ukx

function material GetMeshTexture(optional int texnum)
{
  return class'dxutil'.static.GetMeshTexture(self, texnum);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     ItemName="DEFAULT PICKUP NAME - REPORT THIS AS A BUG"
     DrawType=DT_Mesh
     physics=PHYS_Falling
     Texture=Texture'Engine.S_Ammo'
     bCollideActors=false
     bBlockActors=false //True
}
