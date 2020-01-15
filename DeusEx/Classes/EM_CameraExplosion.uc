class EM_CameraExplosion extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter518
        UseColorScale=True
        ColorScale(0)=(Color=(A=200))
        ColorScale(1)=(RelativeTime=1.000000)
        CoordinateSystem=PTCS_Relative
        RespawnDeadParticles=False
        StartLocationOffset=(Y=-10.000000,Z=10.000000)
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=3.500000)
        StartVelocityRange=(X=(Min=20.000000,Max=-20.000000),Y=(Max=-20.000000),Z=(Max=20.000000))
        VelocityLossRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter519
        Acceleration=(Z=-400.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=102,G=102,R=102))
        ColorScale(1)=(RelativeTime=1.000000)
        CoordinateSystem=PTCS_Relative
        MaxParticles=50
        RespawnDeadParticles=False
        StartLocationOffset=(Y=-10.000000,Z=10.000000)
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=2.000000))
        StartSizeRange=(X=(Min=2.000000,Max=5.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'DXR_FX.Effects.BrokenGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.500000,Max=0.500000)
        StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Max=-150.000000),Z=(Min=-150.000000,Max=150.000000))
    End Object
    Begin Object Class=Engine.SparkEmitter Name=SparkEmitter63
        TimeBetweenSegmentsRange=(Min=0.100000,Max=0.100000)
        Acceleration=(Z=-200.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(G=255,R=255))
        ColorScale(1)=(RelativeTime=0.500000,Color=(G=128,R=255))
        ColorScale(2)=(RelativeTime=1.000000)
        CoordinateSystem=PTCS_Relative
        RespawnDeadParticles=False
        StartLocationOffset=(Y=-10.000000,Z=10.000000)
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.300000,Max=0.400000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Max=-200.000000),Z=(Min=-50.000000,Max=50.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter518'
    Emitters(1)=SpriteEmitter'SpriteEmitter519'
    Emitters(2)=SparkEmitter'SparkEmitter63'
}