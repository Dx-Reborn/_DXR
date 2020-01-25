class EM_HeadHit extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.700000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        Opacity=0.580000
        FadeOutStartTime=0.190000
        MaxParticles=12
        Name="SpriteEmitter0"
        StartLocationOffset=(X=16.000000)
        SpinsPerSecondRange=(X=(Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=0.370000,RelativeSize=0.700000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        InitialParticlesPerSecond=5000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BallisticEffects.Particles.Smoke6'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Max=15.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=2.000000,Max=2.000000),Z=(Min=2.000000,Max=2.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_Up
        FadeOut=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.700000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        Opacity=0.650000
        FadeOutStartTime=0.150000
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        Name="SpriteEmitter1"
        StartLocationOffset=(X=8.000000)
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=0.800000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=7.500000,Max=10.000000),Y=(Min=7.500000,Max=10.000000),Z=(Min=7.500000,Max=10.000000))
        InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BallisticEffects.Particles.WaterSpray1Alpha'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.400000,Max=0.400000)
        StartVelocityRange=(X=(Min=-15.000000,Max=-15.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1'

    Begin Object Class=MeshEmitter Name=MeshEmitter0
        StaticMesh=StaticMesh'BallisticHardware2.Effects.BloodVolumetric'
        UseMeshBlendMode=False
        RenderTwoSided=True
        UseParticleColor=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        Acceleration=(Z=-10.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.800000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        FadeOutStartTime=0.035000
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        Name="MeshEmitter0"
        StartLocationOffset=(X=8.000000)
        SpinsPerSecondRange=(Z=(Max=1.000000))
        StartSpinRange=(Z=(Max=1.000000))
        SizeScale(1)=(RelativeTime=0.620000,RelativeSize=0.700000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Max=1.500000),Y=(Min=0.200000,Max=0.350000),Z=(Min=0.200000,Max=0.350000))
        InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.500000,Max=0.500000)
        StartVelocityRange=(X=(Min=7.500000,Max=7.500000))
    End Object
    Emitters(2)=MeshEmitter'MeshEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseDirectionAs=PTDU_Up
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-100.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.600000,Max=0.700000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        FadeOutStartTime=0.196000
        MaxParticles=8
        Name="SpriteEmitter2"
        StartLocationOffset=(X=8.000000)
        StartSpinRange=(X=(Min=0.250000,Max=0.250000))
        StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        InitialParticlesPerSecond=50.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BallisticEffects.Particles.SparkA1Alpha'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.400000,Max=0.400000)
        StartVelocityRange=(X=(Min=-100.000000,Max=-10.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Min=-30.000000,Max=50.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter2'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        UseRandomSubdivision=True
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.800000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        FadeOutStartTime=0.196000
        MaxParticles=12
        Name="SpriteEmitter3"
        StartLocationOffset=(X=20.000000)
        SpinsPerSecondRange=(X=(Max=2.000000))
        StartSpinRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=1.000000,Max=1.500000),Y=(Min=1.000000,Max=1.500000),Z=(Min=1.000000,Max=1.500000))
        InitialParticlesPerSecond=5000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BallisticEffects.Sprite.HeadBits'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=100.000000),Y=(Min=-40.000000,Max=40.000000),Z=(Max=100.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter3'
}
