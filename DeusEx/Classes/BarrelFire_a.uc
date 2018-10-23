//=============================================================================
// ≈ще одна BarrelFire с моделью из UT2004.
//=============================================================================
class BarrelFire_a extends Containers;

var float lastDamageTime;
var() bool bUseFlame;

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

function beginPlay()
{
	Local EM_TorchFire flame;

  Super.BeginPlay();

	if (bUseFlame)
	{
		flame = Spawn(class'EM_TorchFire', Self,,, rot(16384,0,0));
		if (flame != None)
		{
			flame.SetBase(self);
		}
	}
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
     bBlockSight=True
     HitPoints=40
     bInvincible=True
     bFlammable=False
     ItemName="Burning Barrel"
     AmbientSound=Sound'Ambient.Ambient.FireSmall2'

     //DrawType=DT_StaticMesh
     //StaticMesh=StaticMesh'AW-RustMeshes.Complex.AW-Firebarrel'

     ScaleGlow=2.000000
     bUnlit=false
     SoundRadius=16
     SoundVolume=255
    LightEffect=LE_None
    LightType=LT_SubtlePulse
//    texture=Texture'Effects_EX.Fire.fire_pal_loop'
    LightPeriod=3
     LightBrightness=128
     LightHue=32
     LightSaturation=64
     LightRadius=2
     Mass=260.000000
     Buoyancy=270.000000

    DrawScale=0.400000
    PrePivot=(Z=80.000000)
    CollisionRadius=26.000000
    CollisionHeight=32.000000
    bUseCylinderCollision=True

     bDynamicLight=true
}