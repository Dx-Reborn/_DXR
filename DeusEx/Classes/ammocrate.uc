//=============================================================================
// AmmoCrate
//=============================================================================
class AmmoCrate extends Containers;

var localized String AmmoReceived;

// ----------------------------------------------------------------------
// Frob()
//
// If we are frobbed, trigger our event
// ----------------------------------------------------------------------

defaultproperties
{
     AmmoReceived="Ammo restocked"
     bBlockSight=True
     HitPoints=4000
     bFlammable=False
     ItemName="Ammo Crate"
     bPushable=False
     bAlwaysRelevant=True
     Mesh=Mesh'DeusExItems.DXMPAmmobox'
     CollisionRadius=22.500000
     CollisionHeight=16.000000
     Mass=3000.000000
     Buoyancy=40.000000
}
