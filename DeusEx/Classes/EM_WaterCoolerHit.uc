class EM_WaterCoolerHit extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter89
        UseDirectionAs=PTDU_Up
        Acceleration=(Z=-600.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=83,G=87,R=87))
        MaxParticles=100
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=4.000000,Max=4.000000))
        InitialParticlesPerSecond=50.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.600000,Max=0.800000)
        StartVelocityRange=(X=(Min=25.000000,Max=50.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter89'
}