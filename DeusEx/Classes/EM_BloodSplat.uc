class EM_BloodSplat extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter83
        ProjectionNormal=(X=1.000000,Z=0.000000)
        FadeOut=True
        RespawnDeadParticles=False
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        AutomaticInitialSpawning=False
        UniformSize=True
        UseRandomSubdivision=True
        Acceleration=(Z=-300.000000)
        FadeOutFactor=(X=0.000000,Y=0.000000,Z=0.000000)
        FadeOutStartTime=0.200000
        MaxParticles=2
        SpinsPerSecondRange=(X=(Min=0.100000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=20.000000,Max=30.000000),Y=(Min=10.000000,Max=20.000000),Z=(Min=10.000000,Max=20.000000))
        InitialParticlesPerSecond=100.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_fx.Particles.Blood3'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=50.000000,Max=100.000000))
        Name="SpriteEmitter83"
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter83'
}