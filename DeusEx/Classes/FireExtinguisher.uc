//=============================================================================
// Liquor40oz.
//=============================================================================
class FireExtinguisher extends DeusExPickup;

var bool bBeenDamaged;
var EM_FireExtExplosion FireExtEffect;
var vector aHitNormal;
var FireExtinguisher_DMG replacement; // ѕри повреждении заменить на использованный.

function BecomePickup()
{
    Super.BecomePickup();
    SetCollision(true, true);
}

event Timer()
{
    Destroy();
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    if (bBeenDamaged) // DXR: Ётого не должно произойти!
        return;

    if (damageType == class'DM_Shot')
        FireExtEffect = Spawn(class'EM_FireExtExplosion',,,hitlocation, Rotator(-aHitNormal) + rot(0, -16384, 0)); // ¬ычесть Yaw 16384
    if (FireExtEffect != None)
    {
        bBeenDamaged = true;
        SetCollision(false, false); // 
        replacement = spawn(class'FireExtinguisher_DMG',,,Location, Rotation);
        if (replacement != None)
        {
            replacement.PlaySound(Sound'STALKER_Sounds.Hit.Steam01',SLOT_None, 1.5,,, 0.5);
            Destroy();
        }
    }
}

state Activated
{
    function Activate()
    {
        // can't turn it off
    }

    function BeginState()
    {
        local ProjectileGenerator gen;
        local Vector loc;
        local Rotator rot;

        Super.BeginState();

        // force-extinguish the player
        if (DeusExPlayer(Owner) != None)
            if (DeusExPlayer(Owner).bOnFire)
                DeusExPlayer(Owner).ExtinguishFire();

        // spew halon gas
        rot = Pawn(Owner).GetViewRotation();
        loc = Vector(rot) * Owner.CollisionRadius;
        loc.Z += Owner.CollisionHeight * 0.9;
        loc += Owner.Location;
        gen = Spawn(class'ProjectileGenerator', None,, loc, rot);
        if (gen != None)
        {
            gen.ProjectileClass = class'HalonGas';
            gen.SetBase(Owner);
            gen.LifeSpan = 3;
            gen.ejectSpeed = 300;
            gen.projectileLifeSpan = 1.5;
            gen.frequency = 0.9;
            gen.checkTime = 0.1;
            gen.bAmbientSound = True;
            gen.AmbientSound = sound'SteamVent2';
            gen.SoundVolume = 192;
            gen.SoundPitch = 32;
        }

        // blast for 3 seconds, then destroy
        SetTimer(3.0, False);
    }
Begin:
}


state DeActivated
{
}


defaultproperties
{
    bActivatable=True

    Description="A chemical fire extinguisher."
    beltDescription="FIRE EXT"
    ItemName="Fire Extinguisher"
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    Icon=Texture'DeusExUI.Icons.BeltIconFireExtinguisher'
    largeIcon=Texture'DeusExUI.Icons.LargeIconFireExtinguisher'
    largeIconWidth=25
    largeIconHeight=49
    LandSound=Sound'DeusExSounds.Generic.GlassDrop'
//    Mesh=Mesh'DeusExItems.FireExtinguisher'
//    PickupViewMesh=Mesh'DeusExItems.FireExtinguisher'
//    FirstPersonViewMesh=Mesh'DeusExItems.FireExtinguisher'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_Pickups.FireExtinguisher_HD'
    PickupViewStaticMesh=StaticMesh'DXR_Pickups.FireExt_HD_Pickup'
    FirstPersonViewStaticMesh=StaticMesh'DXR_Pickups.FireExtinguisher_HD'
    bUseFirstPersonStaticMesh=true
    bUsePickupViewStaticMesh=true
//    CollisionRadius=8.000000
    CollisionRadius=3.10
    CollisionHeight=10.27
    SurfaceType=EST_Metal
    Mass=10.000000
    Buoyancy=8.000000
}
