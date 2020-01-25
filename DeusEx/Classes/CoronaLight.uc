/*
   Regular light source, with bCorona and corona texture set by default.
   It uses own group by default, so after saving a map, it can disappear.
   Open a Group Browser, and unhide "CoronaLight" group.
*/

class CoronaLight extends light;

defaultproperties
{
    LightBrightness=1.000000
    LightRadius=128.000000
    bCorona=True
    Group="CoronaLight"
    DrawScale=0.500000
    Skins(0)=Texture'Effects.Corona.Corona_A'
}

