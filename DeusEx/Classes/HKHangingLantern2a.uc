//=============================================================================
// HKHangingLantern2.
//=============================================================================
class HKHangingLantern2a extends HangingDecoration;

enum ESkinColor
{
    SC_RedGreen,
    SC_YellowBlue,
    SC_BluePurple
};

var() ESkinColor SkinColor;

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_RedGreen:   Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.HKHangingLantern2Tex1", class'Material', false)); break;
       case SC_YellowBlue: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.HKHangingLantern2Tex2", class'Material', false)); break;
       case SC_BluePurple: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.HKHangingLantern2Tex3", class'Material', false)); break;
   }
}


defaultproperties
{
    FragType=Class'DeusEx.PaperFragment'
    ItemName="Paper Lantern"
    mesh=mesh'DeusExDeco.HKHangingLantern2'
    CollisionRadius=7.000000
    CollisionHeight=11.000000
    Mass=20.000000
    Buoyancy=5.000000
}
