//=============================================================================
// Pillow.
//=============================================================================
class Pillow extends DeusExDecoration;

// DXR: More variations!
enum ESkinColor
{
    PSC_LightBrown,
    PSC_DarkRed,
    PSC_Bright,
    PSC_Gray,
};
var() ESkinColor SkinColor;
var /*staticMesh*/ string variations[3];

event BeginPlay()
{
   Super.BeginPlay();

   switch (SkinColor)
   {
       case PSC_LightBrown: SetStaticMesh(default.staticMesh);
       break;

       case PSC_DarkRed: SetStaticMesh(StaticMesh(DynamicLoadObject(variations[0], class'StaticMesh', false)));
       break;

       case PSC_Bright: SetStaticMesh(StaticMesh(DynamicLoadObject(variations[1], class'StaticMesh', false)));
       break;

       case PSC_Gray: SetStaticMesh(StaticMesh(DynamicLoadObject(variations[2], class'StaticMesh', false)));
       break;
   }
}


defaultproperties
{
     FragType=Class'DeusEx.PaperFragment'
     ItemName="Pillow"
//     mesh=mesh'DeusExDeco.Pillow'
     CollisionRadius=17.000000
     CollisionHeight=4.130000
     Mass=5.000000
     Buoyancy=6.000000
//     Skins[0]=Texture'DeusExDeco.Skins.PillowTex1'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.Pillows_x4a'
     variations[0]="DeusExStaticMeshes0.Pillows_x4b"
     variations[1]="DeusExStaticMeshes0.Pillows_x4c"
     variations[2]="DeusExStaticMeshes0.Pillows_x4d"
}


