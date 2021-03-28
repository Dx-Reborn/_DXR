//=============================================================================
// CouchLeather.
//=============================================================================
class CouchLeather extends Seat;

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
       case SC_Black:      Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CouchLeatherTex1", class'Material', false)); break;
       case SC_Blue:       Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CouchLeatherTex2", class'Material', false)); break;
       case SC_Brown:      Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CouchLeatherTex3", class'Material', false)); break;
       case SC_LitGray:    Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CouchLeatherTex4", class'Material', false)); break;
       case SC_Tan:        Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CouchLeatherTex5", class'Material', false)); break;
   }
}


defaultproperties
{
     sitPoint(0)=(X=-18.000000,Y=-8.000000,Z=0.000000)
     sitPoint(1)=(X=18.000000,Y=-8.000000,Z=0.000000)
     ItemName="Leather Couch"
     mesh=mesh'DeusExDeco.CouchLeather'
     CollisionRadius=47.880001
     CollisionHeight=23.250000
     Mass=100.000000
     Buoyancy=110.000000
     Skins[0]=Texture'CouchLeatherTex1'
}
