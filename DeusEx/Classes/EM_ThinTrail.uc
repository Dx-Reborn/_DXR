class EM_ThinTrail extends DeusExEmitter;

defaultproperties
{
    Begin Object Class=TrailEmitter Name=TrailEmitter0
        TrailShadeType=PTTST_PointLife
        TrailLocation=PTTL_FollowEmitter
        MaxPointsPerTrail=150
        DistanceThreshold=5.000000
        PointLifeTime=1.000000
        FadeOut=True
        FadeIn=True
        FadeOutStartTime=2.000000
        FadeInEndTime=2.000000
        Name="TrailEmitter0"
        StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
        Texture=Texture'Effects.Smoke.Smokepuff'
        LifetimeRange=(Min=2.000000)
    End Object
    Emitters(0)=TrailEmitter'TrailEmitter0'
}