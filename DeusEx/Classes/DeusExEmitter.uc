/*
   Base class for emitters, from BallisticWeapons mod.

   -Static function, ScaleEmitter() scales an entire emitter (very handy!)
 
   by Nolan "Dark Carnivour" Richert.
   Copyright(c) 2006 RuneStorm. All Rights Reserved.
*/

class DeusExEmitter extends Emitter abstract;

// Returns a nice neat RangeVector made of two input vectors, Min and Max.
static function RangeVector VtoRV(Vector Max, Vector Min)
{
    local RangeVector RV;
    RV.X.Max = Max.X; RV.X.Min = Min.X; RV.Y.Max = Max.Y; RV.Y.Min = Min.Y; RV.Z.Max = Max.Z; RV.Z.Min = Min.Z;
    return RV;
}
// Scales a RangeVector
static function ScaleRV(out RangeVector RV, float Scale)
{
    RV.X.Max*=Scale;    RV.Y.Max*=Scale;    RV.Z.Max*=Scale;
    RV.X.Min*=Scale;    RV.Y.Min*=Scale;    RV.Z.Min*=Scale;
}

// Scales the parameters of an emitter to resize it
static function ScaleEmitter(Emitter TheOne, float Scale)
{
    local int i, j;

    for (i=0;i<TheOne.Emitters.Length;i++)
    {
        ScaleRV (TheOne.Emitters[i].StartVelocityRange, Scale);
        TheOne.Emitters[i].SphereRadiusRange.Min*=Scale; TheOne.Emitters[i].SphereRadiusRange.Max*=Scale;
        TheOne.Emitters[i].StartVelocityRadialRange.Min*=Scale; TheOne.Emitters[i].StartVelocityRadialRange.Max*=Scale;
        TheOne.Emitters[i].MaxAbsVelocity *= Scale;
        ScaleRV (TheOne.Emitters[i].StartSizeRange, Scale);
        TheOne.Emitters[i].Acceleration *= Scale;
        ScaleRV (TheOne.Emitters[i].StartLocationRange, Scale);
        TheOne.Emitters[i].StartLocationOffset *= Scale;
        ScaleRV (TheOne.Emitters[i].MeshScaleRange, Scale);
        ScaleRV (TheOne.Emitters[i].VelocityScaleRange, Scale);
        ScaleRV (TheOne.Emitters[i].VelocityLossRange, Scale);
        if (BeamEmitter(TheOne.Emitters[i]) != None)
        {
            for (j=0;j<BeamEmitter(TheOne.Emitters[i]).BeamEndPoints.length;j++)
                ScaleRV (BeamEmitter(TheOne.Emitters[i]).BeamEndPoints[j].Offset, Scale);
            ScaleRV (BeamEmitter(TheOne.Emitters[i]).LowFrequencyNoiseRange, Scale);
            ScaleRV (BeamEmitter(TheOne.Emitters[i]).HighFrequencyNoiseRange, Scale);
            ScaleRV (BeamEmitter(TheOne.Emitters[i]).DynamicHFNoiseRange, Scale);
            BeamEmitter(TheOne.Emitters[i]).BeamDistanceRange.Max *= Scale; BeamEmitter(TheOne.Emitters[i]).BeamDistanceRange.Min *= Scale;
        }
    }
}


// Make the emitter stop producing particles
static function Pause(Emitter TheOne)
{
    local int i;

    TheOne.AutoDestroy = false;
    for (i=0; i<TheOne.Emitters.Length; i++)
    {
        TheOne.Emitters[i].AutoDestroy = false;
        TheOne.Emitters[i].AutomaticInitialSpawning = false;
        TheOne.Emitters[i].RespawnDeadParticles = false;
        TheOne.Emitters[i].InitialParticlesPerSecond = 0;
        TheOne.Emitters[i].ParticlesPerSecond = 0;
        TheOne.Emitters[i].TriggerDisabled=true;
    }
}

// Make the emitter start producing particles again
static function Resume(Emitter TheOne)
{
    local int i;

    for (i=0; i<TheOne.Emitters.Length; i++)
    {
        TheOne.Emitters[i].AutomaticInitialSpawning = TheOne.Emitters[i].default.AutomaticInitialSpawning;
        TheOne.Emitters[i].RespawnDeadParticles = TheOne.Emitters[i].default.RespawnDeadParticles;
        TheOne.Emitters[i].InitialParticlesPerSecond = TheOne.Emitters[i].default.InitialParticlesPerSecond;
        TheOne.Emitters[i].ParticlesPerSecond   = TheOne.Emitters[i].default.ParticlesPerSecond;
        TheOne.Emitters[i].TriggerDisabled = TheOne.Emitters[i].default.TriggerDisabled;
    }
}


defaultproperties
{
     bNoDelete=false
     bDirectional=true
     bMovable=true
     bStatic=false
}
