//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_TextureDetailInterface extends MenuChoice_LowMedHigh;



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Interface texture detail. Does not affects in-game performance.  Set to low only if you really need this, otherwise set to UltraHigh."
    actionText="Interface Texture Detail"
    configSetting="ini:Engine.Engine.ViewportManager TextureDetailInterface"
}
