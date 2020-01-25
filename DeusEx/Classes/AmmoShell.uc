//=============================================================================
// AmmoShell.
//=============================================================================
class AmmoShell extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoShells'
     largeIconWidth=34
     largeIconHeight=45
     Description="Standard 12 gauge shotgun shell; very effective for close-quarters combat against soft targets, but useless against body armor."
     beltDescription="BUCKSHOT"
     bShowInfo=True
     AmmoAmount=12
     MaxAmmo=96
     ItemName="12 Gauge Buckshot Shells"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoShells'
     Mesh=Mesh'DeusExItems.AmmoShell'
     CollisionRadius=9.300000
     CollisionHeight=10.210000
     bCollideActors=True
}
