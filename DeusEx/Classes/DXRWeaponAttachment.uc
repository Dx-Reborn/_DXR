class DXRWeaponAttachment extends WeaponAttachment;

var() Rotator ShootRotation;
var vector StartTrace, EndTrace, EndTraceExtra;

event ThirdPersonEffects()
{
    CheckForSplash();
}

function CheckForSplash()
{
    local Actor HitActor;
    local vector HitNormal, HitLocation, SpawnLoc;
    local Actor se;
    local int i;
    
    if (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (SplashEffect != None) && !Instigator.PhysicsVolume.bWaterVolume)
    {
        StartTrace = Instigator.Location;
        EndTrace = StartTrace + Vector(Instigator.GetViewRotation()) * DeusExWeaponInv(instigator.weapon).MaxRange;

        StartTrace.Z += Instigator.BaseEyeHeight;
        EndTrace.Z += Instigator.BaseEyeHeight;

        // check for splash
        bTraceWater = true;
        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace,true);
        bTraceWater = false;

        if ((FluidSurfaceInfo(HitActor) != None) || ((PhysicsVolume(HitActor) != None) && PhysicsVolume(HitActor).bWaterVolume))
        {
            if (DeusExWeaponInv(Instigator.weapon).AreaOfEffect == AOE_Cone)
            {
                for(i=0; i<5; i++)
                {
                    SpawnLoc = HitLocation;
                    SpawnLoc.X += randRange(DeusExWeaponInv(Instigator.weapon).CurrentAccuracy * 50, -DeusExWeaponInv(Instigator.weapon).CurrentAccuracy * 50);
                    SpawnLoc.Y += randRange(DeusExWeaponInv(Instigator.weapon).CurrentAccuracy * 50, -DeusExWeaponInv(Instigator.weapon).CurrentAccuracy * 50);
                    se = Spawn(SplashEffect,,,SpawnLoc);
//                    log(se @ DeusExWeaponInv(Instigator.weapon).CurrentAccuracy);

                }
            }
            else
            se = Spawn(SplashEffect,,,HitLocation);
        }
    }
}


defaultproperties
{
     SplashEffect=class'EM_WaterHit'
}