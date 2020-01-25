class EM_ConcreteHit_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter61
        Acceleration=(Z=-10.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=64))
        ColorScale(1)=(RelativeTime=0.600000,Color=(B=255,G=255,R=255,A=128))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        MaxParticles=5
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=0.100000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=10.000000,Max=12.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.CloudB'
        LifetimeRange=(Min=1.200000,Max=1.500000)
        StartVelocityRange=(X=(Max=300.000000),Y=(Min=50.000000,Max=-50.000000),Z=(Min=50.000000,Max=-50.000000))
        VelocityLossRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=3.000000,Max=4.000000),Z=(Min=3.000000,Max=4.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter62
        Acceleration=(Z=-600.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=128,G=128,R=128,A=255))
        ColorScale(1)=(RelativeTime=0.800000,Color=(B=128,G=128,R=128,A=64))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=83,G=87,R=87))
        MaxParticles=30
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=2.000000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.MiscChips'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.300000,Max=0.500000)
        StartVelocityRange=(X=(Max=200.000000),Y=(Min=100.000000,Max=-100.000000),Z=(Min=100.000000,Max=-100.000000))
    End Object
    Begin Object Class=Engine.SpriteEmitter Name=SpriteEmitter63
        Acceleration=(Z=-600.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=85,G=85,R=85,A=128))
        ColorScale(1)=(RelativeTime=0.800000,Color=(B=85,G=85,R=85,A=128))
        ColorScale(2)=(RelativeTime=1.000000,Color=(B=85,G=85,R=85))
        MaxParticles=20
        RespawnDeadParticles=False
        SpinParticles=True
        SpinsPerSecondRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        StartSizeRange=(X=(Min=0.500000,Max=2.000000))
        UniformSize=True
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.MiscChips'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        UseRandomSubdivision=True
        LifetimeRange=(Min=0.600000,Max=0.600000)
        StartVelocityRange=(Y=(Min=5.000000,Max=-5.000000))
    End Object
/*    Begin Object Class=Engine.MeshEmitter Name=MeshEmitter20
        StaticMesh=StaticMesh'BallisticHardware2.Impact.Shard3'
        Acceleration=(Z=-600.000000)
        RespawnDeadParticles=False
        UseRotationFrom=PTRS_Actor
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=2.000000,Max=5.000000),Y=(Min=2.000000,Max=5.000000),Z=(Min=2.000000,Max=5.000000))
        StartSizeRange=(X=(Min=0.200000,Max=0.600000))
        UniformSize=True
        InitialParticlesPerSecond=3000.000000
        AutomaticInitialSpawning=False
        LifetimeRange=(Min=0.800000,Max=1.000000)
        StartVelocityRange=(X=(Max=150.000000),Y=(Min=50.000000,Max=-50.000000),Z=(Max=200.000000))
    End Object*/
    Emitters(0)=SpriteEmitter'SpriteEmitter61'
    Emitters(1)=SpriteEmitter'SpriteEmitter62'
    Emitters(2)=SpriteEmitter'SpriteEmitter63'
//    Emitters(3)=MeshEmitter'MeshEmitter20'
}