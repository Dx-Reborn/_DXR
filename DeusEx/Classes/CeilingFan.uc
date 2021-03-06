//=============================================================================
// CeilingFan.
//=============================================================================
class CeilingFan extends DeusExDecoration;

enum ESkinColor
{
    SC_WoodBrass,
    SC_DarkWoodIron,
    SC_White,
    SC_WoodBrassFancy,
    SC_WoodPlastic
};

var() ESkinColor SkinColor;


event BeginPlay()
{
    Super.BeginPlay();
    SetSkin();
}

function SetSkin()
{
   // DXR: ���� �������� ������ �� �� ������ ���� 
   if (DrawType == DT_StaticMesh && StaticMesh != None)
   return;

   switch (SkinColor)
   {
       case SC_WoodBrass:      Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CeilingFanTex1", class'Material', false)); break;
       case SC_DarkWoodIron:   Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CeilingFanTex2", class'Material', false)); break;
       case SC_White:          Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CeilingFanTex3", class'Material', false)); break;
       case SC_WoodBrassFancy: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CeilingFanTex4", class'Material', false)); break;
       case SC_WoodPlastic:    Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.CeilingFanTex5", class'Material', false)); break;
   }
}


defaultproperties
{
    SkinColor=SC_DarkWoodIron
    FragType=Class'DeusEx.WoodFragment'
    bHighlight=False
    bCanBeBase=True
    ItemName="Ceiling Fan Blades"
    bPushable=False
    Physics=PHYS_Rotating
    RemoteRole=ROLE_SimulatedProxy
    mesh=mesh'DeusExDeco.CeilingFan'
    CollisionRadius=45.750000
    CollisionHeight=3.300000
    bCollideWorld=False
    bFixedRotationDir=True
    Mass=50.000000
    Buoyancy=30.000000
    RotationRate=(Yaw=16384)
}
