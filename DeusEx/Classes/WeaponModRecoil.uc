//=============================================================================
// WeaponModRecoil
//
// Decreases recoil amount
//=============================================================================
class WeaponModRecoil extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
    if (weapon != None)
    {
        weapon.recoilStrength    += (weapon.Default.recoilStrength * WeaponModifier);
        if (weapon.recoilStrength < 0.0)
            weapon.recoilStrength = 0.0;
        weapon.ModRecoilStrength += WeaponModifier;
    }
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
    if (weapon != None)
        return (weapon.bCanHaveModRecoilStrength && !weapon.HasMaxRecoilMod());
    else
        return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    WeaponModifier=-0.10
    ItemName="Weapon Modification (Recoil)"
    Icon=Texture'DeusExUI.Icons.BeltIconWeaponModRecoil'
    largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModRecoil'
    Description="A stock cushioned with polycellular shock absorbing material will significantly reduce perceived recoil."
    beltDescription="RECOIL"
    Skins(0)=Texture'DeusExItems.Skins.WeaponModTex5'
    PickupViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex5'
    FirstPersonViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex5'
}
