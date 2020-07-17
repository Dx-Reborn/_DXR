class EM_YellowDust extends DeusExEmitter;

/*event PostBeginPlay()
{
    Super.PostBeginPlay();

    SetTimer(RandRange(5, 10), false);
}

event SetInitialState()
{
    Super.SetInitialState();

    Emitters[0].AutomaticInitialSpawning = true;
}
*/
event Timer()
{
    Kill();
}

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UniformSize=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=63,R=125,A=255))
        Opacity=0.20
        FadeOutStartTime=3.972120
        FadeInEndTime=2.463720
        MaxParticles=20
        Name="SpriteEmitter0"
        SphereRadiusRange=(Max=75.000000)
        StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=80.066002,Max=80.066002),Y=(Min=80.066002,Max=80.066002),Z=(Min=80.066002,Max=80.066002))
        Texture=Texture'DXR_FX.Effects.Plasma02_gs_a'
        LifetimeRange=(Min=5.028000,Max=5.028000)
        StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        SecondsBeforeInactive=0
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}