//=============================================================================
// WeaponNanoSword.
//=============================================================================
class WeaponNanoSwordAtt extends WeaponAttachment;

#exec OBJ LOAD FILE=DeusExItemsEx.utx

defaultproperties
{
     Mesh=Mesh'DeusExItems.NanoSwordPickup'
  	 LightEffect=LE_None
	   LightType=LT_SubtlePulse
     LightBrightness=224
     LightHue=160
     LightSaturation=64
     LightRadius=4
     bDynamicLight=true
     Skins(0)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     Skins(1)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx2'
     Skins(2)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     Skins(3)=Texture'DeusExItems.Skins.NanoSword3rdTex1'
     Skins(4)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx4'
     Skins(5)=Shader'DeusExItemsEX.ExSkins.NanoSwordEx3'

     relativerotation=(roll=20000,pitch=-10000,yaw=-2200)
     relativelocation=(x=25,y=3,z=4)
     bHardAttach=true
}
