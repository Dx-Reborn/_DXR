class EM_Smoke_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter482
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        Acceleration=(Z=20.000000)
        ColorScale(0)=(Color=(B=199,G=189,R=177,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=162,G=147,R=128,A=255))
        FadeOutFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeOutStartTime=1.500000
        FadeInFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeInEndTime=1.000000
        CoordinateSystem=PTCS_Relative
        MaxParticles=20
        SpinsPerSecondRange=(X=(Max=0.200000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        InitialParticlesPerSecond=20.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.particles.Clouds'
        SecondsBeforeInactive=2.000000
        LifetimeRange=(Min=1.800000,Max=2.000000)
        StartVelocityRange=(Y=(Min=-8.000000,Max=8.000000),Z=(Min=200.000000,Max=400.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=3.000000))
        Name="SpriteEmitter482"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter482'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter483
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        RespawnDeadParticles=False
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(B=91,G=80,R=66,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(A=255))
        MaxParticles=4
        StartSizeRange=(X=(Min=35.000000,Max=75.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.particles.flame_01'
        LifetimeRange=(Min=0.500000,Max=1.000000)
        StartVelocityRange=(Z=(Min=200.000000,Max=600.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=2.000000))
        Name="SpriteEmitter483"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter483'
}