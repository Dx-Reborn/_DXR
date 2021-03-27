//=============================================================================
// FlagPole.
//=============================================================================
class FlagPole extends DeusExDecoration;

enum ESkinColor
{
    SC_China,
    SC_France,
    SC_President,
    SC_UNATCO,
    SC_USA,
    SC_Russia,    // DXR: New flags (Russian, Ukrainian) to use in the future
    SC_Ukraine
};

var() travel ESkinColor SkinColor;
var string flagSkins[7];


event BeginPlay()
{
    Super.BeginPlay();

    SetSkin();
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ToDo: запомнить и считать из DeusExGlobals
// ----------------------------------------------------------------------
event TravelPostAccept()
{
    Super.TravelPostAccept();

    SetSkin();
}

function ResetScaleGlow()
{
    SetSkin();
}

function SetSkin()
{
   switch (SkinColor)
   {
       case SC_China:      Skins[0] = Material(DynamicLoadObject(flagSkins[0], class'Material', false)); break;
       case SC_France:     Skins[0] = Material(DynamicLoadObject(flagSkins[1], class'Material', false)); break;
       case SC_President:  Skins[0] = Material(DynamicLoadObject(flagSkins[2], class'Material', false)); break;
       case SC_UNATCO:     Skins[0] = Material(DynamicLoadObject(flagSkins[3], class'Material', false)); break;
       case SC_USA:        Skins[0] = Material(DynamicLoadObject(flagSkins[4], class'Material', false)); break;
       case SC_Russia:     Skins[0] = Material(DynamicLoadObject(flagSkins[5], class'Material', false)); break;
       case SC_Ukraine:    Skins[0] = Material(DynamicLoadObject(flagSkins[6], class'Material', false)); break;
   }
}


defaultproperties
{
   flagSkins[0]="DeusExStaticMeshes0.Flags.Flag_China_HD"
   flagSkins[1]="DeusExStaticMeshes0.Flags.Flag_France_HD"
   flagSkins[2]="DeusExStaticMeshes0.Flags.Flag_Eagle_HD"
   flagSkins[3]="DeusExStaticMeshes0.Flags.Flag_Unatco_HD"
   flagSkins[4]="DeusExStaticMeshes0.Flags.Flag_USA_HD"
   flagSkins[5]="DeusExStaticMeshes0.Flags.Flag_Russia_HD"
   flagSkins[6]="DeusExStaticMeshes0.Flags.Flag_Ukraine_HD"

   FragType=class'DeusEx.WoodFragment'
   ItemName="Flag Pole"
   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DeusExStaticMeshes0.Flagpole_HD'
   CollisionRadius=17.000000
   CollisionHeight=56.389999
   Mass=40.000000
   Buoyancy=30.000000
}

/*  Original code      case SC_China:      Skins[0] = Texture'FlagPoleTex1'; break;
        case SC_France:     Skins[0] = Texture'FlagPoleTex2'; break;
        case SC_President:  Skins[0] = Texture'FlagPoleTex3'; break;
        case SC_UNATCO:     Skins[0] = Texture'FlagPoleTex4'; break;
        case SC_USA:        Skins[0] = Texture'FlagPoleTex5'; break;
     mesh=mesh'DeusExDeco.FlagPole'
        */
