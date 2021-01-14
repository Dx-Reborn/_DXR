class EM_BloodHit_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter79
        ProjectionNormal=(X=90.000000)
        FadeOut=True
        FadeIn=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=5))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=5))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        Opacity=0.900000
        FadeOutStartTime=0.049158
        FadeInEndTime=0.013109
        MaxParticles=1
        Name="Blood_splat"
        UseRotationFrom=PTRS_Offset
        RotationOffset=(Pitch=16383,Yaw=16383,Roll=16383)
        SpinCCWorCW=(X=0.000000)
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.250000,RelativeSize=5.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=10.000000)
        StartSizeRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
        InitialParticlesPerSecond=1.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.fl_BloodC'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.327723,Max=0.327723)
        RespawnDeadParticles=false

    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter79'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter80
        FadeOut=True
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=12.000000,Y=13.000000,Z=-198.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.875000
        MaxParticles=20
        Name="Drops"
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.fl_bloodB'
        SecondsBeforeInactive=0.000000
        InitialTimeRange=(Max=0.250000)
        LifetimeRange=(Min=1.250000,Max=1.250000)
        InitialDelayRange=(Min=0.350000,Max=0.350000)
        StartVelocityRange=(X=(Min=-13.000000,Max=-13.000000),Y=(Min=-13.000000,Max=-13.000000),Z=(Min=-13.000000,Max=-13.000000))
        VelocityLossRange=(Z=(Min=0.000100,Max=1.000000))

        RespawnDeadParticles=false
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter80'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter81
        FadeOut=True
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-200.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.875000
        MaxParticles=20
        Name="Drops2"
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
        InitialParticlesPerSecond=50000.000000
        DrawStyle=PTDS_AlphaBlend
//        Texture=Texture'FlFx.Fx.bloodA'
        SecondsBeforeInactive=0.000000
        InitialTimeRange=(Max=0.250000)
        LifetimeRange=(Min=1.250000,Max=1.250000)
        InitialDelayRange=(Min=0.350000,Max=0.350000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=1.000000,Max=122.000000))
        VelocityLossRange=(Z=(Min=0.000100,Max=1.000000))

        RespawnDeadParticles=false
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter81'

    AutoDestroy=True
}