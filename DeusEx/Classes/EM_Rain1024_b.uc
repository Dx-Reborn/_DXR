class EM_Rain1024_b extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter9
        UseDirectionAs=PTDU_Up
        UseColorScale=True
        UseSizeScale=True
        UseRegularSizeScale=False
        Acceleration=(Z=-600.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=64))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255))
        MaxParticles=400
        Name="SpriteEmitter9"
        StartLocationRange=(X=(Min=512.000000,Max=-512.000000),Y=(Min=220.000000,Max=-220.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000)
        StartSizeRange=(X=(Min=0.500000,Max=2.000000),Y=(Min=3.000000,Max=8.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'BallisticEffects.Particles.Smoke6'
        LifetimeRange=(Min=0.600000,Max=0.600000)
        StartVelocityRange=(X=(Min=-2.000000,Max=2.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=100.000000,Max=120.000000))
        VelocityLossRange=(Z=(Min=11.000000,Max=11.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter9'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter10
        UseDirectionAs=PTDU_Normal
        UseColorScale=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        ColorScale(0)=(Color=(B=48,G=48,R=48))
        ColorScale(1)=(RelativeTime=1.000000)
        MaxParticles=60
        Name="SpriteEmitter10"
        StartLocationRange=(X=(Min=512.000000,Max=-512.000000),Y=(Min=220.000000,Max=-220.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=6.000000,Max=20.000000))
        Texture=Texture'BallisticEffects.Particles.WaterRing1'
        LifetimeRange=(Min=0.200000,Max=0.500000)
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter10'
}