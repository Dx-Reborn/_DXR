class EM_GasExplosion extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter71
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=120,R=120))
        ColorScale(1)=(RelativeTime=0.100000,Color=(B=128,G=120,R=120))
        ColorScale(2)=(RelativeTime=0.300000,Color=(B=128,G=120,R=120,A=255))
        ColorScale(3)=(RelativeTime=0.800000,Color=(B=124,G=124,R=124,A=255))
        ColorScale(4)=(RelativeTime=1.000000,Color=(B=124,G=124,R=124))
        MaxParticles=70
        RespawnDeadParticles=False
        StartLocationRange=(X=(Min=350.000000,Max=-350.000000),Y=(Min=350.000000,Max=-350.000000),Z=(Max=128.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.050000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Max=150.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudB'
        LifetimeRange=(Min=8.000000,Max=9.000000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter71'
}