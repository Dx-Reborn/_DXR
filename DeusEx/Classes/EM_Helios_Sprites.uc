/*
   Used in Game Ending 2.
*/
class EM_Helios_Sprites extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        FadeOut=True
        SpinParticles=True
        UniformSize=True
        TriggerDisabled=true // false?? Как-то нелогично...
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.180000
        MaxParticles=120
        Name="SpriteEmitter0"
        StartLocationRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000))
        SpinsPerSecondRange=(X=(Min=0.050000,Max=1.000000),Y=(Min=0.050000,Max=0.100000),Z=(Min=0.050000,Max=0.100000))
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        Texture=Texture'Effects.Corona.Corona_E'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=60.000000,Max=60.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}