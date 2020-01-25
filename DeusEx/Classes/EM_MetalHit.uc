class EM_MetalHit extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter149
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.500000
        MaxParticles=4
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=0.150000,Max=0.150000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=15.000000,Max=25.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.metalsmokefinal'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=100.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.475000,RelativeVelocity=(X=0.100000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter149'

    Begin Object Class=SparkEmitter Name=SparkEmitter9
        LineSegmentsRange=(Min=0.000000,Max=0.000000)
        TimeBetweenSegmentsRange=(Min=0.100000,Max=0.100000)
        FadeOut=True
        RespawnDeadParticles=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.250000
        FadeInEndTime=0.250000
        MaxParticles=4
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=1.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'DXR_FX.Effects.eb2e032c'
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=100.000000,Max=250.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
    End Object
    Emitters(1)=SparkEmitter'SparkEmitter9'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter150
        UseCollision=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-1300.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.400000
        MaxParticles=2
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=0.250000,Max=0.500000))
        InitialParticlesPerSecond=300.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Effects.sparks_multy_tiled'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=150.000000,Max=250.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=-150.000000,Max=150.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter150'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter151
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.000000,Max=5.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Effects.Explosion_ball'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter151'

    LifeSpan=0.75
}

