class EM_BlueSparks extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1251
        ColorScale(0)=(Color=(B=89,G=206,R=83))
        ColorScale(1)=(RelativeTime=1,Color=(B=63,G=39,R=41))
        FadeOutStartTime=0.1
        MaxParticles=1
        Name="puff"
        SpinsPerSecondRange=(X=(Max=0.315))
        StartSpinRange=(X=(Min=-1,Max=1))
        SizeScale(0)=(RelativeSize=0.02)
        SizeScale(1)=(RelativeTime=1,RelativeSize=0.2)
        StartSizeRange=(X=(Min=10,Max=20),Y=(Min=10,Max=20),Z=(Min=10,Max=20))
        InitialParticlesPerSecond=2000
//        Texture=Texture'EffectTex.Energy.spark2Seq'
        TextureUSubdivisions=4
        TextureVSubdivisions=1
        SecondsBeforeInactive=0
        LifetimeRange=(Min=0.001,Max=0.3)
        FadeOut=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        AutoDestroy=True
        SpinParticles=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
//        Name="SpriteEmitter1251"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1251'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1252
        ColorScale(0)=(Color=(B=126,G=69,R=69))
        ColorScale(1)=(RelativeTime=0.253571,Color=(B=31,G=31,R=31,A=255))
        ColorScale(2)=(RelativeTime=1)
        Opacity=0.6
        FadeOutStartTime=3
        FadeInEndTime=0.12
        MaxParticles=5
        Name="Smoke"
        SpinsPerSecondRange=(X=(Max=0.36))
        StartSpinRange=(X=(Max=0.3))
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1,RelativeSize=1)
        StartSizeRange=(X=(Min=50,Max=50),Y=(Min=50,Max=50),Z=(Min=50,Max=50))
        InitialParticlesPerSecond=1000
//        Texture=Texture'EffectTex.Smoke.Explosmoke1'
        SecondsBeforeInactive=0
        LifetimeRange=(Min=1,Max=3)
        StartVelocityRange=(X=(Max=10),Y=(Min=-10,Max=10),Z=(Min=10,Max=50))
        UseColorScale=True
        FadeIn=True
        RespawnDeadParticles=False
        AutoDestroy=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
//        Name="SpriteEmitter1252"
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter1252'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1580
        UseDirectionAs=PTDU_Up
        Acceleration=(X=-10,Y=-10,Z=-1000)
        ColorScale(0)=(Color=(B=255,G=255,R=255))
        ColorScale(1)=(RelativeTime=1,Color=(B=83,G=6))
        FadeOutStartTime=0.5
        MaxParticles=100
        Name="Sparks"
        SizeScale(0)=(RelativeSize=0.1)
        SizeScale(1)=(RelativeTime=1,RelativeSize=0.1)
        StartSizeRange=(X=(Min=0.5,Max=1.5),Y=(Min=5,Max=10),Z=(Min=5,Max=10))
        InitialParticlesPerSecond=2000
//        Texture=Texture'EffectTex.Particles.smooth_alpha9'
        SecondsBeforeInactive=0
        LifetimeRange=(Min=0.01,Max=0.5)
        StartVelocityRange=(X=(Max=500),Y=(Min=-300,Max=300),Z=(Min=-300,Max=300))
        UseColorScale=True
        FadeOut=True
        ResetAfterChange=True
        RespawnDeadParticles=False
        AutoDestroy=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
//        Name="SpriteEmitter1580"
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter1580'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1581
        ProjectionNormal=(X=1,Z=0)
        ColorScale(0)=(Color=(B=163,G=231,R=171))
        ColorScale(1)=(RelativeTime=1,Color=(B=133,G=187,R=89))
        Opacity=0.6
        FadeOutStartTime=0.18711
        FadeInEndTime=0.06237
        MaxParticles=1
        Name="Flare"
        StartLocationRange=(Y=(Min=-5,Max=5),Z=(Min=-5,Max=5))
        SpinCCWorCW=(X=0)
        SpinsPerSecondRange=(X=(Max=80))
        StartSpinRange=(X=(Min=-1,Max=1))
        StartSizeRange=(X=(Min=40.2,Max=40.2),Y=(Min=40.2,Max=40.2),Z=(Min=40.2,Max=40.2))
        InitialParticlesPerSecond=1000
//        Texture=Texture'EffectTex.Glows.a_BLUEGLOW'
        SecondsBeforeInactive=0
        LifetimeRange=(Min=0.4,Max=0.693)
        FadeIn=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        SpinParticles=True
        UseSizeScale=True
        UniformSize=True
        AutomaticInitialSpawning=False
//        Name="SpriteEmitter1581"
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter1581'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1596
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        Name="delte"
        StartSizeRange=(X=(Min=80),Y=(Min=80),Z=(Min=80))
//        Texture=Texture'EffectTex.Misc.DoNotUse'
        SecondsBeforeInactive=0
        LifetimeRange=(Min=0.05,Max=0.05)
        InitialDelayRange=(Min=2,Max=2)
        AutoDestroy=True
        UniformSize=True
//        Name="SpriteEmitter1596"
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter1596'
}

