class EM_Dust extends DeusExEmitter;

defaultproperties
{
  Begin Object Class=SpriteEmitter Name=SpriteEmitter255
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        ColorScale(0)=(Color=(B=23,G=34,R=43,A=255))
        ColorScale(1)=(RelativeTime=0.800000,Color=(B=38,G=56,R=72,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=80,G=108,R=124,A=255))
        FadeOutFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeOutStartTime=0.300000
        StartLocationRange=(X=(Min=-40.000000,Max=40.000000),Y=(Min=-40.000000,Max=40.000000))
        SpinsPerSecondRange=(X=(Max=0.200000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=70þ000000))
        InitialParticlesPerSecond=120.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.Clouds'
        SecondsBeforeInactive=2.000000
        LifetimeRange=(Min=2.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=50.000000,Max=200.000000))
        VelocityLossRange=(Z=(Max=2.000000))
        Name="SpriteEmitter255"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter255'
}