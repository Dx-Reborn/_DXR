class EM_AssaultGunSmoke extends DeusExEmitter;

defaultproperties
{    
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter38
        Acceleration=(Z=-10.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=64))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        MaxParticles=15
        RespawnDeadParticles=False
//        StartLocationOffset=(X=40.000000,Y=-1.000000,Z=8.500000)
        StartLocationOffset=(X=0.000000,Y=0.000000,Z=0.000000)
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.200000))
        StartSpinRange=(X=(Max=500.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudB'
        LifetimeRange=(Min=0.500000,Max=0.800000)
        StartVelocityRange=(X=(Min=150.000000,Max=500.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
        VelocityLossRange=(X=(Min=3.000000,Max=6.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
/*    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter39
        UseDirectionAs=PTDU_Forward
        UseCollision=True
        DampingFactorRange=(X=(Min=0.200000,Max=0.500000),Y=(Min=0.200000,Max=0.500000),Z=(Min=0.200000,Max=0.500000))
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        RespawnDeadParticles=False
        StartLocationOffset=(X=44.000000,Y=-1.000000,Z=8.000000)
        StartSizeRange=(X=(Min=8.000000,Max=15.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_Brighten
        Texture=Texture'FlatFXTex34'
        LifetimeRange=(Min=0.060000,Max=0.060000)
        StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
    End Object*/

    Emitters(0)=SpriteEmitter'SpriteEmitter38'
//    Emitters(1)=SpriteEmitter'SpriteEmitter39'
}