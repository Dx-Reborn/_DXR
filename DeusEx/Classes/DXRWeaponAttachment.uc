class DXRWeaponAttachment extends WeaponAttachment;

var() Rotator ShootRotation;
var vector StartTrace, EndTrace, EndTraceExtra;

event ThirdPersonEffects()
{
    if (Instigator == None)
    return; // DXR: Никого нет, не посылать спам в лог.

    CheckForSplash();
    FixRelativeRotation(Instigator);
}

function FixRelativeRotation(Pawn Inst);

function CheckForSplash()
{
    local Actor HitActor;
    local vector HitNormal, HitLocation, SpawnLoc;
    local Actor se;
    local int i;
    
    if (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (SplashEffect != None) && !Instigator.PhysicsVolume.bWaterVolume)
    {
        StartTrace = Instigator.Location;
        EndTrace = StartTrace + Vector(Instigator.GetViewRotation()) * DeusExWeapon(instigator.weapon).MaxRange;

        StartTrace.Z += Instigator.BaseEyeHeight;
        EndTrace.Z += Instigator.BaseEyeHeight;

        // check for splash
        bTraceWater = true;
        HitActor = Trace(HitLocation, HitNormal, EndTrace, StartTrace,true);
        bTraceWater = false;

        if ((FluidSurfaceInfo(HitActor) != None) || ((PhysicsVolume(HitActor) != None) && PhysicsVolume(HitActor).bWaterVolume))
        {
            if (DeusExWeapon(Instigator.weapon).AreaOfEffect == AOE_Cone)
            {
                for(i=0; i<5; i++)
                {
                    SpawnLoc = HitLocation;
                    SpawnLoc.X += randRange(DeusExWeapon(Instigator.weapon).CurrentAccuracy * 50, -DeusExWeapon(Instigator.weapon).CurrentAccuracy * 50);
                    SpawnLoc.Y += randRange(DeusExWeapon(Instigator.weapon).CurrentAccuracy * 50, -DeusExWeapon(Instigator.weapon).CurrentAccuracy * 50);
                    se = Spawn(SplashEffect,,,SpawnLoc);
//                    log(se @ DeusExWeapon(Instigator.weapon).CurrentAccuracy);

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