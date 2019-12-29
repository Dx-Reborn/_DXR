class EM_StickyFire extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter64
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UniformSize=True
        BlendBetweenSubdivisions=True
        Acceleration=(Z=1.000000)
        ColorScale(0)=(Color=(G=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,G=255,R=255,A=255))
        ColorScaleRepeats=1.000000
        FadeOutStartTime=1.980000
        FadeInEndTime=0.900000
        MaxParticles=4
        Name="SpriteEmitter64"
        SphereRadiusRange=(Max=75.000000)
        StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
        Texture=Texture'DXR_FX.Effects.Explosion_Flame'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=5.000000,Max=8.000000)
        RespawnDeadParticles=false
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter64'
    AutoDestroy=True
}