//=============================================================================
// BioelectricCellInv.
//=============================================================================
class BioelectricCellInv extends DeusExPickupInv;

var int rechargeAmount;

var localized String msgRecharged;
var localized String RechargesLabel;

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
		{
			player.ClientMessage(Sprintf(msgRecharged, rechargeAmount));
	
			PlaySound(sound'BioElectricHiss', SLOT_None,,, 256);

			player.Energy += rechargeAmount;
			if (player.Energy > player.EnergyMax)
				player.Energy = player.EnergyMax;
		}

		UseOnce();
	}
Begin:
}

function bool UpdateInfo(GUIScrollTextBox winInfo)
{
	local string str;

	if (winInfo == None)
		return false;

//	winInfo.SetTitle(itemName);
  winInfo.SetContent("");
	winInfo.SetContent(Description $ "||");
	winInfo.AddText(Sprintf(RechargesLabel, RechargeAmount));

	// Print the number of copies
	str = CountLabel @ String(NumCopies);
	winInfo.AddText("||" $ str);

	return true;
}




defaultproperties
{
    PickupClass=class'BioelectricCell'
    maxCopies=30
    bCanHaveMultipleCopies=true
    rechargeAmount=25
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    Icon=Texture'DeusExUI.Icons.BeltIconBioCell'
    largeIcon=Texture'DeusExUI.Icons.LargeIconBioCell'
    largeIconWidth=44
    largeIconHeight=43
    msgRecharged="Recharged %d points"
    RechargesLabel="Recharges %d Energy Units"
    Description="A bioelectric cell provides efficient storage of energy in a form that can be utilized by a number of different devices.||<UNATCO OPS FILE NOTE JR289-VIOLET> Augmented agents have been equipped with an interface that allows them to transparently absorb energy from bioelectric cells. -- Jaime Reyes <END NOTE>"
    ItemName="Bioelectric Cell"
    beltDescription="BIOCELL"

    Mesh=Mesh'DeusExItems.BioCell'
    PickupViewMesh=Mesh'DeusExItems.BioCell'
    FirstPersonViewMesh=Mesh'DeusExItems.BioCell'

    CollisionRadius=4.700000
    CollisionHeight=0.930000
    Mass=5.000000
    Buoyancy=4.000000
}