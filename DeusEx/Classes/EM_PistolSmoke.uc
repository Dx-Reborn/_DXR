/*

*/
class EM_PistolSmoke extends DeusExEmitter;


defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter71
        FadeOut=True
        FadeIn=True
        RespawnDeadParticles=False
        AutoDestroy=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        AutomaticInitialSpawning=False
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=0.100000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeInFactor=(W=0.100000,X=0.100000,Y=0.100000,Z=0.100000)
        MaxParticles=2
        Name="SpriteEmitter71"
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.020000))
        SizeScale(0)=(RelativeSize=0.300000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=8.000000,Max=8.000000),Y=(Min=8.000000,Max=8.000000),Z=(Min=8.000000,Max=8.000000))
        InitialParticlesPerSecond=200.000000
        Texture=Texture'DXR_FX.Effects.pfx_smoke_01'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=-1.500000,Max=1.500000),Y=(Min=-1.500000,Max=1.500000),Z=(Min=3.000000,Max=6.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter71'
}
