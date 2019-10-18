class EM_Smoke extends DeusExEmitter;

defaultproperties
{
  Begin Object Class=SpriteEmitter Name=SpriteEmitter112
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        ColorScale(0)=(Color=(B=100,G=105,R=105,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=105,R=105,A=255))
        FadeOutFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeOutStartTime=1.200000
        FadeInEndTime=1.000000
        StartLocationOffset=(Z=-16.000000)
        StartLocationRange=(X=(Min=-64.000000,Max=64.000000),Y=(Min=-64.000000,Max=64.000000))
        SpinsPerSecondRange=(X=(Max=0.100000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=50.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.Clouds'
        SecondsBeforeInactive=2.000000
        LifetimeRange=(Min=2.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=25.000000,Max=65.000000))
        VelocityLossRange=(Z=(Max=2.000000))
        WarmupTicksPerSecond=1.000000
        RelativeWarmupTime=1.000000
        Name="SpriteEmitter112"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter112'
}