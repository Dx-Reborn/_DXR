class EM_WallDust extends DeusExEmitter;

defaultproperties
{
  Begin Object Class=SpriteEmitter Name=SpriteEmitter156
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        Acceleration=(Z=-600.000000)
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.200000,Color=(B=49,G=70,R=77,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=75,G=106,R=116,A=255))
        FadeOutStartTime=0.750000
        SpinsPerSecondRange=(X=(Max=0.300000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=15.000000,Max=50.000000))
        InitialParticlesPerSecond=500.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.Clouds'
        LifetimeRange=(Min=1.000000,Max=1.500000)
        StartVelocityRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Max=700.000000))
        VelocityLossRange=(Z=(Min=1.000000,Max=1.000000))
        Name="SpriteEmitter156"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter156'
}