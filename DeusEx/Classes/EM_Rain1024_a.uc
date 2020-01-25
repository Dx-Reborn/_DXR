class EM_Rain1024_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter701
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        Acceleration=(Z=-50.000000)
        ColorScale(0)=(Color=(B=20,G=20,R=20,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=20,G=20,R=20,A=255))
        MaxParticles=250
        StartLocationRange=(X=(Min=-512.000000,Max=512.000000),Y=(Min=-512.000000,Max=512.000000))
        StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=20.000000,Max=20.000000))
        InitialParticlesPerSecond=10.000000
        Texture=Texture'DXR_FX.Particles.rainDrip'
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRange=(Z=(Min=-450.000000,Max=-500.000000))
        WarmupTicksPerSecond=1.000000
        RelativeWarmupTime=1.000000
        Name="SpriteEmitter701"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter701'
}