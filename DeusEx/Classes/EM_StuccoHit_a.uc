class EM_StuccoHit_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter106
        Acceleration=(Z=-10.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
        MaxParticles=20
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=2.000000,Max=3.000000)
        StartVelocityRange=(X=(Max=300.000000),Y=(Min=50.000000,Max=-50.000000),Z=(Min=-50.000000,Max=50.000000))
        VelocityLossRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter107
        Acceleration=(Z=-600.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192))
        MaxParticles=40
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=2.000000))
        StartSizeRange=(X=(Min=0.500000,Max=2.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.MiscChips'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.300000,Max=0.500000)
        StartVelocityRange=(X=(Max=200.000000),Y=(Min=100.000000,Max=-100.000000),Z=(Max=150.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter108
        Acceleration=(Z=-600.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=64))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192))
        MaxParticles=40
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=2.000000))
        UniformSize=True
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.MiscChips'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRange=(Y=(Min=10.000000,Max=-10.000000),Z=(Min=10.000000,Max=-10.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter106'
    Emitters(1)=SpriteEmitter'SpriteEmitter107'
    Emitters(2)=SpriteEmitter'SpriteEmitter108'
}
