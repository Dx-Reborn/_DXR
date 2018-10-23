/*------------------------------------------------------------------------------
  Parent class for Weapon Mods.
  A note about weapon changing: now inventory and pickup are different actors,
  so properties should be copied from Inventory to Pickup when Inventory
  actor was thrown by player or somehow removed and placed in other place.
------------------------------------------------------------------------------*/

class WeaponModInv extends DeusExPickupInv
                           abstract;

var() Float WeaponModifier;
var localized String DragToUpgrade;


// ----------------------------------------------------------------------
// Applies the modification to the weapon.  Unique for each different 
// type of weapon mod class
// ----------------------------------------------------------------------
function ApplyMod(DeusExWeaponInv weapon);
function bool CanUpgradeWeapon(DeusExWeaponInv weapon);

// ----------------------------------------------------------------------
// UpdateInfo()
//
// Describes the capabilities of this weapon mod,
// for instance, "Increases base accuracy by 20%"
// ----------------------------------------------------------------------
function bool UpdateInfo(GUIScrollTextBox winInfo)
{
	if (winInfo == None)
		return False;

	winInfo.SetContent("");
//	winInfo.SetTitle(itemName);
	winInfo.SetContent(Description $ "||");
	winInfo.AddText(DragToUpgrade);

	return True;
}


defaultproperties
{
    DragToUpgrade="Drag over weapon to upgrade.  Weapons highlighted in GREEN can be upgraded with this mod."
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
    largeIconWidth=34
    largeIconHeight=49

    Mesh=Mesh'DeusExItems.WeaponMod'
    PickupViewMesh=Mesh'DeusExItems.WeaponMod'
    FirstPersonViewMesh=Mesh'DeusExItems.WeaponMod'

		PlayerViewPivot=(Pitch=0,Roll=0,Yaw=0)

    CollisionRadius=3.50
    CollisionHeight=4.42
    Mass=1.00
    bCanHaveMultipleCopies=false
    bActivatable=false
}