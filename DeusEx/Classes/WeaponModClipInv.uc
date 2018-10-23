//=============================================================================
// WeaponModClip
//
// Increases Clip Capacity
//=============================================================================
class WeaponModClipInv extends WeaponModInv;

// ----------------------------------------------------------------------
// ApplyMod()
// ----------------------------------------------------------------------

function ApplyMod(DeusExWeaponInv weapon)
{
	local int diff;

	if (weapon != None)
	{
		diff = Float(weapon.Default.ReloadCount) * WeaponModifier;

		// make sure we add at least one
		if (diff < 1)
			diff = 1;

		weapon.ReloadCount += diff;
		weapon.ModReloadCount += WeaponModifier;
	}
}

// ----------------------------------------------------------------------
// CanUpgradeWeapon()
// ----------------------------------------------------------------------

function bool CanUpgradeWeapon(DeusExWeaponInv weapon)
{
	if (weapon != None)
		return (weapon.bCanHaveModReloadCount && !weapon.HasMaxClipMod());
	else
		return False;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    WeaponModifier=0.10
    ItemName="Weapon Modification (Clip)"
    Icon=Texture'DeusExUI.Icons.BeltIconWeaponModClip'
    largeIcon=Texture'DeusExUI.Icons.LargeIconWeaponModClip'
    Description="An extended magazine that increases clip capacity beyond the factory default."
    beltDescription="M CLIP"
    Skins(0)=Texture'DeusExItems.Skins.WeaponModTex3'
    PickupViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex3'
    FirstPersonViewSkins(0)=Texture'DeusExItems.Skins.WeaponModTex3'
    pickupClass=class'WeaponModClip'
}
