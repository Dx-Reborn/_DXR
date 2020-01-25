//=-=-=-=-=
// Что-то зелёное и явно ядовитое.

class EM_BarrelSpray extends DeusExEmitter;

defaultproperties
{
/*    Begin Object Class=SpriteEmitter Name=SpriteEmitter0  << Подсказка, что нужно убрать.
        ProjectionNormal=(Z=0.000000)
        FadeOut=True
        UseRegularSizeScale=False
        UniformSize=True
        Acceleration=(Z=10.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutFactor=(W=3.000000,X=3.000000,Y=3.000000,Z=3.000000)
        FadeOutStartTime=2.000000
        MaxParticles=8
        EffectAxis=PTEA_PositiveZ
        Name="SpriteEmitter0"
        StartLocationOffset=(Z=-1.000000)
        StartLocationShape=PTLS_Sphere
        SizeScaleRepeats=2.000000
        StartSizeRange=(X=(Min=-20.000000,Max=-20.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        Texture=FireTexture'Effects.Smoke.SmokeSpray1'
        AddVelocityMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        GetVelocityDirectionFrom=PTVD_OwnerAndStartPosition
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0' << Обязательно убрать MyLevel */
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_Up
        ProjectionNormal=(Z=0.000000)
        UseColorScale=True
        FadeOut=True
        UseSizeScale=True
        UseRegularSizeScale=False
        DetermineVelocityByLocationDifference=True
        ScaleSizeZByVelocity=True
        UseSubdivisionScale=True
        Acceleration=(Z=10.000000)
        ColorScale(0)=(Color=(B=9,G=198,R=136,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutFactor=(W=2.000000,X=2.000000,Y=2.000000,Z=2.000000)
        FadeOutStartTime=1.000000
        MaxParticles=48 // 8
        EffectAxis=PTEA_PositiveZ
        StartLocationOffset=(Z=-1.000000)
        StartLocationShape=PTLS_Sphere
        SizeScale(0)=(RelativeTime=5.000000,RelativeSize=15.000000)
        StartSizeRange=(X=(Min=8.000000,Max=8.000000),Y=(Min=8.000000,Max=8.000000),Z=(Min=25.000000,Max=25.000000))
        ScaleSizeByVelocityMultiplier=(X=0.000000,Y=0.000000,Z=0.000000)
        Texture=Texture'WarEffectsTextures.Particles.gas2'
        TextureUSubdivisions=3
        TextureVSubdivisions=3
        AddVelocityMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        GetVelocityDirectionFrom=PTVD_OwnerAndStartPosition
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'

    bNoDelete=false
}
