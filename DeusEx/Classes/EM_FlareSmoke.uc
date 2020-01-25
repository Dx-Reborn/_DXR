/* Orange smoke emitter for flare */

class EM_FlareSmoke extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        FadeOut=True
        UseSizeScale=True
        UseRegularSizeScale=False
        ScaleSizeXByVelocity=True
        ScaleSizeYByVelocity=True
        ScaleSizeZByVelocity=True
        Acceleration=(Z=10.000000)
        ColorScale(0)=(Color=(B=85,G=170,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.500000
        FadeOutFactor=(W=2.000000,X=2.000000,Y=2.000000,Z=2.000000)
        FadeOutStartTime=1.000000
        MaxParticles=30
        EffectAxis=PTEA_PositiveZ
        StartLocationOffset=(Z=-1.000000)
        StartLocationShape=PTLS_Sphere
        SizeScale(0)=(RelativeTime=5.000000,RelativeSize=4.000000)
        StartSizeRange=(X=(Min=4.000000,Max=8.000000),Y=(Min=4.000000,Max=8.000000),Z=(Min=-25.000000,Max=25.000000))
        ScaleSizeByVelocityMultiplier=(X=0.100000,Y=0.180000,Z=2.000000)
        Texture=FireTexture'Effects.Smoke.SmokePuff1'
        LifetimeRange=(Max=8.000000)
        StartVelocityRange=(X=(Min=-15.000000,Max=15.000000),Y=(Max=15.000000))
        AddVelocityMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
        GetVelocityDirectionFrom=PTVD_OwnerAndStartPosition
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'
}