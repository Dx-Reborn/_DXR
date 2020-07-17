class EM_BloodHit_b extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-132.094650)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.070102
        MaxParticles=1
        Name="SpriteEmitter4"
        SpinCCWorCW=(X=0.000000)
        StartSpinRange=(X=(Min=-1.000000,Max=-1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.370000,RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=-15.000000,Max=-15.000000),Y=(Min=-15.000000,Max=-15.000000),Z=(Min=-15.000000,Max=-15.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
//        Texture=Texture'FlBloods.Blood.BloodC'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.382813,Max=0.382813)
        StartVelocityRange=(Z=(Min=52.459244,Max=52.459244))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-118.477394)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.121539
        MaxParticles=1
        Name="SpriteEmitter5"
        SpinCCWorCW=(X=0.000000)
        StartSpinRange=(X=(Min=-1.000000,Max=-1.000000))
        SizeScale(0)=(RelativeSize=0.200000)
        SizeScale(1)=(RelativeTime=0.370000,RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=-35.000000,Max=-35.000000),Y=(Min=-35.000000,Max=-35.000000),Z=(Min=-35.000000,Max=-35.000000))
        InitialParticlesPerSecond=1000.000000
        DrawStyle=PTDS_AlphaBlend
//        Texture=Texture'FlBloods.Blood.BloodCa'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.663702,Max=0.663702)
        StartVelocityRange=(Z=(Min=40.564999,Max=40.564999))
        AddVelocityFromOtherEmitter=1
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter5'
}

