class EM_FireExtExplosion extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter209
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=300
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=20.000000))
        UniformSize=True
        InitialParticlesPerSecond=100.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.500000,Max=0.500000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-250.000000,Max=-300.000000),Z=(Min=-10.000000,Max=10.000000))
        VelocityLossRange=(Y=(Min=1.000000,Max=2.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter210
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=200))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=5
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.300000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=15.000000,Max=30.000000))
        UniformSize=True
        InitialParticlesPerSecond=30.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=1.500000,Max=2.000000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-5.000000,Max=-20.000000),Z=(Max=50.000000))
        VelocityLossRange=(Z=(Min=2.000000,Max=3.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter211
        Acceleration=(Z=-600.000000)
        DampingFactorRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000),Z=(Min=0.200000,Max=0.200000))
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128))
        ColorScale(1)=(RelativeTime=1.000000)
        CoordinateSystem=PTCS_Relative
        MaxParticles=50
        RespawnDeadParticles=False
        StartLocationOffset=(Y=-8.000000)
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=2.000000,Max=5.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        Texture=Texture'DXR_FX.Effects.BrokenGlass'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.600000,Max=0.800000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Max=-150.000000),Z=(Min=-50.000000,Max=200.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter209'
    Emitters(1)=SpriteEmitter'SpriteEmitter210'
    Emitters(2)=SpriteEmitter'SpriteEmitter211'
}

