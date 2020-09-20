//=============================================================================
// Shuriken.
//=============================================================================
class Shuriken extends DeusExProjectile;

// set it's rotation correctly
// DXR: Now using correctly rotated mesh.
event Tick(float deltaTime)
{
//    local Rotator rot;

    if (bStuck)
        return;

    Super.Tick(deltaTime);

/*    rot = Rotation;
    rot.Roll += 16384;
    rot.Pitch -= 16384;
    SetRotation(rot);*/
}

function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
    local spark spark;
    local vector mEndTrace, mHitLocation, mHitNormal;

    mEndTrace = Location + 30 * vector(Rotation);

    Trace(mHitLocation, mHitNormal, mEndTrace, , false, ,);
    spark = Spawn(class'spark',self,'',mHitLocation + mHitNormal, rotator(mHitNormal));
    spark.ExcludeTag[7] = 'NoDecal';
}

defaultproperties
{
     bBlood=True
     bStickToWall=True
     DamageType=class'DM_shot'
     AccurateRange=640
     MaxRange=1280
     spawnWeaponClass=Class'DeusEx.WeaponShuriken'
     bIgnoresNanoDefense=True
     ItemName="Throwing Knife"
     speed=750.000000
     MaxSpeed=750.000000
     Damage=15.000000
     MomentumTransfer=1000
     ImpactSound=Sound'DeusExSounds.Generic.BulletHitFlesh'
     Mesh=Mesh'DeusExItems.ShurikenPickup'
     CollisionRadius=5.000000
     CollisionHeight=2.300000 // DXR: Так можно подобрать предмет, застрявший в StaticMeshActor
//     CollisionHeight=0.300000
}
