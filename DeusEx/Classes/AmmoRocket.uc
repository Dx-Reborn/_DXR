//=============================================================================
// AmmoRocket.
//=============================================================================
class AmmoRocket extends DeusExAmmo;

defaultproperties
{
     largeIcon=Texture'DeusExUI.Icons.LargeIconAmmoRockets'
     largeIconWidth=46
     largeIconHeight=36
     Description="A gyroscopically stabilized rocket with limited onboard guidance systems for in-flight course corrections. Engineered for use with the GEP gun."
     beltDescription="ROCKET"
     bShowInfo=True
     AmmoAmount=4
     MaxAmmo=20
     ItemName="Rockets"
     Icon=Texture'DeusExUI.Icons.BeltIconAmmoRockets'
     Mesh=Mesh'DeusExItems.GEPAmmo'
     CollisionRadius=18.000000
     CollisionHeight=7.800000
     bCollideActors=True
     LandSound=Sound'DeusExSounds.Generic.WoodHit2'
}
