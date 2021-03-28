//=============================================================================
// OfficeChair.
//=============================================================================
class OfficeChair extends Seat;

enum ESkinColor
{
    SC_GrayLeather,
    SC_BrownLeather,
    SC_BrownCloth,
    SC_GrayCloth
};

var() ESkinColor SkinColor;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_GrayLeather:    Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.OfficeChairTex1", class'Material', false)); break;
       case SC_BrownLeather:   Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.OfficeChairTex2", class'Material', false)); break;
       case SC_BrownCloth:     Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.OfficeChairTex3", class'Material', false)); break;
       case SC_GrayCloth:      Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.OfficeChairTex4", class'Material', false)); break;
   }
}


defaultproperties
{
     sitPoint(0)=(X=0.000000,Y=-4.000000,Z=0.000000)
     ItemName="Swivel Chair"
     mesh=mesh'DeusExDeco.OfficeChair'
     CollisionRadius=16.000000
     CollisionHeight=25.549999
     Mass=30.000000
     Buoyancy=5.000000
}
