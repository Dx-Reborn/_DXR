class EM_ShellTrail extends DeusExEmitter;

event SetInitialState()
{
   SetTimer(2.0 + FRand(), false);
}

event Timer()
{
   Kill();
}


defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter70
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        Acceleration=(Z=40.000000)
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
        FadeOutStartTime=0.220000
        MaxParticles=40
        Name="SpriteEmitter70"
        SpinsPerSecondRange=(X=(Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        DrawStyle=PTDS_AlphaBlend
        Texture=Texture'DXR_FX.Effects.pfx_smoke_02'
        TextureUSubdivisions=4
        TextureVSubdivisions=4
        LifetimeRange=(Min=0.50,Max=1.00)
        StartVelocityRange=(Z=(Max=10.000000)) //20
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter70'
}