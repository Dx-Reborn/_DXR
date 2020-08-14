class EM_PlasmaBoltTrailA extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        UseColorScale=True
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        Acceleration=(Z=40.000000)
        ColorScale(0)=(Color=(G=0,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=0,G=0,R=128,A=255))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        FadeOutStartTime=0.220000
        MaxParticles=100
        Name="SpriteEmitter9"
        SpinsPerSecondRange=(X=(Max=3.000000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=15.000000,Max=15.000000))
        Texture=FireTexture'Effects.Fire.SparkFX1'
        TextureUSubdivisions=1
        TextureVSubdivisions=1
        LifetimeRange=(Min=0.500000,Max=1.000000)
        StartVelocityRange=(Z=(Max=10.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter9'
}