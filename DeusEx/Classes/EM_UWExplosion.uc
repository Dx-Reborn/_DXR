class EM_UWExplosion extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter53
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        FadeOutStartTime=0.200000
        MaxParticles=1
        Name="SpriteEmitter53"
        DetailMode=DM_SuperHigh
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'BallisticEffects.Particles.Shockwave'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.500000,Max=0.500000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter53'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter54
        FadeOut=True
        RespawnDeadParticles=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=50.000000)
        ExtentMultiplier=(X=0.700000,Y=0.700000,Z=0.700000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        FadeOutStartTime=1.640000
        MaxParticles=300
        Name="SpriteEmitter54"
        DetailMode=DM_High
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=10.000000,Max=20.000000)
        StartSizeRange=(X=(Min=2.000000,Max=6.000000))
        InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BallisticEffects.Particles.AquaBubble1'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=1.000000)
        StartVelocityRadialRange=(Min=-800.000000)
        VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=4.000000,Max=4.000000))
        GetVelocityDirectionFrom=PTVD_AddRadial
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter54'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter55
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=192,R=128,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.100000
        MaxParticles=1
        Name="SpriteEmitter55"
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
        StartSizeRange=(X=(Min=70.000000,Max=70.000000),Y=(Min=70.000000,Max=70.000000),Z=(Min=70.000000,Max=70.000000))
        InitialParticlesPerSecond=50000.000000
        Texture=Texture'BallisticEffects.Particles.Explode2'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.500000,Max=0.500000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter55'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter56
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-50.000000)
        ColorScale(0)=(Color=(B=128,G=192,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.100000,Color=(B=255,G=255,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.950000,Max=0.950000))
        Opacity=0.510000
        FadeOutStartTime=0.870000
        MaxParticles=12
        Name="SpriteEmitter56"
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=0.560000,RelativeSize=0.800000)
        SizeScale(3)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=150.000000,Max=150.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=150.000000,Max=150.000000))
        InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BallisticEffects.Particles.Smoke6'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-400.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Max=300.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter56'
}

