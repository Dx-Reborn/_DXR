//
// Огонь для огнемета
//

class EM_FlameThrower extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter0
        UseColorScale=True
        FadeOut=True
        FadeIn=True
        SpinParticles=True
        UseSizeScale=True
        UseRegularSizeScale=False
        UniformSize=True
        ResetOnTrigger=True
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(G=128,R=255,A=255))
        FadeOutStartTime=0.542700
        FadeInEndTime=0.070350
        MaxParticles=100
        Name="flameStart"
        UseRotationFrom=PTRS_Actor
        StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
        SizeScale(0)=(RelativeTime=0.240000,RelativeSize=1.500000)
        SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
        SizeScaleRepeats=0.100000
        StartSizeRange=(X=(Min=14.000000,Max=14.000000),Y=(Min=14.000000,Max=14.000000),Z=(Min=14.000000,Max=14.000000))
        Texture=Texture'Effects_EX.Fire.FX_Muzzle_a'
        SecondsBeforeInactive=0.100000
        LifetimeRange=(Min=1.005000,Max=1.005000)
        StartVelocityRange=(X=(Min=750.000000,Max=750.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-30.000000,Max=30.000000))
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter0'

    DrawScale=0.200000
    bDirectional=True
}