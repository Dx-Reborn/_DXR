/*
   DXR: New ready-to-use RadioactiveVolume (causes radioactive damage (5/second)).
*/

class RadioactiveVolume extends PhysicsVolume;


defaultproperties
{
    DamagePerSec=5.000000
    DamageType=class'DeusEx.DM_Radiation'
    bPainCausing=True
    bDistanceFog=True
    DistanceFogColor=(G=255,R=255)
    DistanceFogStart=200.000000
    DistanceFogEnd=2000.000000
}