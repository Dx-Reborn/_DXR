// Струя воды для крана

Class EM_WaterFaucet extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        ProjectionNormal=(Z=-1.000000)
        FadeOut=True
        UseRegularSizeScale=False
        UniformSize=True
        UseRandomSubdivision=True
        Acceleration=(Z=-10.000000)
        ColorScale(0)=(Color=(B=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(R=255,A=255))
        ColorScaleRepeats=1.000000
        Opacity=0.200000
        FadeOutStartTime=1.000000
        MaxParticles=30
        Name="SpriteEmitter1"
        StartSizeRange=(X=(Min=1.500000,Max=1.500000),Y=(Min=1.500000,Max=1.500000),Z=(Min=1.500000,Max=1.500000))
        Texture=Texture'EmitterTextures.MultiFrame.Flame_effect'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=1.000000,Max=1.000000)
        StartVelocityRange=(Z=(Min=-15.000000,Max=-15.000000))
        TriggerDisabled=false
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter1'
}