/*------------------------------------------------------------------------------
  Parent class for Weapon Mods.
------------------------------------------------------------------------------*/

class WeaponMod extends DeusExPickup
                        abstract;

var() Float WeaponModifier;
var localized String DragToUpgrade;


// ----------------------------------------------------------------------
// Applies the modification to the weapon.  Unique for each different 
// type of weapon mod class
// ----------------------------------------------------------------------
function ApplyMod(DeusExWeapon weapon);
function bool CanUpgradeWeapon(DeusExWeapon weapon);

// ----------------------------------------------------------------------
// UpdateInfo()
//
// Describes the capabilities of this weapon mod,
// for instance, "Increases base accuracy by 20%"
// ----------------------------------------------------------------------
function bool UpdateInfo(Object winInfo)
{
    if (winInfo == None)
        return False;

    GUIScrollTextBox(winInfo).SetContent("");
//  winInfo.SetTitle(itemName);
    GUIScrollTextBox(winInfo).SetContent(Description $ "||");
    GUIScrollTextBox(winInfo).AddText(DragToUpgrade);

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