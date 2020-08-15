class EM_PlasmaBoltImpact extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        UseSubdivisionScale=True
        ColorScale(0)=(Color=(G=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=255,A=255))
        Opacity=0.500000
        MaxParticles=4
        Name="SpriteEmitter1"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Max=24.000000)
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
        SizeScaleRepeats=1.000000
        StartSizeRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Min=-40.000000,Max=40.000000))
        InitialParticlesPerSecond=10.000000
        Texture=Texture'DXR_FX.Effects.aeon_plasma03'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.600000,Max=1.200000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        Acceleration=(Z=20.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.125000,Color=(B=255,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.317857,Color=(B=255,G=255,R=255,A=255))
        ColorScale(3)=(RelativeTime=0.750000,Color=(B=128,G=128,R=128,A=255))
        ColorScale(4)=(RelativeTime=1.000000,Color=(B=64,G=64,R=64))
        Opacity=0.480000
        MaxParticles=15
        Name="SpriteEmitter2"
        StartLocationShape=PTLS_Polar
        StartLocationPolarRange=(Y=(Min=-32768.000000,Max=32768.000000),Z=(Min=10.000000,Max=10.000000))
        UseRotationFrom=PTRS_Actor
        RotationOffset=(Yaw=48059)
        SpinsPerSecondRange=(X=(Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.500000)
        InitialParticlesPerSecond=500.000000
        Texture=Texture'DXR_FX.Effects.pfx_smoke_01'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRadialRange=(Min=100.000000,Max=100.000000)
        GetVelocityDirectionFrom=PTVD_AddRadial
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=0.100000,Y=0.100000,Z=0.100000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter2'
}
