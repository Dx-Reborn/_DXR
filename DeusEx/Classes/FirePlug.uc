//=============================================================================
// FirePlug.
//=============================================================================
class FirePlug extends OutdoorThings;

enum ESkinColor
{
    SC_Red,
    SC_Orange,
    SC_Blue,
    SC_Gray
};

var() ESkinColor SkinColor;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_Red:    Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.FirePlugTex1", class'Material', false)); break;
       case SC_Orange: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.FirePlugTex2", class'Material', false)); break;
       case SC_Blue:   Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.FirePlugTex3", class'Material', false)); break;
       case SC_Gray:   Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.FirePlugTex4", class'Material', false)); break;
   }
}


defaultproperties
{
   mesh=mesh'DeusExDeco.FirePlug'
   CollisionRadius=8.000000
   CollisionHeight=16.500000
   Mass=50.000000
   Buoyancy=30.000000
   SurfaceType=EST_Metal
}
