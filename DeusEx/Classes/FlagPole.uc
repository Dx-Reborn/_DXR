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

// ----------------------------------------------------------------------
// BeginPlay()
// ----------------------------------------------------------------------

event BeginPlay()
{
    Super.BeginPlay();

    SetSkin();
}

// ----------------------------------------------------------------------
// TravelPostAccept()
// ToDo: запомнить и считать из DeusExGlobals
// ----------------------------------------------------------------------
function TravelPostAccept()
{
    Super.TravelPostAccept();

    SetSkin();
}

// ----------------------------------------------------------------------
// SetSkin()
// ----------------------------------------------------------------------

function SetSkin()
{
    switch (SkinColor)
    {
        case SC_China:      Skins[0] = Shader'DeusExStaticMeshes0.Flags.Flag_China_HD'; break;
        case SC_France:     Skins[0] = Shader'DeusExStaticMeshes0.Flags.Flag_France_HD'; break;
        case SC_President:  Skins[0] = Shader'DeusExStaticMeshes0.Flags.Flag_Eagle_HD'; break;
        case SC_UNATCO:     Skins[0] = Shader'DeusExStaticMeshes0.Flags.Flag_Unatco_HD'; break;
        case SC_USA:        Skins[0] = Shader'DeusExStaticMeshes0.Flags.Flag_USA_HD'; break;
        case SC_Russia:     Skins[0] = Shader'DeusExStaticMeshes0.Flags.Flag_Russia_HD'; break;
        case SC_Ukraine:    Skins[0] = Shader'DeusExStaticMeshes0.Flags.Flag_Ukraine_HD'; break;
    }
}


defaultproperties
{
     FragType=Class'DeusEx.WoodFragment'
     ItemName="Flag Pole"
//     mesh=mesh'DeusExDeco.FlagPole'
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
        */
