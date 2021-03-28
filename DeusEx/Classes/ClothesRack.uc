//=============================================================================
// ClothesRack.
//=============================================================================
class ClothesRack extends HangingDecoration;

enum ESkinColor
{
    SC_Blue,
    SC_Yellow,
    SC_Green,
    SC_Black
};

var() ESkinColor SkinColor;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_Blue:   Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ClothesRackTex1", class'Material', false)); break;
       case SC_Yellow: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ClothesRackTex2", class'Material', false)); break;
       case SC_Green:  Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ClothesRackTex3", class'Material', false)); break;
       case SC_Black:  Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.ClothesRackTex4", class'Material', false)); break;
   }
}


defaultproperties
{
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Hanging Clothes"
     mesh=mesh'DeusExDeco.ClothesRack'
//     PrePivot=(Z=24.750000)
     CollisionRadius=13.000000
     CollisionHeight=24.750000
     Mass=60.000000
     Buoyancy=70.000000
}
