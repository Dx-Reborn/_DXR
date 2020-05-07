class EM_CeramicHit extends DeusExEmitter;

defaultproperties
{
  Begin Object Class=SpriteEmitter Name=SpriteEmitter12
        UseRotationFrom=PTRS_Actor
        DrawStyle=PTDS_AlphaBlend
        MaxParticles=8
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        InitialParticlesPerSecond=1000.000000
        SecondsBeforeInactive=0.000000
        WarmupTicksPerSecond=5.000000
        Texture=Texture'DXR_FX.Particles.Smoke_Impact_04'
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=20.000000)
        Acceleration=(Z=-400.000000)
        StartLocationOffset=(X=5.000000)
        SpinCCWorCW=(X=0.200000,Y=0.200000,Z=0.200000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSizeRange=(X=(Min=1.000000,Max=3.000000))
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=100.000000,Max=800.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityLossRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter12'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter13
        UseRotationFrom=PTRS_Actor
        DrawStyle=PTDS_AlphaBlend
        MaxParticles=5
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        InitialParticlesPerSecond=3000.000000
        SecondsBeforeInactive=0.000000
        WarmupTicksPerSecond=5.000000
        Texture=Texture'DXR_FX.Particles.Smoke_Impact_04'
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=20.000000)
        Acceleration=(Z=-400.000000)
        StartLocationOffset=(X=5.000000)
        SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
        StartSizeRange=(X=(Min=2.000000,Max=3.000000))
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=30.000000,Max=50.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=-150.000000,Max=150.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=5.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter13'
}