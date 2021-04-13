/*
*/

class EM_DestroyedDeco extends DeusExEmitter;

function SetSound(sound NewSound)
{
   if (NewSound != None)
       Emitters[0].Sounds[0].Sound = NewSound;
}

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'DeusExStaticMeshes0.WBasket_HD'
        UseParticleColor=True
        UseCollision=True
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-1500.000000)
        DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.300000,Max=0.300000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.800000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        MaxParticles=1
        StartLocationOffset=(Z=40.000000)
        SpinCCWorCW=(Y=0.000000)
        SpinsPerSecondRange=(X=(Max=0.500000),Y=(Min=0.300000,Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=0.500000))
        Sounds(0)=(Sound=Sound'DeusExSounds.Weapons.CrowbarHitSoft',Radius=(Min=512.000000,Max=512.000000),Pitch=(Min=1.000000,Max=1.200000),Volume=(Min=2.000000,Max=2.000000),Probability=(Min=1.000000,Max=1.000000))
        SpawningSound=PTSC_LinearLocal
        SpawningSoundProbability=(Min=1.000000,Max=1.000000)
        InitialParticlesPerSecond=5000.000000
        DrawStyle=PTDS_AlphaBlend
        LifetimeRange=(Min=2.500000,Max=2.500000)
        StartVelocityRange=(X=(Min=200.000000,Max=200.000000),Z=(Min=600.000000,Max=900.000000))
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter0'
}