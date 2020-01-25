class EM_Explosion_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter64
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        ColorScale(0)=(Color=(B=196,G=255,R=254,A=255))
        ColorScale(1)=(RelativeTime=0.100000,Color=(G=128,R=255,A=255))
        ColorScale(2)=(RelativeTime=0.200000,Color=(A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(A=255))
        FadeOutFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeOutStartTime=0.300000
        MaxParticles=20
        SpinsPerSecondRange=(X=(Min=0.200000,Max=0.500000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.200000,RelativeSize=0.800000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_fx.Particles.explosion_a'
        SecondsBeforeInactive=2.000000
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000),Z=(Max=100.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000))
        Name="SpriteEmitter64"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter64'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter65
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        ColorScale(0)=(Color=(B=128,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.500000,Color=(G=128,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(A=255))
        MaxParticles=1
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=120.000000,Max=120.000000))
        InitialParticlesPerSecond=30.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_fx.Particles.RingWave3'
        LifetimeRange=(Min=0.300000,Max=0.300000)
        Name="SpriteEmitter65"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter65'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter66
        UseColorScale=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        Acceleration=(Z=-350.000000)
        ColorScale(0)=(Color=(B=151,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.500000,Color=(G=128,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(A=255))
        MaxParticles=20
        SpinsPerSecondRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000)
        InitialParticlesPerSecond=300.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_fx.Particles.corona_01'
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRange=(X=(Min=-600.000000,Max=600.000000),Y=(Min=-600.000000,Max=600.000000),Z=(Max=600.000000))
        VelocityLossRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        Name="SpriteEmitter66"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter66'
    Begin Object Class=MeshEmitter Name=MeshEmitter13
//        StaticMesh=StaticMesh'FX_SM.AB_debrisb'
        UseCollision=True
        RespawnDeadParticles=False
        SpinParticles=True
        AutomaticInitialSpawning=False
        UniformSize=True
        Acceleration=(Z=-900.000000)
        DampingFactorRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000),Z=(Min=0.300000,Max=0.500000))
        MaxParticles=50
        SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.800000,Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.500000))
        InitialParticlesPerSecond=500.000000
        LifetimeRange=(Min=1.500000,Max=2.000000)
        StartVelocityRange=(X=(Min=-600.000000,Max=600.000000),Y=(Min=-600.000000,Max=600.000000),Z=(Max=800.000000))
        Name="MeshEmitter13"
    End Object
    Emitters(3)=MeshEmitter'MeshEmitter13'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter67
        UseColorScale=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        ColorScale(0)=(Color=(B=128,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.500000,Color=(G=128,R=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(A=255))
        MaxParticles=1
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
        StartSizeRange=(X=(Min=150.000000,Max=150.000000))
        InitialParticlesPerSecond=300.000000
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_fx.Particles.Circle'
        LifetimeRange=(Min=0.400000,Max=0.400000)
        Name="SpriteEmitter67"
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter67'
}