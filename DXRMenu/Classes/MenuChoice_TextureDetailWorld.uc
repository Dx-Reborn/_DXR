//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_TextureDetailWorld extends MenuChoice_LowMedHigh;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="World texture detail, including StaticMeshes"
    actionText="World Texture Details"
    configSetting="ini:Engine.Engine.ViewportManager TextureDetailWorld"
}
