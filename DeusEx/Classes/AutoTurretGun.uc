//=============================================================================
// AutoTurretGun.
//=============================================================================
class AutoTurretGun extends HackableDevices;

event Destroyed()
{
    local AutoTurret turret;

    turret = AutoTurret(Owner);
    if (turret != None)
    {
        turret.gun = None;
        turret.Destroy();
        SetOwner(None);
    }

    Super.Destroyed();
}

function HackAction(Actor Hacker, bool bHacked)
{
    local AutoTurret turret;

    Super.HackAction(Hacker, bHacked);

    turret = AutoTurret(Owner);
    if (bHacked && (turret != None))
    {
        if (!turret.bDisabled)
        {
            turret.UnTrigger(Hacker, Pawn(Hacker));
            turret.bDisabled = True;
        }
        else
        {
            turret.bDisabled = False;
            turret.Trigger(Hacker, Pawn(Hacker));
        }
    }
}

event PostBeginPlay()
{
    local AutoTurret turret;

    Super.PostBeginPlay();
    turret = AutoTurret(Owner);
}

event BeginPlay();
//simulated event FellOutOfWorld(eKillZType KillType);

defaultproperties
{
     hackStrength=0.500000
     bVisionImportant=True
     HitPoints=50
     minDamageThreshold=50
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Autonomous Defense Turret"
     Physics=PHYS_Rotating
     mesh=mesh'DeusExDeco.AutoTurretGun'
//     PrePivot=(Z=-8.770000)
     SoundRadius=24
     bUseCylinderCollision=true
     CollisionRadius=22.500000
     CollisionHeight=9.100000
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=28
     LightSaturation=160
     LightRadius=2
     bRotateToDesired=True
     Mass=50.000000
     Buoyancy=10.000000
     RotationRate=(Pitch=16384,Yaw=16384)
     Rotation=(Roll=32768)
     Skins[0]=Texture'DeusExDeco.Skins.AutoTurretGunTex1'
     Skins[1]=Texture'DeusExDeco.Skins.PinkMaskTex'
     Skins[2]=Texture'DeusExDeco.Skins.PinkMaskTex'

}
