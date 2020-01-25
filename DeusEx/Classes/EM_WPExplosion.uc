//
// Оранжевый взрыв дыма для фосфорных ракет.
//

class EM_WPExplosion extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_Up
        ProjectionNormal=(Z=0.000000)
        UseColorScale=True
        FadeOut=True
        UseSizeScale=True
        UseRegularSizeScale=False
        DetermineVelocityByLocationDifference=True
        ScaleSizeZByVelocity=True
        Acceleration=(Z=-10.000000)
        ColorScale(0)=(RelativeTime=0.500000,Color=(B=64,G=128,R=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255))
        Opacity=0.400000
        FadeOutFactor=(W=2.000000,X=2.000000,Y=2.000000,Z=2.000000)
        FadeOutStartTime=2.200000
        MaxParticles=200
        EffectAxis=PTEA_PositiveZ
        StartLocationOffset=(Z=-1.000000)
        StartLocationShape=PTLS_Sphere
        SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
        SizeScale(0)=(RelativeTime=5.000000,RelativeSize=35.000000)
        StartSizeRange=(X=(Min=8.000000,Max=8.000000),Y=(Min=8.000000,Max=8.000000),Z=(Min=25.000000,Max=25.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        Texture=FireTexture'Effects.Fire.FireballWhite'
        TextureUSubdivisions=-1
        TextureVSubdivisions=-1
        StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
        AddVelocityMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))

        respawnDeadParticles=false
        AutoDestroy=true

    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'

		lifeSpan=8.0
}