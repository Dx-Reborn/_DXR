//=============================================================================
// AmmoBattery.
//=============================================================================
class AmmoBatteryInv extends DeusExAmmoInv;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoProd'
     largeIconWidth=17
     largeIconHeight=46
     Description="A portable charging unit for the riot prod."
     beltDescription="CHARGER"
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=40
     ItemName="Prod Charger"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoProd'
     Mesh=Mesh'DeusExItems.AmmoProd'
     CollisionRadius=2.100000
     CollisionHeight=5.600000
     bCollideActors=True
     PickupClass=class'AmmoBattery'
     LandSound=Sound'DeusExSounds.Generic.PlasticHit2'
}
