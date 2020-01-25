// Огонь, вариант А
// Хотя и этот можно через скрипт изменить как угодно...

class EM_FireA extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        ProjectionNormal=(Z=0.000000)
        UseColorScale=True
        FadeOut=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        ColorScale(0)=(Color=(B=128,G=64,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=108,R=217,A=255))
        ColorScaleRepeats=1.000000
        FadeOutFactor=(W=0.000000,X=0.000000,Y=0.000000,Z=0.000000)
        FadeOutStartTime=4.000000
        MaxParticles=30
        EffectAxis=PTEA_PositiveZ
        Name="SpriteEmitter2"
        StartLocationShape=PTLS_Sphere
        UseRotationFrom=PTRS_Normal
        SpinCCWorCW=(X=0.000000)
        SpinsPerSecondRange=(X=(Max=0.001000),Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.100000))
        StartSizeRange=(X=(Min=25.000000,Max=30.000000),Y=(Min=25.000000,Max=30.000000),Z=(Min=30.000000,Max=30.000000))
        Texture=Texture'AW-2004Explosions.Fire.Part_explode2s'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        StartVelocityRange=(X=(Max=15.000000),Y=(Max=15.000000),Z=(Min=25.000000,Max=55.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter2'
}