/*

*/

class ScalableRope extends DeusExEmitter
                               placeable;


var() float MaxDist, MaxDistCorrection;
var Actor HitActor;

function SetRopeLength(int Length)
{
      BeamEmitter(Emitters[0]).BeamDistanceRange.Min = Length;
      BeamEmitter(Emitters[0]).BeamDistanceRange.Max = Length;
}

event Tick(float deltaTime)
{
    local vector StartTrace, EndTrace, HitLocation, HitNormal;
    local actor target;
    local int texFlags;
    local name texName, texGroup;

    StartTrace = Location;
    EndTrace = Location + MaxDist * vector(Rotation);
    HitActor = None;

      foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace, StartTrace)
      {
            if ((target.DrawType == DT_None) || target.bHidden)
            {
                // do nothing - keep on tracing
            }
            else if ((target == Level) || target.IsA('Mover') || (target.bWorldGeometry))
            {
                break;
            }
            else
            {
                if (target != none)
                    HitActor = target;
                break;
            }

      }
      SetRopeLength(Abs(vSize(Location - HitLocation)) + MaxDistCorrection);
}


defaultproperties
{
    MaxDist=5000
    MaxDistCorrection=0.0

    Begin Object Class=BeamEmitter Name=BeamEmitter1
        BeamDistanceRange=(Min=512.000000,Max=512.000000)
        DetermineEndPointBy=PTEP_Distance
        BeamTextureUScale=8.000000
        RotatingSheets=3
        LowFrequencyPoints=2
        HighFrequencyPoints=2
        AutomaticInitialSpawning=False
        MaxParticles=1
        UseRotationFrom=PTRS_Actor
        StartSizeRange=(X=(Min=-2.00,Max=2.00),Y=(Min=-2.00,Max=2.00))
        //ScaleSizeByVelocityMax=1000000.000000
        ScaleSizeByVelocityMax=0.000000
        InitialParticlesPerSecond=5000.000000
        Texture=FireTexture'Effects.Laser.LaserBeam1'
        LifetimeRange=(Min=0.020000,Max=0.020000)
        StartVelocityRange=(X=(Min=1.000000,Max=1.000000))
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter1'

    bDirectional=true
}
