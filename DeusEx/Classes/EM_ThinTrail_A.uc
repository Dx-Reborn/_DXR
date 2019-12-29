class EM_ThinTrail_A extends DeusExEmitter;


defaultproperties
{
    Begin Object Class=TrailEmitter Name=TrailEmitter0
        Opacity=0.97
        TrailLocation=PTTL_FollowEmitter
        MaxPointsPerTrail=200
        DistanceThreshold=50.0
        UseCrossedSheets=true
        PointLifeTime=1
        MaxParticles=1
        StartSizeRange=(X=(Min=10.0,Max=10.0))
        InitialParticlesPerSecond=2000.000000
        AutomaticInitialSpawning=false
        SecondsBeforeInactive=0.0
        Texture=Texture'Effects.Smoke.Smokepuff'
        LifetimeRange=(Min=999999,Max=999999)
        TrailShadeType=PTTST_Linear
        Name="TrailEmitter0"
    End Object
    Emitters(0)=TrailEmitter'TrailEmitter0'
}