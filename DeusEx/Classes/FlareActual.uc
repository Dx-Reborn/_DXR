/**/

class flareActual extends DeusExDecoration;

var EM_FlareSmoke gen;

event PhysicsVolumeChange(PhysicsVolume NewVolume)
{
    if (NewVolume.bWaterVolume)
        ExtinguishFlare();

        Super.PhysicsVolumeChange(NewVolume);
}

function ExtinguishFlare()
{
    LightType = LT_None;
    AmbientSound = None;
    if (gen != None)
        gen.Kill();
}

event Destroyed()
{
  super.Destroyed();
    if (gen != None)
        gen.Kill();
}

/*function int StandingCount()
{
  return 1;
} */

defaultproperties
{
     ItemName="Used Flare"
     Mesh=Mesh'DeusExItems.Flare'
     CollisionRadius=6.200000
     CollisionHeight=1.200000
     Mass=2.000000
     Buoyancy=1.000000

     HitPoints=10
     FragType=Class'DeusEx.PaperFragment'
     LightBrightness=200
     LightHue=16
     LightSaturation=96
     LightRadius=4
     bDynamicLight=true

     bCanbeBase=true

     SoundRadius=8
}