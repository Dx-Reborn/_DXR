//=============================================================================
// WeaponModScope
//
// Adds a scope sight to a weapon
//=============================================================================
class WeaponModScope extends WeaponMod;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeapon weapon)
{
    if (weapon != None)
        weapon.bHasScope = True;
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

function bool CanUpgradeWeapon(DeusExWeapon weapon)
{
    if (weapon != None)
        return (weapon.bCanHaveScope && !weapon.bHasScope);
    else
        return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    ItemName="Weapon Modification (Scope)"
    Icon=Texture'DeusExUI.Icons.BeltIconWeaponModScope'
    largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModScope'
    Description="A telescopic scope attachment provides zoom capability and increases accuracy against distant targets."
    beltDescription="M SCOPE"
    Skins(0)=Texture'DeusExItems.Skins.WeaponModTex8'
    PickupViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex8'
    FirstPersonViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex8'
}
