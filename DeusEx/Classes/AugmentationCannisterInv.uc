//=============================================================================
// AugmentationCannister.
//=============================================================================
class AugmentationCannisterInv extends DeusExPickupInv;

var() travel Name AddAugs[2];

var localized string AugsAvailable;
var localized string MustBeUsedOn;

function RestoreProperties(PlaceableInventory mapinv)
{
  AddAugs[0] = AugmentationCannister(mapinv).AddAugs[0];
  AddAugs[1] = AugmentationCannister(mapinv).AddAugs[1];
}

function Augmentation GetAugmentation(int augIndex)
{
	local Augmentation anAug;
	local DeusExPlayer player;

	// First make sure we have a valid value
	if ((augIndex < 0) || (augIndex > (ArrayCount(AddAugs) - 1)))
		return None;

	if (AddAugs[augIndex] == '')
		return None;

	// Loop through all the augmentation objects and look 
	// for the augName that matches the one stored in 
	// this object

	player = DeusExPlayer(Owner);

	if (player != None)
	{
		anAug = player.AugmentationSystem.FirstAug;
		while(anAug != None)
		{
			if (addAugs[augIndex] == anAug.Class.Name)
				break;

			anAug = anAug.next;
		}
	}

	return anAug;
}

function string AugsStr()
{
 return AddAugs[0] $"|"$ AddAugs[1];
}

function string GetDescription()
{
  return AugsAvailable$"|"$AugsStr()$"|"$Description;
}

function bool UpdateInfo(GUIScrollTextBox winInfo)
{
	local Int canIndex;
	local Augmentation aug;

	if (winInfo == None)
		return false;

	winInfo.SetContent("");
//	winInfo.SetTitle(itemName);
	winInfo.SetContent(Description);

	winInfo.AddText("||" $ AugsAvailable);
	winInfo.AddText("||");

	for(canIndex=0; canIndex<ArrayCount(AddAugs); canIndex++)
	{
		if (AddAugs[canIndex] != '')
		{
			aug = GetAugmentation(canIndex);

			if (aug != None)
				winInfo.AddText(aug.default.AugmentationName $ "|");
		}
	}
	winInfo.AddText("|" $ MustBeUsedOn);

	return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.Icons.BeltIconAugmentationCannister'
     largeIcon=Texture'DeusExUI.Icons.LargeIconAugmentationCannister'
     largeIconWidth=19
     largeIconHeight=49
     PickupClass=class'AugmentationCannister'
     PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
     AugsAvailable="Can Add:"
     MustBeUsedOn="Can only be installed with the help of a MedBot."
     Description="An augmentation canister teems with nanoscale mecanocarbon ROM modules suspended in a carrier serum. When injected into a compatible host subject, these modules augment an individual with extra-sapient abilities. However, proper programming of augmentations must be conducted by a medical robot, otherwise terminal damage may occur. For more information, please see 'Face of the New Man' by Kelley Chance."
     beltDescription="AUG CAN"
     ItemName="Augmentation Canister"

     Mesh=Mesh'DeusExItems.AugmentationCannister'
     PickupViewMesh=Mesh'DeusExItems.AugmentationCannister'
     FirstPersonViewMesh=Mesh'DeusExItems.AugmentationCannister'

     CollisionRadius=4.310000
     CollisionHeight=10.240000
     Mass=10.000000
     Buoyancy=12.000000
     bCanHaveMultipleCopies=false
     maxCopies=1
}
