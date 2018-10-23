//=============================================================================
// MedKitInv.
//=============================================================================
class MedKitInv extends DeusExPickupInv;

//
// Healing order is head, torso, legs, then arms (critical -> less critical)
//
var int healAmount;
var bool bNoPrintMustBeUsed;
var localized string MustBeUsedOn;

state Activated
{
	function Activate()
	{
		// can't turn it off
	}

	function BeginState()
	{
		local DeusExPlayer player;
		
		Super.BeginState();

		player = DeusExPlayer(Owner);
		if (player != None)
			player.HealPlayer(healAmount, True);

		UseOnce();
	}
Begin:
}


function NoPrintMustBeUsed()
{
	bNoPrintMustBeUsed = True;
}

function bool UpdateInfo(GUIScrollTextBox winInfo)
{
	local DeusExPlayer player;
	local String outText;

	if (winInfo == None)
		return False;

	player = DeusExPlayer(Owner);

	if (player != None)
	{
	  winInfo.SetContent("");
//		winInfo.SetTitle(itemName);
		winInfo.SetContent(Description $ "||");

		if (!bNoPrintMustBeUsed)
		{
			winInfo.AddText("|" $ MustBeUsedOn $ "|");
		}
		else
		{
			bNoPrintMustBeUsed = false;
		}

		// Print the number of copies
		outText = CountLabel @ String(NumCopies);

		winInfo.AddText("|" $ outText);
	}
	return true;
}


// ----------------------------------------------------------------------
// Arms and legs get healing bonuses
// ----------------------------------------------------------------------
function float GetHealAmount(int bodyPart, optional float pointsToHeal)
{
//	local float amt;
	
	if (pointsToHeal == 0)
		pointsToHeal = healAmount;

	// CNN - just make all body parts equal to avoid confusion
	return pointsToHeal;
/*
	switch (bodyPart)
	{
		case 0:		// head
			amt = pointsToHeal * 2; break;
			break;

		case 1:		// torso
			amt = pointstoHeal;
			break;

		case 2:		// right arm
			amt = pointsToHeal * 1.5; break;

		case 3:		// left arm
			amt = pointsToHeal * 1.5; break;

		case 4:		// right leg
			amt = pointsToHeal * 1.5; break;

		case 5:		// left leg
			amt = pointsToHeal * 1.5; break;

		default:
			amt = pointstoHeal;
	}

	return amt;*/
}




defaultproperties
{
    healAmount=30
    maxCopies=15
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    MustBeUsedOn="Use to heal critical body parts, or use on character screen to direct healing at a certain body part."
    Description="A first-aid kit.||<UNATCO OPS FILE NOTE JR095-VIOLET> The nanomachines of an augmented agent will automatically metabolize the contents of a medkit to efficiently heal damaged areas. An agent with medical training could greatly expedite this process. -- Jaime Reyes <END NOTE>"
    ItemName="Medkit"
    beltDescription="MEDKIT"
    PickupClass=class'MedKit'

    Mesh=Mesh'DeusExItems.MedKit'
    PickupViewMesh=Mesh'DeusExItems.MedKit'
    FirstPersonViewMesh=Mesh'DeusExItems.MedKit'

    Icon=Texture'DeusExUI.Icons.BeltIconMedKit'
    largeIcon=Texture'DeusExUI.Icons.LargeIconMedKit'
    largeIconWidth=39
    largeIconHeight=46
    CollisionRadius=7.500000
    CollisionHeight=1.000000
    Mass=10.000000
    Buoyancy=8.000000
}