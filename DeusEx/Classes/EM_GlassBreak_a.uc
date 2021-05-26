class EM_GlassBreak_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=MeshEmitter Name=MeshEmitter0
//        StaticMesh=StaticMesh'Flam_Statics_A.Glass.glassfrag3'
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-186.278412)
        ExtentMultiplier=(Z=7.000000)
        DampingFactorRange=(X=(Min=-500.000000,Max=-500.000000),Y=(Min=-500.000000,Max=-500.000000),Z=(Min=-500.000000,Max=-500.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=66
        StartLocationRange=(Y=(Min=-22.000000,Max=22.000000))
        StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=0.016000,Max=0.160000),Y=(Min=0.016000,Max=0.160000),Z=(Min=0.016000,Max=0.160000))
        LifetimeRange=(Min=2.380952,Max=2.380952)
        StartVelocityRange=(X=(Min=-12.000000,Max=12.000000),Y=(Min=-32.000000,Max=22.000000),Z=(Min=73.919998,Max=73.919998))
    End Object
    Begin Object Class=MeshEmitter Name=MeshEmitter1
//        StaticMesh=StaticMesh'Flam_Statics_A.Glass.glassfrag1'
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-145.521591)
        ExtentMultiplier=(Z=7.000000)
        DampingFactorRange=(X=(Min=-500.000000,Max=-500.000000),Y=(Min=-500.000000,Max=-500.000000),Z=(Min=-500.000000,Max=-500.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=13
        StartLocationRange=(X=(Min=12.000000,Max=12.000000),Y=(Min=-22.000000,Max=22.000000),Z=(Min=-0.710000,Max=0.710000))
        StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=0.119280,Max=1.192800),Y=(Min=0.119280,Max=1.192800),Z=(Min=0.119280,Max=1.192800))
        StartVelocityRange=(X=(Min=-15.620000,Max=15.620000),Y=(Min=-15.620000,Max=15.620000),Z=(Min=33.064697,Max=33.064697))
    End Object
    Begin Object Class=MeshEmitter Name=MeshEmitter2
//        StaticMesh=StaticMesh'Flam_Statics_A.Glass.glassfrag2'
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-691.056824)
        ExtentMultiplier=(Z=7.000000)
        DampingFactorRange=(X=(Min=-500.000000,Max=-500.000000),Y=(Min=-500.000000,Max=-500.000000),Z=(Min=-500.000000,Max=-500.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=12
        StartLocationRange=(X=(Min=-12.000000,Max=12.000000),Y=(Min=-33.000000,Max=33.000000))
        StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=0.032000,Max=0.521000),Y=(Min=0.032000,Max=0.521000),Z=(Min=0.032000,Max=0.521000))
        LifetimeRange=(Min=1.680672,Max=1.680672)
        StartVelocityRange=(Z=(Min=7.140000,Max=7.140000))
    End Object
    Begin Object Class=MeshEmitter Name=MeshEmitter3
//        StaticMesh=StaticMesh'Flam_Statics_A.Glass.glassfrag4'
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-197.964905)
        ExtentMultiplier=(Z=7.000000)
        DampingFactorRange=(X=(Min=-500.000000,Max=-500.000000),Y=(Min=-500.000000,Max=-500.000000),Z=(Min=-500.000000,Max=-500.000000))
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=12
        StartLocationRange=(X=(Min=-12.000000,Max=12.000000),Y=(Min=1.000000,Max=12.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(Y=(Max=2.814000))
        StartSizeRange=(X=(Min=0.062000,Max=0.620000),Y=(Min=0.062000,Max=0.620000),Z=(Min=0.062000,Max=0.620000))
        LifetimeRange=(Min=1.421464,Max=1.421464)
        StartVelocityRange=(Y=(Min=-77.000000,Max=77.000000),Z=(Min=38.382999,Max=38.382999))
    End Object

    Emitters(0)=MeshEmitter'MeshEmitter0'
    Emitters(1)=MeshEmitter'MeshEmitter1'
    Emitters(2)=MeshEmitter'MeshEmitter2'
    Emitters(3)=MeshEmitter'MeshEmitter3'
}
