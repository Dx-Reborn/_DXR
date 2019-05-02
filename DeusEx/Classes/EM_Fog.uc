class EM_Fog extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        Acceleration=(Z=10.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.090000
        FadeOutStartTime=0.840000
        FadeOut=True
        FadeInEndTime=0.840000
        FadeIn=True
        MaxParticles=20
        StartLocationRange=(X=(Min=-400.000000,Max=400.000000),Y=(Min=-400.000000,Max=400.000000),Z=(Min=50.000000,Max=150.000000))
        StartLocationShape=PTLS_Polar
        StartLocationPolarRange=(X=(Min=-1000000000.000000,Max=1000000000.000000),Y=(Min=1000000000.000000,Max=1000000000.000000),Z=(Min=400.000000,Max=1000.000000))
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        StartSizeRange=(X=(Min=300.000000,Max=500.000000),Y=(Max=300.000000),Z=(Min=500.000000,Max=500.000000))
        UniformSize=True
        InitialParticlesPerSecond=4.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'smokepuff'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}
