/*
   AI can see thru this volume, so use it for non-breakable glass.
*/

class GlassVolume extends BlockingVolume;

defaultproperties
{
    bBlockZeroExtentTraces=true
}