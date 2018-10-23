//=============================================================================
// AmmoRocketWP.
//=============================================================================
class AmmoRocketWPinv extends AmmoRocketInv;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoWPRockets'
     largeIconWidth=45
     largeIconHeight=37
     Description="The white-phosphorus rocket, or 'wooly peter,' was designed to expand the mission profile of the GEP gun. While it does minimal damage upon detonation, the explosion will spread a cloud of particularized white phosphorus that ignites immediately upon contact with the air."
     beltDescription="WP ROCKET"
     ItemName="WP Rockets"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoWPRockets'
     Skins[0]=Texture'DeusExItems.Skins.GEPAmmoTex2'
	   PickupClass=class'AmmoRocketWP'
}
