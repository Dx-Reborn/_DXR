class EM_Toilet2aWater extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter8
        UseColorScale=True
        FadeOut=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=234,R=168))
        ColorScale(1)=(RelativeTime=0.600000,Color=(B=253,G=253,R=253))
        ColorScale(2)=(RelativeTime=1.000000)
        Opacity=0.200000
        FadeOutStartTime=0.075054
        MaxParticles=8
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Max=0.042636))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=10.299999,Max=10.299999),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        InitialParticlesPerSecond=13.644000
        Texture=Texture'DXR_Fx.Particles.Toilet2a_Water'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=0.992424,Max=0.992424)
        StartVelocityRange=(Z=(Min=-36.300003,Max=-36.300003))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter8'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter11
        UseColorScale=True
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        Acceleration=(Z=-6.594638)
        ColorScale(0)=(Color=(B=255,G=250,R=200))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=250,R=200))
        ColorMultiplierRange=(X=(Min=0.750000,Max=0.750000),Y=(Min=0.750000,Max=0.750000),Z=(Min=0.750000,Max=0.750000))
        Opacity=0.600000
        MaxParticles=15
        StartLocationRange=(Y=(Min=-4.000000,Max=5.000000),Z=(Min=-25.000000,Max=-25.000000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.500000)
        StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=43.000000,Max=43.000000),Z=(Min=43.000000,Max=43.000000))
        InitialParticlesPerSecond=273.750000
        Texture=Texture'ut2k4Extra.xWaterDrops2'
        TextureUSubdivisions=1
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.242009,Max=1.242009)
        StartVelocityRange=(X=(Min=-4.959255,Max=4.959255),Y=(Min=-4.959255,Max=4.959255),Z=(Min=1.095000,Max=8.139683))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter11'
}

