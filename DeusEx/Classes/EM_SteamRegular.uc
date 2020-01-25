//ѕар или белый дым

class EM_SteamRegular extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=EM_SteamRegular0
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UniformSize=True
        Acceleration=(X=1.700000)
        ColorScale(0)=(Color=(G=128,R=255,A=255))
        ColorScale(1)=(RelativeTime=0.514286,Color=(G=255,A=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,A=255))
        ColorScaleRepeats=1.000000
        FadeOutStartTime=2.000000
        FadeInEndTime=2.000000
        MaxParticles=20

        SphereRadiusRange=(Max=75.000000)
        StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=80.066002,Max=80.066002),Y=(Min=80.066002,Max=80.066002),Z=(Min=80.066002,Max=80.066002))
        Texture=Texture'Effects.Smoke.Smokepuff'
        LifetimeRange=(Min=5.028000,Max=5.028000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=20.000000,Max=20.000000))
    End Object
    Emitters(0)=SpriteEmitter'EM_SteamRegular0'
}