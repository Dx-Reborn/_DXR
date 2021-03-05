class EM_CigSmoke extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=True
        RespawnDeadParticles=False
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        Acceleration=(Z=40.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=128))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        MaxParticles=50
        /*AutoReset=True
        AutoResetTimeRange=(Min=3.000000,Max=4.000000)*/
        Name="SpriteEmitter0"
        UseRotationFrom=PTRS_Actor
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=15.000000,Max=55.000000),Y=(Min=40.000000,Max=40.000000),Z=(Min=40.000000,Max=40.000000))
        InitialParticlesPerSecond=20.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudB'
        LifetimeRange=(Min=1.000000,Max=1.200000)
        StartVelocityRange=(X=(Min=110.000000,Max=300.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000,Max=50.000000))
        VelocityLossRange=(X=(Min=1.000000,Max=2.000000),Y=(Min=5.000000,Max=10.000000),Z=(Min=5.000000,Max=10.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}


