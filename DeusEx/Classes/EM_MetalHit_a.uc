class EM_MetalHit_a extends DeusExEmitter;

defaultproperties
{
   Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter221
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        ColorScale(0)=(Color=(B=213,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.400000,Color=(B=125,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.600000,Color=(B=113,G=184,R=255))
        ColorScale(3)=(RelativeTime=1.000000)
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=4.000000,Max=8.000000),Y=(Min=20.000000,Max=30.000000))
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Effects.MuzzleFlash2'
        LifetimeRange=(Min=0.100000,Max=0.100000)
        StartVelocityRange=(X=(Min=2.000000,Max=2.000000),Y=(Min=20.000000,Max=-20.000000),Z=(Min=20.000000,Max=-20.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter222
        Acceleration=(Z=20.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=192,G=192,R=192,A=64))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192))
        MaxParticles=4
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=2.000000,Max=2.000000))
        UniformSize=True
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=1.000000,Max=1.000000)
    End Object
    Begin Object Class=Engine.SparkEmitter Name=SparkEmitter48
        TimeBetweenSegmentsRange=(Min=0.100000,Max=0.100000)
        Acceleration=(Z=-300.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=210,G=255,R=255))
        ColorScale(1)=(RelativeTime=0.200000,Color=(B=130,G=255,R=255))
        ColorScale(2)=(RelativeTime=0.600000,Color=(B=108,G=182,R=255))
        ColorScale(3)=(RelativeTime=1.000000)
        MaxParticles=30
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.150000,Max=0.200000)
        StartVelocityRange=(X=(Max=150.000000),Y=(Min=50.000000,Max=-50.000000),Z=(Max=150.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter221'
    Emitters(1)=SpriteEmitter'SpriteEmitter222'
    Emitters(2)=SparkEmitter'SparkEmitter48'
}
