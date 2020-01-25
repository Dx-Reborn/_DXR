//
// Немного искр
//

class EM_Sparks extends DeusExEmitter;

defaultproperties
{
// Сделано специально для роботов.
// Добавлен звук и разброс.
    Begin Object Class=SparkEmitter Name=SparkEmitter1
        LineSegmentsRange=(Min=-2.000000,Max=2.000000)
        TimeBetweenSegmentsRange=(Min=0.020000,Max=0.020000)
        UseCollision=True
        UseMaxCollisions=True
        UseColorScale=True
        Acceleration=(Z=-682.431030)
        MaxCollisions=(Min=1.000000,Max=2.000000)
        ColorScale(0)=(Color=(B=255,G=253,R=251,A=255))
        ColorScale(1)=(RelativeTime=0.442857,Color=(G=255,R=255,A=255))
        ColorScale(2)=(RelativeTime=0.782143,Color=(B=137,G=196,R=254,A=255))
        ColorScale(3)=(RelativeTime=1.000000,Color=(B=75,G=138,R=241,A=255))
        MaxParticles=16
        StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-10.000000,Max=10.000000))
        Sounds(0)=(Sound=Sound'DeusExSounds.Generic.Spark2',Radius=(Max=64.000000),Pitch=(Min=1.000000,Max=1.000000),Volume=(Min=1.000000,Max=64.000000),Probability=(Min=0.100000,Max=0.200000))
        SpawningSound=PTSC_Random
        SpawningSoundProbability=(Min=0.100000,Max=0.200000)
        InitialParticlesPerSecond=13.000000
        Texture=FireTexture'Effects.Fire.OnFire_J'
        LifetimeRange=(Min=0.180000,Max=0.500000)
        StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
    End Object
    Emitters(0)=SparkEmitter'SparkEmitter1'



}
