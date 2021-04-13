//=============================================================================
// CoffeeTable.
//=============================================================================
class CoffeeTable extends Furniture;

enum ESkinColor
{
    SC_WhiteMarble,
    SC_BlackMarble,
    SC_GrayMarble
};
var() ESkinColor SkinColor;
var string SkinColors[3];

function ResetScaleGlow();

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case SC_WhiteMarble: Skins[0] = Material(DynamicLoadObject(SkinColors[0], class'Material', false)); break; //Texture'CoffeeTableTex1'
       case SC_BlackMarble: Skins[0] = Material(DynamicLoadObject(SkinColors[1], class'Material', false)); break; //Texture'CoffeeTableTex2'
       case SC_GrayMarble:  Skins[0] = Material(DynamicLoadObject(SkinColors[2], class'Material', false)); break; //Texture'CoffeeTableTex3'
   }
}

defaultproperties
{
     SkinColors[0]="DeusExStaticMeshes0.Wood.CoffeeTable_HD_Tex1"
     SkinColors[1]="DeusExStaticMeshes0.Wood.CoffeeTable_SH1"
     SkinColors[2]="DeusExStaticMeshes0.Wood.CoffeeTable_HD_Tex3"
     bCanBeBase=true
     ItemName="Coffee Table"
     //mesh=mesh'DeusExDeco.CoffeeTable'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.CoffeeTable_HD'
     CollisionRadius=34.750000
     CollisionHeight=13.680000
     Mass=80.000000
     Buoyancy=25.000000
}
