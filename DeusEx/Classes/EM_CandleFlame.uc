/*
   Пламя свечи
*/
class EM_CandleFlame extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        UseDirectionAs=PTDU_Up
        FadeIn=True
        UseRegularSizeScale=False
        Acceleration=(Z=3.000000)
        ColorScale(0)=(Color=(B=255))
        ColorScale(1)=(RelativeTime=0.300000,Color=(G=128,R=255))
        ColorScale(2)=(RelativeTime=1.000000,Color=(R=255))
        FadeOutStartTime=0.800000
        FadeInEndTime=0.800000
        CoordinateSystem=PTCS_Relative
        MaxParticles=15
        Name="SpriteEmitter2"
        RotationOffset=(Pitch=16201,Yaw=16201,Roll=16201)
        SpinCCWorCW=(X=0.000000)
        SpinsPerSecondRange=(X=(Max=0.049000))
        RotationNormal=(X=180.000000)
        SizeScale(0)=(RelativeSize=0.350000)
        SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
        SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.200000)
        StartSizeRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
        DrawStyle=PTDS_Brighten
        Texture=Texture'DXR_FX.Particles.CandleFlame_c'
        SecondsBeforeInactive=0.000000
        LifetimeRange=(Min=0.901000,Max=0.901000)
    End Object
    Emitters(0)=SpriteEmitter'SpriteEmitter2'

}




