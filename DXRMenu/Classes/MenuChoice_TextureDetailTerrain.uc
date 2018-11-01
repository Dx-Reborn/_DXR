//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_TextureDetailTerrain extends MenuChoice_LowMedHigh;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Texture detail for terrain"
    actionText="Terrain Texture Details"
    configSetting="ini:Engine.Engine.ViewportManager TextureDetailTerrain"
}
