//=============================================================================
// WeaponModLaser
//
// Adds a laser sight to a weapon
//=============================================================================
class WeaponModLaser extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
    if (weapon != None)
        weapon.bHasLaser = True;
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
    if (weapon != None)
        return (weapon.bCanHaveLaser && !weapon.bHasLaser);
    else
        return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    ItemName="Weapon Modification (Laser)"
    Icon=Texture'DeusExUI.Icons.BeltIconWeaponModLaser'
    largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModLaser'
    Description="A laser targeting dot eliminates any inaccuracy resulting from the inability to visually guage a projectile's point of impact."
    beltdescription="LASER"
    Skins(0)=Texture'DeusExItems.Skins.WeaponModTex4'
    PickupViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex4'
    FirstPersonViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex4'
}
