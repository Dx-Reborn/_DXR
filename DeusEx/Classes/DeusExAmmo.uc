//=============================================================================
// DeusExAmmo.
// Ѕоеприпасы, предназначенные дл€ размещени€ на карте
// TODO: —оздать и прописать классы, отображаемые в инвентаре
// var() class<Inventory> InventoryType;
//=============================================================================
class DeusExAmmo extends PlaceableInventory;//Ammo;

#exec obj load file=DeusExSounds


defaultproperties
{
     ItemName="DEFAULT AMMO NAME - REPORT THIS AS A BUG"
  	 DrawType=DT_Mesh
     Texture=Engine.S_Ammo
     CollisionRadius=22.000000
     AmbientGlow=0
     CullDistance=0
     Lifespan=0.0
     Physics=PHYS_FALLING
		 bUseDynamicLights=true
}
