class EM_FlyingLetters extends DeusExEmitter;

defaultproperties
{
    Begin Object class=Engine.MeshEmitter Name=MeshEmitter60
        StaticMesh=StaticMesh'DXR_TrashObjects.Scripted.MailLetter_a'
        Acceleration=(Z=-50.000000)
        ExtentMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.100000,Max=0.100000))
        MaxParticles=12
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(Y=(Max=2.000000),Z=(Max=0.100000))
        StartSpinRange=(X=(Max=32000.000000),Y=(Max=32000.000000),Z=(Max=32000.000000))
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Max=6.000000)
        StartVelocityRange=(X=(Min=20.000000,Max=-20.000000),Y=(Min=20.000000,Max=-20.000000),Z=(Min=150.000000,Max=300.000000))
        VelocityLossRange=(Z=(Max=4.000000))
    End Object
    Begin Object class=Engine.MeshEmitter Name=MeshEmitter61
        StaticMesh=StaticMesh'DXR_TrashObjects.Scripted.MailLetter_a'
        Acceleration=(Z=-50.000000)
        MaxParticles=12
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(Y=(Max=2.000000),Z=(Max=0.100000))
        StartSpinRange=(X=(Max=32000.000000),Y=(Max=32000.000000),Z=(Max=32000.000000))
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Max=6.000000)
        StartVelocityRange=(X=(Min=60.000000,Max=-60.000000),Y=(Min=60.000000,Max=-60.000000),Z=(Max=300.000000))
        VelocityLossRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=4.000000))
    End Object
    Emitters(0)=MeshEmitter'MeshEmitter60'
    Emitters(1)=MeshEmitter'MeshEmitter61'
}