//=============================================================================
// ChairLeather.
//=============================================================================
class ChairLeather extends Seat;

enum ESkinColor
{
    SC_Black,
    SC_Blue,
    SC_Brown,
    SC_LitGray,
    SC_Tan
};

var() ESkinColor SkinColor;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_Black:      Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ChairLeatherTex1", class'Material', false)); break;
       case SC_Blue:       Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ChairLeatherTex2", class'Material', false)); break;
       case SC_Brown:      Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ChairLeatherTex3", class'Material', false)); break;
       case SC_LitGray:    Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ChairLeatherTex4", class'Material', false)); break;
       case SC_Tan:        Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ChairLeatherTex5", class'Material', false)); break;
   }
}


defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-8.000000,Z=0.000000)
     ItemName="Comfy Chair"
     mesh=mesh'DeusExDeco.ChairLeather'
     CollisionRadius=33.500000
     CollisionHeight=23.250000
     Mass=100.000000
     Buoyancy=110.000000
}
