//
// Runtime examples
//

class EM_arcweld extends DeusExEmitter;

defaultproperties
{
   Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        ProjectionNormal=(Z=0.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=222,G=96,R=58,A=255))
        ColorMultiplierRange=(X=(Min=0.341538,Max=0.341538),Y=(Min=0.341538,Max=0.341538),Z=(Min=0.341538,Max=0.341538))
        FadeOutStartTime=0.192000
        FadeOut=True
        FadeInEndTime=0.036000
        FadeIn=True
        MaxParticles=8
        Name="SpriteEmitter2"
        StartLocationRange=(Z=(Min=-8.898000,Max=0.038000))
        SpinParticles=True
        StartSpinRange=(X=(Min=0.450000,Max=0.550000))
        StartSizeRange=(X=(Min=37.000000,Max=45.000000))
        InitialParticlesPerSecond=99.000000
        AutomaticInitialSpawning=False
        Texture=Texture'DeusExStaticMeshes.Misc.arcy2'
        LifetimeRange=(Min=0.100000,Max=0.200000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter3'
    Begin Object Class=SparkEmitter Name=SparkEmitter0
        LineSegmentsRange=(Min=3.000000,Max=3.000000)
        TimeBetweenSegmentsRange=(Min=0.020000,Max=0.020000)
        Acceleration=(Z=-682.431030)
        UseCollision=True
        UseCollisionPlanes=True
        CollisionPlanes(0)=(W=444.000000,Z=1.000000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=255,G=253,R=251,A=255))
        ColorScale(1)=(RelativeTime=0.442857,Color=(B=253,G=193,R=179,A=255))
        ColorScale(2)=(RelativeTime=0.782143,Color=(B=137,G=196,R=254,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=75,G=138,R=241,A=255))
        MaxParticles=44
        Name="sparks"
        InitialParticlesPerSecond=13.000000
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'Engine.DecoPaint'
        LifetimeRange=(Min=0.180000,Max=0.500000)
        StartVelocityRange=(X=(Min=-155.000000,Max=155.000000),Y=(Min=-155.000000,Max=155.000000),Z=(Min=55.000000,Max=439.898010))
    End Object
    Emitters(1)=SparkEmitter'SparkEmitter0'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        Acceleration=(X=1.000000,Y=1.000000,Z=10.000000)
        UseColorScale=True
        ColorMultiplierRange=(X=(Min=0.100800,Max=0.100800),Y=(Min=0.100800,Max=0.100800),Z=(Min=0.100800,Max=0.100800))
        FadeOutStartTime=2.720000
        FadeOut=True
        FadeInEndTime=0.400000
        FadeIn=True
        MaxParticles=4
        Name="fog"
        StartLocationOffset=(Z=41.000000)
        StartLocationRange=(X=(Min=-8.000000,Max=8.000000),Z=(Min=-5.000000,Max=5.000000))
        SpinParticles=True
        StartSpinRange=(X=(Min=-71.000000,Max=71.000000))
        StartSizeRange=(X=(Min=40.000000,Max=44.000000))
        Texture=Texture'DeusExStaticMeshes.Misc.arcsmoke'
        WarmupTicksPerSecond=11.000000
        RelativeWarmupTime=11.000000
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter0'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        ColorScale(0)=(Color=(A=255))
        ColorScale(1)=(RelativeTime=0.089286,Color=(A=255))
        ColorScale(2)=(RelativeTime=0.128571,Color=(B=255,G=255,R=255,A=255))
        ColorScale(3)=(RelativeTime=0.164286,Color=(A=255))
        ColorScale(4)=(RelativeTime=0.289286,Color=(A=255))
        ColorScale(5)=(RelativeTime=0.317857,Color=(B=255,G=255,R=255,A=255))
        ColorScale(6)=(RelativeTime=0.357143,Color=(A=255))
        ColorScale(7)=(RelativeTime=0.782143,Color=(A=255))
        ColorScale(8)=(RelativeTime=0.817857,Color=(B=255,G=255,R=255,A=255))
        ColorScale(9)=(RelativeTime=0.857143,Color=(A=255))
        ColorScale(10)=(RelativeTime=1.000000,Color=(A=255))
        ColorScaleRepeats=32.000000
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        FadeOutStartTime=9.700000
        FadeOut=True
        FadeInEndTime=0.200000
        FadeIn=True
        MaxParticles=2
        Name="fog256"
        StartLocationRange=(Z=(Min=30.780001,Max=30.780001))
        StartSizeRange=(X=(Min=50.000000,Max=50.000000))
        InitialParticlesPerSecond=0.011000
        AutomaticInitialSpawning=False
        Texture=Texture'DeusExStaticMeshes.Misc.arcsmoke256'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        BlendBetweenSubdivisions=True
        SubdivisionScale(0)=0.250000
        SubdivisionScale(1)=0.250000
        SubdivisionScale(2)=0.250000
        LifetimeRange=(Min=9.000000,Max=9.000000)
        WarmupTicksPerSecond=12.708000
        RelativeWarmupTime=11.412000
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter1'
}

