//=============================================================================
// BarrelVirus.
//=============================================================================
class BarrelVirus extends Barrels;

defaultproperties
{
     bBlockSight=True
     HitPoints=30
     bInvincible=True
     bFlammable=False
     ItemName="NanoVirus Storage Container"
     mesh=mesh'DeusExDeco.BarrelAmbrosia'
     Skins(0)=Texture'DeusExDeco.Skins.BarrelAmbrosiaTex1'
     skins(1)=FireTexture'Effects.liquid.Virus_SFX'
     CollisionRadius=16.000000
     CollisionHeight=28.770000
     LightType=LT_Steady
     LightEffect=LE_WateryShimmer
     LightBrightness=96
     LightRadius=4
     Mass=80.000000
     Buoyancy=90.000000
}
