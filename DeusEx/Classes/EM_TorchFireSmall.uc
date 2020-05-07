class EM_TorchFireSmall extends EM_TorchFire;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        Acceleration=(Z=0.554800)
        ColorScale(0)=(Color=(B=218,G=218,R=218,A=255))
        ColorScale(1)=(RelativeTime=0.471429,Color=(G=116,R=232,A=255))
        ColorScale(2)=(RelativeTime=0.828571,Color=(B=4,R=185,A=255))
        ColorScale(3)=(RelativeTime=0.982143,Color=(A=255))
        ColorScale(4)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.730000,Max=0.730000),Y=(Min=0.511000,Max=0.730000),Z=(Min=0.511000,Max=0.730000))
        FadeOutStartTime=1.292308
        FadeInEndTime=0.305128
        MaxParticles=20
        Name="SpriteEmitter1"
        StartLocationOffset=(Z=9.706000)
        StartLocationRange=(X=(Min=-0.220000,Max=0.220000),Y=(Min=-0.220000,Max=0.220000))
        SpinsPerSecondRange=(X=(Min=-0.129000,Max=0.129000))
        StartSpinRange=(X=(Min=-0.020000,Max=0.020000))
        SizeScale(0)=(RelativeSize=0.032000)
        SizeScale(1)=(RelativeTime=0.070000,RelativeSize=0.600000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=-0.215000)
        StartSizeRange=(X=(Min=3.160300,Max=3.792360),Y=(Min=7.832990,Max=7.832990),Z=(Min=0.110000,Max=0.110000))
        Texture=Texture'DeusExStaticMeshes.Misc.VertFlame4'
        LifetimeRange=(Min=1.794872,Max=1.794872)
        StartVelocityRange=(Z=(Min=4.290000,Max=4.695405))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'
}