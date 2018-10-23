//
// From Reborn test map
//

Class EM_ExplosionMedium_A extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=150.000000)
        ColorScale(0)=(Color=(B=141,G=160,R=239,A=255))
        ColorScale(1)=(RelativeTime=0.300000,Color=(B=28,G=199,R=255,A=255))
        ColorScale(2)=(RelativeTime=0.700000,Color=(B=66,G=173,R=253,A=255))
        ColorScale(3)=(RelativeTime=1.000000)
        ColorMultiplierRange=(Y=(Min=0.800000,Max=0.800000),Z=(Min=0.800000,Max=0.800000))
        FadeOutStartTime=1.000000
        MaxParticles=13
        AutoResetTimeRange=(Min=0.200000,Max=0.200000)
        StartLocationOffset=(Z=100.000000)
        StartLocationRange=(X=(Min=-64.000000,Max=64.000000),Y=(Min=-64.000000,Max=64.000000))
        StartLocationShape=PTLS_All
        SphereRadiusRange=(Min=64.000000,Max=64.000000)
        UseRotationFrom=PTRS_Actor
        RotationOffset=(Pitch=16384)
        SpinsPerSecondRange=(X=(Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=4500.000000
        Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.500000,Max=0.750000)
        StartVelocityRadialRange=(Min=-150.000000,Max=-150.000000)
        GetVelocityDirectionFrom=PTVD_AddRadial
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        UseColorScale=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=100.000000)
        ColorScale(0)=(Color=(B=128,G=128,R=128))
        ColorScale(1)=(RelativeTime=0.100000,Color=(B=128,G=128,R=128,A=128))
        ColorScale(2)=(RelativeTime=0.600000,Color=(B=64,G=64,R=64,A=128))
        ColorScale(3)=(RelativeTime=1.000000)
        AutoResetTimeRange=(Min=0.200000,Max=0.200000)
        StartLocationOffset=(Z=150.000000)
        StartLocationRange=(X=(Min=-64.000000,Max=64.000000),Y=(Min=-64.000000,Max=64.000000))
        StartLocationShape=PTLS_All
        SphereRadiusRange=(Max=128.000000)
        UseRotationFrom=PTRS_Actor
        RotationOffset=(Pitch=16384)
        SizeScale(0)=(RelativeSize=0.250000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=200.000000,Max=200.000000))
        InitialParticlesPerSecond=4500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'AW-2004Particles.Weapons.SmokePanels2'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.500000,Max=1.500000)
        InitialDelayRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=8.000000))
        StartVelocityRadialRange=(Min=-50.000000,Max=-50.000000)
        GetVelocityDirectionFrom=PTVD_AddRadial
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter3'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter24
        UseDirectionAs=PTDU_Normal
        ProjectionNormal=(X=1.000000,Z=0.000000)
        UseColorScale=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(1)=(RelativeTime=0.200000,Color=(B=136,G=196,R=236))
        ColorScale(2)=(RelativeTime=0.500000,Color=(B=36,G=141,R=247))
        ColorScale(3)=(RelativeTime=1.000000)
        MaxParticles=2
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.050000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=500.000000,Max=500.000000))
        InitialParticlesPerSecond=10.000000
        Texture=Texture'AW-2004Particles.Fire.BlastMark'
        LifetimeRange=(Min=0.300000,Max=0.300000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter24'
}
