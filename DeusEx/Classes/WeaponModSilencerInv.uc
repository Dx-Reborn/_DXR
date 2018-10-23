//=============================================================================
// WeaponModSilencer
//
// Adds a Silencer sight to a weapon
//=============================================================================
class WeaponModSilencerInv extends WeaponModInv;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeaponInv weapon)
{
	if (weapon != None)
		weapon.bHasSilencer = True;
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

function bool CanUpgradeWeapon(DeusExWeaponInv weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveSilencer && !weapon.bHasSilencer);
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    ItemName="Weapon Modification (Silencer)"
    Icon=Texture'DeusExUI.Icons.BeltIconWeaponModSilencer'
    largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModSilencer'
    Description="A silencer will muffle the muzzle crack caused by rapidly expanding gases left in the wake of a bullet leaving the gun barrel.|n|n<UNATCO OPS FILE NOTE SC108-BLUE> Obviously, a silencer is only effective with firearms. -- Sam Carter <END NOTE>"
    beltDescription="SLNCR"
    Skins(0)=Texture'DeusExItems.Skins.WeaponModTex7'
    PickupViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex7'
    FirstPersonViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex7'
    pickupClass=class'WeaponModSilencer'
}
