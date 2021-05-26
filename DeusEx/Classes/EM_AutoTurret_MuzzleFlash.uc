class EM_AutoTurret_MuzzleFlash extends DeusExEmitter;


defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter56
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=2.000000)
        StartLocationRange=(X=(Max=2.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=2.000000,Max=2.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=10.000000,Max=30.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter56'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter57
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.750000
        FadeOutStartTime=0.080000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=2.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.500000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=10.000000,Max=30.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter57'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter58
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.600000
        FadeOutStartTime=0.094000
        FadeInEndTime=0.092000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=17.000000)
        StartLocationRange=(X=(Max=5.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=0.500000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
        InitialDelayRange=(Min=0.050000,Max=0.050000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter58'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter59
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.750000
        FadeOutStartTime=0.040000
        FadeInEndTime=0.040000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=7.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000)
        StartSizeRange=(X=(Min=10.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.MP3rdPmuzzle_smoke1frame'
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter59'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter60
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.120000
        CoordinateSystem=PTCS_Relative
        MaxParticles=3
        StartLocationOffset=(X=7.000000)
        StartLocationRange=(X=(Max=2.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.500000,Max=1.500000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=10.000000,Max=30.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter60'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter61
        UniformSize=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.200000
        MaxParticles=1
        Name="SpriteEmitter61"
        StartSizeRange=(X=(Min=50.000000,Max=50.000000))
        Texture=Texture'DXR_FX.Particles.glowfinal'
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter61'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter62
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.200000
        MaxParticles=64
        StartLocationOffset=(X=5.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=1.200000,Max=1.200000)
        StartVelocityRange=(X=(Max=40.000000),Z=(Min=10.000000,Max=20.000000))
        VelocityLossRange=(X=(Max=2.000000))
    End Object
    Emitters(6)=SpriteEmitter'SpriteEmitter62'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter63
        UseColorScale=True
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        UseRandomSubdivision=True
        UseVelocityScale=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.200000
        MaxParticles=64
        StartLocationOffset=(X=5.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Max=1.000000))
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=25.000000,Max=50.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=1.500000,Max=3.000000)
        StartVelocityRange=(X=(Min=50.000000,Max=75.000000))
        VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
        VelocityScale(1)=(RelativeTime=0.500000,RelativeVelocity=(X=0.200000,Y=0.200000,Z=0.200000))
        VelocityScale(2)=(RelativeTime=1.000000)
    End Object
    Emitters(7)=SpriteEmitter'SpriteEmitter63'

/* // Alt. version
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        StartLocationOffset=(X=2.000000)
        StartLocationRange=(X=(Max=2.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.518000,Max=0.518000),Y=(Min=-0.518400,Max=0.518400),Z=(Min=-0.518400,Max=0.518400))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=4.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=2.000000)
        StartSizeRange=(X=(Min=2.000000,Max=2.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.192901,Max=0.192901)
        StartVelocityRange=(X=(Min=10.368001,Max=31.104004))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter4
        FadeOut=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        FadeOutStartTime=0.120000
        CoordinateSystem=PTCS_Relative
        MaxParticles=1
        StartLocationOffset=(X=7.000000)
        StartLocationRange=(X=(Max=2.000000))
        UseRotationFrom=PTRS_Normal
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=3.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=1.000000)
        StartSizeRange=(X=(Min=1.500000,Max=1.500000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.muzzle_4frame3rd'
        TextureUSubdivisions=2
        TextureVSubdivisions=2
        SubdivisionScale(0)=0.500000
        LifetimeRange=(Min=0.200000,Max=0.200000)
        StartVelocityRange=(X=(Min=10.000000,Max=30.000000))
    End Object
    Emitters(1)=SpriteEmitter'SpriteEmitter4'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter5
        UniformSize=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.200000
        MaxParticles=1
        StartSizeRange=(X=(Min=31.500000,Max=31.500000),Y=(Min=63.000000,Max=63.000000),Z=(Min=63.000000,Max=63.000000))
        Texture=Texture'DXR_FX.Particles.glowfinal'
        LifetimeRange=(Min=0.100000,Max=0.100000)
    End Object
    Emitters(2)=SpriteEmitter'SpriteEmitter5'

    Begin Object Class=SpriteEmitter Name=SpriteEmitter6
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        BlendBetweenSubdivisions=True
        UseRandomSubdivision=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        Opacity=0.460000
        MaxParticles=4
        StartLocationOffset=(X=5.000000)
        StartLocationRange=(X=(Max=10.000000))
        UseRotationFrom=PTRS_Actor
        SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
        SizeScale(0)=(RelativeSize=1.000000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.500000)
        StartSizeRange=(X=(Min=5.000000,Max=10.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.MP3rdPmuzzle_smoke1frame'
        LifetimeRange=(Min=1.200000,Max=1.200000)
        StartVelocityRange=(X=(Max=40.000000),Z=(Min=10.000000,Max=20.000000))
        VelocityLossRange=(X=(Max=2.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter6'*/
}





