//=============================================================================
// CarBurned.
//=============================================================================
class CarBurned extends OutdoorThings;

enum ESkinColor
{
    SC_Yellow,
    SC_DarkBlue
};

var() ESkinColor SkinColor;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_Yellow:     Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CarBurnedTex1", class'Material', false)); break;
       case SC_DarkBlue:   Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CarBurnedTex2", class'Material', false)); break;
   }
}


defaultproperties
{
    bCanBeBase=True
    mesh=mesh'DeusExDeco.CarBurned'
    CollisionRadius=101.650002
    CollisionHeight=29.430000
    Mass=2000.000000
    Buoyancy=1500.000000
}
