class EM_DustRing extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2278
        UseDirectionAs=PTDU_Forward
        Acceleration=(Z=100)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(Y=(Min=0.8,Max=0.8),Z=(Min=0.6,Max=0.6))
        FadeOutStartTime=0.45
        FadeInEndTime=0.325
        MaxParticles=100
        StartLocationRange=(X=(Min=-100,Max=100),Y=(Min=-100,Max=100))
        SpinsPerSecondRange=(X=(Max=0.05))
        StartSpinRange=(X=(Max=1))
        SizeScale(1)=(RelativeTime=1,RelativeSize=4)
        StartSizeRange=(X=(Min=150,Max=200),Y=(Min=150,Max=200),Z=(Min=150,Max=200))
        InitialParticlesPerSecond=1000
        DrawStyle=PTDS_Brighten
        Texture=Texture'EmitterTextures.SingleFrame.FlamePart_01'
        SecondsBeforeInactive=0
        LifetimeRange=(Min=1.5,Max=2)
        StartVelocityRange=(X=(Min=-1000,Max=1000),Y=(Min=-1000,Max=1000),Z=(Min=20,Max=20))
        FadeIn=True
        FadeOut=True
        RespawnDeadParticles=False
        AutoDestroy=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter2278'
}