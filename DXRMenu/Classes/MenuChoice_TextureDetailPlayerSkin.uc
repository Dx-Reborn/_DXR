//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_TextureDetailPlayerSkin extends MenuChoice_LowMedHigh;


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Texture detail for in-game creatures."
    actionText="NPC and Player Texture Detail"
    configSetting="ini:Engine.Engine.ViewportManager TextureDetailPlayerSkin"
}
