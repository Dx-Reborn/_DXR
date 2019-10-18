class EM_RedSplash extends DeusExEmitter;


defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        UniformSize=True
        ScaleSizeXByVelocity=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(R=255))
        ColorScale(1)=(RelativeTime=0.821429,Color=(R=255))
        ColorScale(2)=(RelativeTime=1.000000)
        MaxParticles=25
        Name="SpriteEmitter3"
        UseRotationFrom=PTRS_Actor
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.400000,RelativeSize=0.700000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.300000)
        StartSizeRange=(X=(Min=4.000000,Max=5.000000))
        ScaleSizeByVelocityMultiplier=(X=0.010000,Y=0.010000)
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'ut2k4Extra.SparkHead'
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRange=(X=(Min=-30.000000,Max=30.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=85.000000,Max=140.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        UseColorScale=True
        SpinParticles=True
        UseSizeScale=True
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(R=255))
        ColorScale(1)=(RelativeTime=0.821429,Color=(R=255))
        ColorScale(2)=(RelativeTime=1.000000)
        Name="SpriteEmitter4"
        StartLocationRange=(Z=(Max=15.000000))
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.800000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000))
        InitialParticlesPerSecond=50.000000
        Texture=Texture'ut2k4Extra.xSplashBase'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRange=(Z=(Min=50.000000,Max=85.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255))
        FadeOutStartTime=0.500000
        MaxParticles=12
        Name="SpriteEmitter5"
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=20.000000,Max=30.000000))
        InitialParticlesPerSecond=500.000000
        Texture=Texture'ut2k4Extra.xWaterDrops2'
        TextureUSubdivisions=1
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.200000,Max=1.200000)
        StartVelocityRange=(X=(Min=-24.000000,Max=24.000000),Y=(Min=-24.000000,Max=24.000000),Z=(Min=70.000000,Max=115.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter5'
}