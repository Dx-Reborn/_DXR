//=============================================================================
// WeaponNanoSword.
//=============================================================================
class WeaponNanoSword extends DeusExWeapon;

#exec OBJ LOAD FILE=DeusExItemsEx.utx

defaultproperties
{
		 InventoryType=class'WeaponNanoSwordInv'
     ItemName="Dragon's Tooth Sword"
     Mesh=Mesh'DeusExItems.NanoSwordPickup'
     CollisionRadius=32.000000
     CollisionHeight=2.400000
  	 LightEffect=LE_None
	   LightType=LT_SubtlePulse
     LightBrightness=224
     LightHue=160
     LightSaturation=64
     LightRadius=4
     bDynamicLight=true
     Mass=20.000000
//     prePivot=(X=-8,Y=18)
     Skins(0)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     Skins(1)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx2'
     Skins(2)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     Skins(3)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     Skins(4)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx4'
     Skins(5)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx3'
}
