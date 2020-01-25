//=============================================================================
// AugmentationUpgradeCannister.
//
// Allows the player to upgrade any augmentation
//=============================================================================
class AugmentationUpgradeCannister extends DeusExPickup;

var localized string MustBeUsedOn;

function bool UpdateInfo(Object winInfo)
{
    if (winInfo == None)
        return false;

    GUIScrollTextBox(winInfo).SetContent("");
//  winInfo.SetTitle(itemName);
    GUIScrollTextBox(winInfo).AddText(Description $ "||" $ MustBeUsedOn);

    return true;
}


defaultproperties
{
     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'
     MustBeUsedOn="Must be used on Augmentations Screen."
     Description="An augmentation upgrade canister contains highly specific nanomechanisms that, when combined with a previously programmed module, can increase the efficiency of an installed augmentation. Because no programming is required, upgrade canisters may be used by trained agents in the field with minimal risk."
     ItemName="Augmentation Upgrade Canister"
     beltDescription="AUG UPG"
     PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
     Icon=Texture'DeusExUI.Icons.BeltIconAugmentationUpgrade'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAugmentationUpgrade'
     largeIconWidth=24
     largeIconHeight=41

     Mesh=Mesh'DeusExItems.AugmentationUpgradeCannister'
     PickupViewMesh=Mesh'DeusExItems.AugmentationUpgradeCannister'
     FirstPersonViewMesh=Mesh'DeusExItems.AugmentationUpgradeCannister'

     CollisionRadius=3.200000
     CollisionHeight=5.180000
     Mass=10.000000
     Buoyancy=12.000000
}
