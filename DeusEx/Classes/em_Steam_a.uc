/*
   Used in Area51 Entrance
*/
class EM_Steam_a extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseDirectionAs=PTDU_Up
        ProjectionNormal=(Z=0.000000)
        UseColorScale=True
        FadeOut=True
        UseSizeScale=True
        UseRegularSizeScale=False
        DetermineVelocityByLocationDifference=True
        UseSubdivisionScale=True
        Acceleration=(Y=-20.000000,Z=4.000000)
        ColorScale(0)=(RelativeTime=1.000000,Color=(B=192,G=192,R=192,A=255))
        FadeOutFactor=(W=2.000000,X=2.000000,Y=2.000000,Z=2.000000)
        FadeOutStartTime=1.000000
        MaxParticles=15
        EffectAxis=PTEA_PositiveZ
        StartLocationOffset=(Z=-1.000000)
        StartLocationShape=PTLS_Sphere
        SizeScale(0)=(RelativeTime=5.000000,RelativeSize=55.000000)
        StartSizeRange=(X=(Min=15.000000,Max=15.000000),Y=(Min=15.000000,Max=15.000000),Z=(Min=25.000000,Max=25.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        Texture=Texture'WarEffectsTextures.Particles.gas2'
        TextureUSubdivisions=3
        TextureVSubdivisions=3
        LifetimeRange=(Min=7.000000,Max=7.000000)
        AddVelocityMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        GetVelocityDirectionFrom=PTVD_OwnerAndStartPosition
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter2'
}