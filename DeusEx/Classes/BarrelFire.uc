//=============================================================================
// BarrelFire.
//=============================================================================
class BarrelFire extends Containers;

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

function beginPlay()
{
	Local EM_TorchFire flame;

		Super.BeginPlay();

		flame = Spawn(class'EM_TorchFire', Self,,, rot(16384,0,0));
		if (flame != None)
		{
			flame.SetBase(self);
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
     mesh=mesh'DeusExDeco.BarrelFire'
     ScaleGlow=2.000000
     bUnlit=True
     SoundRadius=16
     SoundVolume=255
     CollisionRadius=20.000000
     CollisionHeight=29.000000
    LightEffect=LE_None
    LightType=LT_SubtlePulse
//    texture=Texture'Effects_EX.Fire.fire_pal_loop'
    LightPeriod=2
     LightBrightness=128
     LightHue=32
     LightSaturation=64
     LightRadius=3
     Mass=260.000000
     Buoyancy=270.000000
		 skins[0]=Texture'DeusExDeco.Skins.BarrelFireTex1'
		 skins[1]=Texture'DeusExDeco.Skins.BarrelFireTex1'
     skins[2]=Shader'Effects_EX.Fire.flameJ_SH'

     bDynamicLight=true
}
