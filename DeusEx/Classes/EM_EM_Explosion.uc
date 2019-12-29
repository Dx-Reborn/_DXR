class EM_EM_Explosion extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        FadeOut=True
        FadeIn=True
        AutoDestroy=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=162,G=90,R=60))
        FadeOutStartTime=0.189200
        FadeInEndTime=0.008600
        MaxParticles=1
        Name="flash"
        StartLocationOffset=(Y=5.000000,Z=5.000000)
        SpinsPerSecondRange=(X=(Max=0.393000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.900000)
        StartSizeRange=(X=(Min=300.000000,Max=300.000000),Y=(Min=300.000000,Max=300.000000),Z=(Min=300.000000,Max=300.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Effects.plasma_02'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.300000,Max=0.500000)
        InitialDelayRange=(Min=0.129000,Max=0.129000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter10'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter11
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        AutoDestroy=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        DampingFactorRange=(X=(Min=0.300000,Max=0.500000),Y=(Min=0.300000,Max=0.500000),Z=(Min=0.300000,Max=0.500000))
        ColorScale(0)=(Color=(B=241,G=86,R=86))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=165,G=56,R=84))
        FadeOutStartTime=0.189200
        FadeInEndTime=0.008600
        Name="Ring"
        StartLocationOffset=(Y=5.000000,Z=5.000000)
        StartLocationRange=(Z=(Min=-50.000000,Max=50.000000))
        SpinCCWorCW=(X=0.370000)
        SpinsPerSecondRange=(X=(Max=1.286000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=351.720001,Max=351.720001),Y=(Min=351.720001,Max=351.720001),Z=(Min=351.720001,Max=351.720001))
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'DXR_FX.Effects.glow_ring_a'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-0.200000,Max=0.200000),Y=(Min=-0.200000,Max=0.200000),Z=(Min=-1.000000,Max=1.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter11'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter12
        FadeOut=True
        AutoDestroy=True
        Disabled=True
        Backup_Disabled=True
        SpinParticles=True
        DampRotation=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-100.000000)
        DampingFactorRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
        ColorScale(0)=(Color=(B=104,G=126,R=202,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=125,R=190,A=255))
        ColorMultiplierRange=(X=(Min=0.570000,Max=0.570000),Y=(Min=0.570000,Max=0.570000),Z=(Min=0.570000,Max=0.570000))
        FadeOutStartTime=0.495000
        MaxParticles=50
        Name="SpriteEmitter12"
        StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
        InitialParticlesPerSecond=2000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.Radiball_animated1_sm'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.050000,Max=0.500000)
        StartVelocityRange=(X=(Min=-150.000000,Max=150.000000),Y=(Min=-150.000000,Max=150.000000),Z=(Min=-150.000000,Max=150.000000))
        VelocityLossRange=(X=(Max=5.000000),Y=(Max=3.000000),Z=(Max=3.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter12'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter13
        UseCollisionPlanes=True
        FadeOut=True
        AutoDestroy=True
        Disabled=True
        Backup_Disabled=True
        SpinParticles=True
        DampRotation=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-600.000000)
        DampingFactorRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        ColorScale(0)=(Color=(B=104,G=126,R=202,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=125,R=190,A=255))
        ColorMultiplierRange=(X=(Min=0.350000,Max=0.350000),Y=(Min=0.350000,Max=0.350000),Z=(Min=0.350000,Max=0.350000))
        FadeOutStartTime=0.495000
        MaxParticles=30
        Name="SpriteEmitter13"
        SphereRadiusRange=(Max=20.000000)
        SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=1.000000,Max=10.000000),Y=(Min=1.000000,Max=10.000000),Z=(Min=1.000000,Max=10.000000))
        InitialParticlesPerSecond=2000.000000
        DrawStyle=PTDS_AlphaBlend
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-505.000000,Max=505.000000),Y=(Min=-505.000000,Max=505.000000),Z=(Min=-50.000000,Max=600.000000))
        VelocityLossRange=(X=(Max=5.000000),Y=(Max=3.000000),Z=(Max=3.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter13'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter14
        FadeOut=True
        AutoDestroy=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=247,G=183,R=201))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=240,G=94,R=182))
        FadeOutStartTime=0.121440
        MaxParticles=2
        Name="SpriteEmitter14"
        StartLocationRange=(Z=(Min=-20.000000,Max=20.000000))
        SpinsPerSecondRange=(X=(Max=0.500000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=80.000000,Max=80.000000),Y=(Min=80.000000,Max=80.000000),Z=(Min=80.000000,Max=80.000000))
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'DXR_FX.Effects.quantum_plasma_ring01'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.132000,Max=0.224000)
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter14'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter15
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        FadeOut=True
        ResetAfterChange=True
        AutoDestroy=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        Acceleration=(X=-10.000000,Y=-10.000000,Z=-1000.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=83,G=6))
        FadeOutStartTime=0.500000
        MaxParticles=1000
        Name="SpriteEmitter15"
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.100000)
        StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=2.500000,Max=10.000000),Z=(Min=2.500000,Max=10.000000))
        InitialParticlesPerSecond=20000.000000
        Texture=Texture'DXR_FX.Effects.spark_stretched_b'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.010000,Max=1.000000)
        StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=-200.000000,Max=600.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter15'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter16
        AutoDestroy=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=5
        Name="SpriteEmitter16"
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.013000)
        StartSizeRange=(X=(Min=0.326000,Max=50.326000),Y=(Min=0.326000,Max=50.326000),Z=(Min=0.326000,Max=50.326000))
        InitialParticlesPerSecond=1000.000000
        Texture=Texture'DXR_FX.Effects.flash_animated_a'
        TextureUSubdivisions=4
        TextureVSubdivisions=2
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.001000,Max=0.510000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter16'

    LifeSpan=3.0f
}



