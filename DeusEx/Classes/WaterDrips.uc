/*
    

*/
class WaterDrips extends DeusExEmitter; //ParticleGenerator;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        ProjectionNormal=(Z=-1.000000)
        UseCollision=True
        UseMaxCollisions=True
        UniformSize=True
        Acceleration=(Z=-100.000000)
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        MaxParticles=1
        Name="SpriteEmitter0"
        StartSizeRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
        Texture=Texture'Effects.Generated.WtrDrpSmall'
        LifetimeRange=(Min=2.000000,Max=2.000000)
        StartVelocityRange=(Z=(Min=-40.000000,Max=-50.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}