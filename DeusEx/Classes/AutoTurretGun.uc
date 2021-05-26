//=============================================================================
// AutoTurretGun.
//=============================================================================
class AutoTurretGun extends HackableDevices;
//                               NotPlaceable; // Don't place it to the map, use AutoTurret instead!


var EM_AutoTurret_MuzzleFlash mFlash;

function ResetScaleGlow();

event Destroyed()
{
    local AutoTurret turret;

    if (mFlash != None)
    {
        DetachFromBone(mFlash);
        mFlash.Kill();
    }

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

    if (mFlash == None)
        mFlash = Spawn(class'EM_AutoTurret_MuzzleFlash',,'', Location);
        mFlash.bHidden = true;

    AttachToBone(mFlash, 'Bone002');

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
     FragType=class'DeusEx.MetalFragment'
     ItemName="Autonomous Defense Turret"
     Physics=PHYS_Rotating
     //mesh=mesh'DeusExDeco.AutoTurretGun'
     mesh=SkeletalMesh'DXR_AnimDeco.AutoTurretGun_HD'
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
/*     Skins[0]=Texture'DeusExDeco.Skins.AutoTurretGunTex1'
     Skins[1]=Texture'DeusExDeco.Skins.PinkMaskTex'
     Skins[2]=Texture'DeusExDeco.Skins.PinkMaskTex'*/
     Skins[0]=Shader'DXR_AnimDeco.Glass.AutoTurretGun_HD_SH'
     Skins[1]=texture'PinkMaskTex';

     bShouldBeAlwaysUpdated=true
}
