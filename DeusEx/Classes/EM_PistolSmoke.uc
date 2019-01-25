
class EM_PistolSmoke extends DeusExEmitter;

#exec obj load file=1945.utx

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
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
        FadeInFactor=(W=0.100000,X=0.100000,Y=0.100000,Z=0.100000)
        MaxParticles=2
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Max=0.020000))
        SizeScale(0)=(RelativeSize=0.300000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=8.000000,Max=8.000000),Y=(Min=8.000000,Max=8.000000),Z=(Min=8.000000,Max=8.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'1945.Effects.pfx_smoke_02'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=1.500000,Max=1.500000)
        StartVelocityRange=(X=(Min=4.000000,Max=4.000000),Y=(Min=4.000000,Max=4.000000),Z=(Min=3.000000,Max=6.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'
}
