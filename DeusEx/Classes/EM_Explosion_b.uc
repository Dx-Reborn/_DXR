class EM_Explosion_b extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter646
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        AutomaticInitialSpawning=False
        UniformSize=True
        ColorScale(0)=(Color=(B=141,G=200,R=231,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=67,G=163,R=214,A=255))
        Opacity=0.220000
        FadeOutStartTime=0.100000
        FadeInEndTime=0.100000
        SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=200.000000,Max=200.000000),Y=(Min=200.000000,Max=200.000000),Z=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'DXR_FX.Particles.THRD'
        LifetimeRange=(Min=0.500000,Max=0.500000)
        Name="SpriteEmitter646"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter646'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter647
        UseColorScale=True
        RespawnDeadParticles=False
        UseSizeScale=True
        AutomaticInitialSpawning=False
        UniformSize=True
        Acceleration=(Z=-950.000000)
        DampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        ColorScale(0)=(Color=(B=126,G=209,R=183,A=255))
        ColorScale(1)=(RelativeTime=0.207143,Color=(B=67,G=163,R=214,A=255))
        ColorScale(2)=(RelativeTime=0.396429,Color=(B=126,G=209,R=183,A=255))
        ColorScale(3)=(RelativeTime=0.607143,Color=(B=67,G=163,R=214,A=255))
        ColorScale(4)=(RelativeTime=0.821429,Color=(B=126,G=209,R=183,A=255))
        ColorScale(5)=(RelativeTime=1.000000,Color=(B=67,G=163,R=214,A=255))
        ColorScaleRepeats=10.000000
        Opacity=0.930000
        MaxParticles=100
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=30.000000,Max=30.000000),Z=(Min=30.000000,Max=30.000000))
        InitialParticlesPerSecond=800.000000
        Texture=Texture'DXR_FX.Particles.Flare01'
        StartVelocityRange=(X=(Min=-800.000000,Max=800.000000),Y=(Min=-800.000000,Max=800.000000),Z=(Max=1000.000000))
        Name="SpriteEmitter647"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter647'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter648
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        ColorScale(0)=(Color=(B=126,G=191,R=226,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=67,G=163,R=214,A=255))
        Opacity=0.280000
        FadeOutStartTime=0.065000
        MaxParticles=2
        SpinsPerSecondRange=(X=(Min=0.200000,Max=0.200000))
        StartSizeRange=(X=(Min=500.000000,Max=500.000000),Y=(Min=500.000000,Max=500.000000),Z=(Min=500.000000,Max=500.000000))
        InitialParticlesPerSecond=100.000000
        Texture=Texture'DXR_FX.Particles.RaysKey'
        LifetimeRange=(Min=0.500000,Max=0.500000)
        Name="SpriteEmitter648"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter648'
}