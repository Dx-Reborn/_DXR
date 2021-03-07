class EM_WindowBreak extends DeusExEmitter;


defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter441
        Acceleration=(Z=-300.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=36,G=28,R=28,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=36,G=28,R=28,A=255))
        MaxParticles=12
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=16.000000,Max=-16.000000),Y=(Min=40.000000,Max=-40.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000))
        StartSizeRange=(X=(Min=5.000000,Max=20.000000))
        UniformSize=True
        InitialParticlesPerSecond=50.000000
        AutomaticInitialSpawning=False
        Texture=Texture'DXR_FX.Effects.BrokenGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.800000,Max=1.200000)
        StartVelocityRange=(X=(Min=10.000000,Max=-10.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Max=-50.000000))
    End Object
    Begin Object Class=Engine.MeshEmitter Name=MeshEmitter176
        StaticMesh=StaticMesh'BallisticHardware2.Glass.GlassFragC_TR'
        Acceleration=(Z=-300.000000)
        MaxParticles=15
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=16.000000,Max=-16.000000),Y=(Min=40.000000,Max=-40.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSpinRange=(X=(Max=16000.000000),Y=(Max=16000.000000))
        StartSizeRange=(X=(Max=0.10),Y=(Max=0.15))
        //StartSizeRange=(X=(Max=6.000000),Y=(Max=6.000000))
        InitialParticlesPerSecond=50.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=1.000000,Max=1.200000)
        StartVelocityRange=(X=(Min=10.000000,Max=-10.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Max=-50.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter441'
    Emitters(1)=MeshEmitter'MeshEmitter176'
}