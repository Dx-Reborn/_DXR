//=============================================================================
// Credits.
//=============================================================================
class CreditsInv extends DeusExPickupInv;

var() int numCredits;
var localized String msgCreditsAdded;

// ----------------------------------------------------------------------
// Frob()
//
// Add these credits to the player's credits count
// ----------------------------------------------------------------------
auto state Pickup
{
	function Frob(Actor Frobber, Inventory frobWith)
	{
		local DeusExPlayer player;
		player = DeusExPlayer(Frobber);
		if (player != None)
		{
			player.Credits += numCredits;
			player.ClientMessage(Sprintf(msgCreditsAdded, numCredits));
			player.FrobTarget = None;
			Destroy();
		}
	}
}


defaultproperties
{
     numCredits=100
     msgCreditsAdded="%d credits added"
     ItemName="Credit Chit"

     Mesh=Mesh'DeusExItems.Credits'
     PickupViewMesh=Mesh'DeusExItems.Credits'
     FirstPersonViewMesh=Mesh'DeusExItems.Credits'

     LandSound=Sound'DeusExSounds.Generic.PlasticHit1'

     CollisionRadius=7.000000
     CollisionHeight=0.550000
     Mass=2.000000
     Buoyancy=3.000000
}
