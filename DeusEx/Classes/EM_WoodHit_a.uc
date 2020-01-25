class EM_WoodHit_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter235
        Acceleration=(Z=-15.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=64))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
        MaxParticles=20
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.500000,Max=0.800000)
        StartVelocityRange=(X=(Max=150.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
        VelocityLossRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter236
        Acceleration=(Z=-600.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=92,G=143,R=158,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=92,G=143,R=158,A=255))
        MaxParticles=30
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000))
        StartSizeRange=(X=(Min=1.000000,Max=5.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.WoodSplinters'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.300000,Max=0.600000)
        StartVelocityRange=(X=(Max=150.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=150.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter235'
    Emitters(1)=SpriteEmitter'SpriteEmitter236'
}