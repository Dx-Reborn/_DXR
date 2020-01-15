class EM_GlassHit_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter80
        Acceleration=(Z=-15.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=0.200000,RelativeSize=0.800000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.500000,Max=0.800000)
        StartVelocityRange=(X=(Max=150.000000))
        VelocityLossRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter81
        Acceleration=(Z=-300.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=36,G=28,R=28,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=36,G=28,R=28,A=255))
        MaxParticles=50
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=0.500000,Max=3.000000))
        StartSizeRange=(X=(Min=1.000000,Max=2.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'DXR_FX.Effects.BrokenGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.400000,Max=0.800000)
        StartVelocityRange=(X=(Max=150.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=150.000000))
     End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter80'
    Emitters(1)=SpriteEmitter'SpriteEmitter81'
}