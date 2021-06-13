//=============================================================================
// BarrelFire.
//=============================================================================
class BarrelFire extends Barrels;

enum EBarrelFireType
{
    BFT_Always, // Spawn extra flame emitter
    BFT_Random, // Same as first, but randomly
    BFT_NoFlame // No flame at all
};

var() EBarrelFireType TypeOfFire;
var EM_TorchFire flame;
var float lastDamageTime;

function DamageOther(Actor Other)
{
    if ((Other != None) && !Other.IsA('ScriptedPawn') && (flame != None))
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
    switch (TypeOfFire)
    {
        case BFT_Always:
           flame = Spawn(class'EM_TorchFire', Self,,, rot(16384,0,0));
           flame.AmbientSound = default.AmbientSound;
           flame.SoundVolume = default.SoundVolume;
           flame.SetBase(self);
        break;

        case BFT_Random:
           if (FRand() > 0.5)
           {
               flame = Spawn(class'EM_TorchFire', Self,,, rot(16384,0,0));
               flame.AmbientSound = default.AmbientSound;
               flame.SoundVolume = default.SoundVolume;
               flame.SetBase(self);
           }
           else
                TurnOff();
        break;

        case BFT_NoFlame:
                TurnOff();
        break;

    }
}

function TurnOff()
{
    bUnlit = false;
    LightRadius = 0;
    LightBrightness = 0;
    LightType = LT_None;
 // Skins[2] = texture'PinkMaskTex';
    Mass = 60.00;
    AmbientSound = None;
}


event PostSetInitialState()
{
    LightHue = default.LightHue;
    LightSaturation = default.LightRadius;
    LightRadius = default.LightRadius;

    Super.PostSetInitialState();
    SpawnFlame();
}

singular function SupportActor(Actor Other)
{
    DamageOther(Other);
    Super.SupportActor(Other);
}

singular function Bump(Actor Other)
{
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
//   LightPeriod=2
   LightBrightness=128
//   LightHue=32
//   LightSaturation=64
//   LightRadius=1 //3
   LightHue=15
   LightSaturation=42
   LightRadius=5.000000
   Mass=260.000000
   Buoyancy=270.000000
//   skins[0]=Texture'DeusExDeco.Skins.BarrelFireTex1'
//   skins[1]=Texture'DeusExDeco.Skins.BarrelFireTex1'
//   skins[2]=Shader'Effects_EX.Fire.flameJ_SH'
   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DeusExStaticMeshes0.BarrelFire_HD'
   bDynamicLight=true
   TypeOfFire=BFT_Always
   SurfaceType=EST_Metal
}
