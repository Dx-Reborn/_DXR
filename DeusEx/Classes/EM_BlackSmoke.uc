//-=-=-=-=-=-

class EM_BlackSmoke extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=15.000000)
        ColorScale(0)=(Color=(A=200))
        ColorScale(1)=(RelativeTime=1.000000,Color=(A=200))
        FadeOutStartTime=2.500000
        FadeInEndTime=0.500000
        MaxParticles=25
        Name="SpriteEmitter1"
        SphereRadiusRange=(Max=25.000000)
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.010000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
        StartSpinRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        SizeScaleRepeats=1.000000
        StartSizeRange=(X=(Min=15.000000,Max=35.000000),Y=(Min=15.000000,Max=35.000000),Z=(Min=15.000000,Max=15.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'ut2k4Extra.SmokeAlphab_t'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=5.000000,Max=5.000000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=15.000000,Max=15.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'
}