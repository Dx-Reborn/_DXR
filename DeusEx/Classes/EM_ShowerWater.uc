// Вода для душа (наверное :D)
class EM_ShowerWater extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseDirectionAs=PTDU_Up
        UseCollision=True
        UseMaxCollisions=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        ScaleSizeYByVelocity=True
        AddVelocityFromOwner=True
        Acceleration=(Z=-600.000000)
        DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        MaxCollisions=(Min=1.000000,Max=1.000000)
        ColorScale(0)=(RelativeTime=0.200000,Color=(G=255,A=255))
        ColorScale(1)=(RelativeTime=0.200000,Color=(R=255,A=255))
        ColorScaleRepeats=1.000000
        Opacity=0.500000
        FadeOutStartTime=2.000000
        FadeInEndTime=0.100000
        MaxParticles=100
        Name="SpriteEmitter0"
        StartLocationShape=PTLS_Sphere
        SphereRadiusRange=(Min=1.000000,Max=1.000000)
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.300000,Max=0.300000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.050000,Z=0.000000)
        DrawStyle=PTDS_Brighten
        Texture=Texture'Effects.Generated.WtrDrpSmall'
        SecondsBeforeInactive=0.100000
        LifetimeRange=(Min=1.000000,Max=1.000000)
//        StartVelocityRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=-15.000000,Max=15.000000),Z=(Min=-15.000000,Max=15.000000))
        StartVelocityRange=(X=(Min=45.000000,Max=45.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-45.000000,Max=45.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'
}
