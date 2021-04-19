//=============================================================================
// BarrelFire.
//=============================================================================
class BarrelFire extends Barrels;

enum EBarrelFireType
{
    BFT_Always, // Spawn extra flame emitter
    BFT_Random, // Same as first, but randomly
    BFT_Off, // No flame emitter, just regular BarrelFire
    BFT_NoFlame // No flame at all
};

var() EBarrelFireType TypeOfFire;
var EM_TorchFire flame;
var float lastDamageTime;

function DamageOther(Actor Other)
{
    if ((Other != None) && !Other.IsA('ScriptedPawn'))
    {
        // only take damage every second
        if (Level.TimeSeconds - lastDamageTime >= 1.0)
        {
            Other.TakeDamage(5, None, Location, vect(0,0,0), class'DM_Burned');
            lastDamageTime = Level.TimeSeconds;
        }
    }
}

function SpawnFlame()
{
   if (TypeOfFire == BFT_Always)
       flame = Spawn(class'EM_TorchFire', Self,,, rot(16384,0,0));
   else if ((TypeOfFire == BFT_Random) && (FRand() > 0.5))
       flame = Spawn(class'EM_TorchFire', Self,,, rot(16384,0,0));
   else if (TypeOfFire == BFT_Off)
        return; // Do nothing
   else if (TypeOfFire == BFT_NoFlame)
   {
       bUnlit = false;
       LightRadius = 0;
       LightType = LT_None;
      // Skins[2] = texture'PinkMaskTex';
       Mass = 60.00;
       return;
   }
   if (flame != None)
   {
       flame.SetBase(self);
   }
}

event BeginPlay()
{
   Super.BeginPlay();
   SpawnFlame();
}

singular function SupportActor(Actor Other)
{
   if (TypeOfFire != BFT_NoFlame)
       DamageOther(Other);

    Super.SupportActor(Other);
}

singular function Bump(Actor Other)
{
   if (TypeOfFire != BFT_NoFlame)
       DamageOther(Other);

    Super.Bump(Other);
}


defaultproperties
{
   bBlockSight=true
   HitPoints=40 // DXR: What the point if it already unbreakable?
   bInvincible=True
   bFlammable=False
   ItemName="Burning Barrel"
   AmbientSound=Sound'Ambient.Ambient.FireSmall2'
//   mesh=mesh'DeusExDeco.BarrelFire'
   ScaleGlow=2.000000
//   bUnlit=True
   SoundRadius=16
   SoundVolume=255
   CollisionRadius=20.000000
   CollisionHeight=29.000000
   LightEffect=LE_None
   LightType=LT_SubtlePulse
   LightPeriod=2
   LightBrightness=128
   LightHue=32
   LightSaturation=64
   LightRadius=3
   Mass=260.000000
   Buoyancy=270.000000
//   skins[0]=Texture'DeusExDeco.Skins.BarrelFireTex1'
//   skins[1]=Texture'DeusExDeco.Skins.BarrelFireTex1'
//   skins[2]=Shader'Effects_EX.Fire.flameJ_SH'
   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DeusExStaticMeshes0.BarrelFire_HD'
   bDynamicLight=true
   TypeOfFire=BFT_Random
   SurfaceType=EST_Metal
}



