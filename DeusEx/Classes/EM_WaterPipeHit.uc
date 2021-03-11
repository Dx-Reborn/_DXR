class EM_WaterPipeHit extends DeusExEmitter;

event SetInitialState()
{
   SetTimer(9.0, false);
}

event Timer()
{
   AmbientSound = None;
}

defaultproperties
{
    AutoDestroy=True
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter135
        UseDirectionAs=PTDU_Up
        Acceleration=(Z=-600.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=83,G=87,R=87))
        MaxParticles=900
        RespawnDeadParticles=False
        StartLocationOffset=(X=4.000000)
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=8.000000,Max=8.000000))
        InitialParticlesPerSecond=100.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.600000,Max=0.800000)
        StartVelocityRange=(X=(Min=200.000000,Max=300.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter136
        Acceleration=(Z=-50.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=32))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
        MaxParticles=900
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=8.000000,Max=12.000000))
        UniformSize=True
        InitialParticlesPerSecond=100.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.600000,Max=0.800000)
        StartVelocityRange=(X=(Min=80.000000,Max=90.000000),Y=(Min=20.000000,Max=-20.000000),Z=(Min=20.000000,Max=-20.000000))
        VelocityLossRange=(X=(Min=2.000000,Max=5.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter137
        UseDirectionAs=PTDU_Up
        Acceleration=(Z=-200.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=128,R=128))
        MaxParticles=50
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=0.100000,Max=0.500000),Y=(Min=2.000000,Max=3.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=2.000000,Max=2.500000)
        InitialDelayRange=(Min=8.000000,Max=8.000000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter135'
    Emitters(1)=SpriteEmitter'SpriteEmitter136'
    Emitters(2)=SpriteEmitter'SpriteEmitter137'
}

