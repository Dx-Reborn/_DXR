//
// Runtime examples
//

class EM_TorchFire extends DeusExEmitter;

defaultproperties
{
   Begin Object Class=SpriteEmitter Name=SpriteEmitter229
        Acceleration=(Z=8.290000)
        UseColorScale=True
        ColorScale(0)=(Color=(B=218,G=218,R=218,A=255))
        ColorScale(1)=(RelativeTime=0.475000,Color=(G=116,R=232,A=255))
        ColorScale(2)=(RelativeTime=0.832143,Color=(B=4,R=185,A=255))
        ColorScale(3)=(RelativeTime=0.989286,Color=(A=255))
        ColorMultiplierRange=(X=(Min=0.730000,Max=0.730000),Y=(Min=0.511000,Max=0.730000),Z=(Min=0.511000,Max=0.730000))
        FadeOutStartTime=1.008000
        FadeOut=True
        FadeInEndTime=0.238000
        FadeIn=True
        MaxParticles=20
        Name="MyParticles0"
        StartLocationOffset=(Z=9.706000)
        StartLocationRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000))
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.166000,Max=0.166000))
        StartSpinRange=(X=(Min=-0.020000,Max=0.020000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.032000)
        SizeScale(1)=(RelativeTime=0.070000,RelativeSize=0.600000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=-0.215000)
        StartSizeRange=(X=(Min=28.730000,Max=34.476002),Y=(Min=71.209000,Max=71.209000),Z=(Min=1.000000,Max=1.000000))
        UniformSize=True
        Texture=Texture'DeusExStaticMeshes.Misc.VertFlame4'
        LifetimeRange=(Min=1.400000,Max=1.400000)
        StartVelocityRange=(Z=(Min=50.000000,Max=54.724998))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter229'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter230
        UseColorScale=True
        ColorScale(0)=(RelativeTime=0.300000,Color=(B=200,G=255,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=150,R=200))
        FadeOutStartTime=1.000000
        FadeOut=True
        FadeInEndTime=0.400000
        FadeIn=True
        MaxParticles=12
        Name="MyParticles1"
        StartLocationOffset=(Z=30.000000)
        SpinParticles=True
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.100000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=7.000000,Max=12.000000))
        Texture=Texture'DeusExStaticMeshes.Misc.SparkOffSet'
        LifetimeRange=(Min=0.700000,Max=2.000000)
        StartVelocityRange=(Z=(Min=25.000000,Max=100.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter230'
    Begin Object Class=SpriteEmitter Name=SpriteEmitter105
        UseColorScale=True
        ColorScale(1)=(RelativeTime=0.214286,Color=(B=30,G=30,R=30,A=255))
        ColorScale(2)=(RelativeTime=1.000000)
        MaxParticles=6
        Name="MyParticles2"
        StartLocationRange=(Z=(Max=22.000000))
        UseSizeScale=True
        UseRegularSizeScale=False
        SizeScale(0)=(RelativeSize=0.400000)
        SizeScale(1)=(RelativeTime=0.150000,RelativeSize=0.500000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=27.000000,Max=27.000000),Y=(Min=0.500000,Max=0.500000))
        InitialParticlesPerSecond=6.000000
        DrawStyle=PTDS_Darken
        Texture=Texture'DeusExStaticMeshes.Misc.fog1'
        LifetimeRange=(Min=1.400000,Max=1.400000)
        StartVelocityRange=(X=(Min=-4.230000,Max=4.230000),Y=(Min=-4.230000,Max=4.230000),Z=(Min=66.375000,Max=66.375000))
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter105'
}

