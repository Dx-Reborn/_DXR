class EM_Steam extends DeusExEmitter;

defaultproperties
{
   Begin Object Class=SpriteEmitter Name=SpriteEmitter731
        UseColorScale=True
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        Acceleration=(Z=10.000000)
        ColorScale(0)=(Color=(B=210,G=210,R=210,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=210,G=210,R=210,A=255))
        FadeOutStartTime=0.500000
        CoordinateSystem=PTCS_Relative
        MaxParticles=20
        SphereRadiusRange=(Min=64.000000,Max=64.000000)
        SpinsPerSecondRange=(X=(Max=0.500000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.800000)
        StartSizeRange=(X=(Min=25.000000,Max=50.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Particles.Clouds'
        LifetimeRange=(Min=0.800000,Max=0.800000)
        StartVelocityRange=(X=(Min=-175.000000,Max=-200.000000))
        VelocityLossRange=(X=(Min=0.100000,Max=0.200000),Z=(Max=1.000000))
        Name="SpriteEmitter731"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter731'
}