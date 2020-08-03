//=============================================================================
// GraySpit.
//=============================================================================
class GraySpit extends DeusExProjectile;

event Tick(float deltaTime)
{
    time += deltaTime;

    // scale it up as it flies
    SetDrawScale(FClamp(2.0*(time+1.0), 1.0, 20.0)); //CyberP: modded
}

defaultproperties
{
     DamageType=class'DM_Radiation'
     AccurateRange=300
     MaxRange=450
     bIgnoresNanoDefense=True
     speed=350.000000
     MaxSpeed=400.000000
     Damage=8.000000
     MomentumTransfer=200
     SpawnSound=Sound'DeusExSounds.Animal.GrayShoot'
     Style=STY_Translucent
     Mesh=Mesh'DeusExItems.GraySpit'
     ScaleGlow=2.000000
     bFixedRotationDir=True
     RotationRate=(Pitch=0,Yaw=0,Roll=131071)
}
