class EM_ExplosionDust extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter300
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=130,G=160,R=191,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=130,G=160,R=191,A=255))
        FadeOutFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeOutStartTime=0.800000
        MaxParticles=1
        StartLocationOffset=(Z=-10.000000)
        SpinsPerSecondRange=(Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScale(1)=(RelativeTime=0.800000,RelativeSize=3.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.DirtExplosion'
        LifetimeRange=(Min=1.200000,Max=1.200000)
        StartVelocityRange=(Z=(Min=1.000000,Max=1.000000))
        Name="SpriteEmitter300"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter300'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter301
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        Acceleration=(Z=-750.000000)
        ColorScale(0)=(Color=(B=120,G=120,R=120,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=120,G=120,R=120,A=255))
        FadeOutStartTime=0.500000
        MaxParticles=15
        StartLocationOffset=(Z=-64.000000)
        SpinsPerSecondRange=(X=(Min=0.250000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=75.000000))
        InitialParticlesPerSecond=200.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.DirtExplosion'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionStart=1
        SubdivisionEnd=1
        LifetimeRange=(Min=2.500000,Max=2.500000)
        InitialDelayRange=(Min=0.400000,Max=0.400000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=200.000000,Max=1200.000000))
        Name="SpriteEmitter301"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter301'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter302
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        Acceleration=(Z=-750.000000)
        ColorScale(0)=(Color=(B=130,G=160,R=191,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=130,G=160,R=191,A=255))
        FadeOutStartTime=0.800000
        MaxParticles=20
        StartLocationOffset=(Z=-64.000000)
        SpinsPerSecondRange=(X=(Min=0.250000,Max=0.500000))
        SizeScale(0)=(RelativeSize=2.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=75.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.DirtExplosion'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionStart=3
        SubdivisionEnd=3
        LifetimeRange=(Min=2.500000,Max=3.000000)
        InitialDelayRange=(Min=0.300000,Max=0.300000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Min=1000.000000,Max=300.000000))
        Name="SpriteEmitter302"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter302'
}

