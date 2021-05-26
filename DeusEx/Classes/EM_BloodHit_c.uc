class EM_BloodHit_c extends DeusExEmitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UseColorScale=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-4.531500)
        ColorScale(0)=(Color=(B=6,G=2,R=164,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=3,G=1,R=99))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000))
        StartSpinRange=(X=(Min=1.000000,Max=1.000000))
        SizeScale(1)=(RelativeTime=0.170000,RelativeSize=0.800000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.510500,Max=3.021000),Y=(Min=30.209997,Max=30.209997),Z=(Min=30.209997,Max=30.209997))
        InitialParticlesPerSecond=3000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.500000,Max=0.800000)
        StartVelocityRange=(X=(Max=45.314995))
        VelocityLossRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        UseColorScale=True
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(X=0.660000,Z=-22.000000)
        ColorScale(0)=(Color=(B=11,G=7,R=114,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=4,G=1,R=126,A=255))
        FadeOutStartTime=0.096000
        MaxParticles=33
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=0.330000,Max=0.330000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        InitialParticlesPerSecond=3000.000000
        DrawStyle=PTDS_Modulated
//        Texture=Texture'FlBloods.Blood.FlatFXTex3'
        LifetimeRange=(Min=0.400000,Max=0.800000)
        StartVelocityRange=(X=(Max=15.000000),Y=(Min=-0.330000,Max=0.330000),Z=(Max=7.260000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter6'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter7
        UseColorScale=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=-3.498000)
        ColorScale(0)=(Color=(B=141,G=141,R=141,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=74,G=74,R=74))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000))
        StartSpinRange=(X=(Min=1.000000,Max=1.000000))
        SizeScale(1)=(RelativeTime=0.170000,RelativeSize=0.800000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.166000,Max=2.332000),Y=(Min=23.319998,Max=23.319998),Z=(Min=23.319998,Max=23.319998))
        InitialParticlesPerSecond=3000.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudWhite'
        LifetimeRange=(Min=0.500000,Max=0.800000)
        StartVelocityRange=(X=(Max=34.979996))
        VelocityLossRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter7'

    AutoDestroy=True
}