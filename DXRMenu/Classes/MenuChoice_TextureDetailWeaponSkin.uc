//=============================================================================
// MenuChoice_Use3DSound
//=============================================================================

class MenuChoice_TextureDetailWeaponSkin extends MenuChoice_LowMedHigh;

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    defaultValue=1
    Hint="Texture detail for weapons and other inventory items."
    actionText="Weapon and items texture details"
    configSetting="ini:Engine.Engine.ViewportManager TextureDetailWeaponSkin"
}
