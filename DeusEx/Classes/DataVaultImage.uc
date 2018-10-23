//=============================================================================
// DataVaultImage
//=============================================================================
class DataVaultImage extends DeusExPickup
	abstract;

// ----------------------------------------------------------------------
function AnnouncePickup(Pawn Receiver);
// ----------------------------------------------------------------------
defaultproperties
{
    Mesh=Mesh'DeusExItems.TestBox'
    CollisionRadius=15.00
    CollisionHeight=15.00
    bCollideActors=true//False
    Mass=10.00
    Buoyancy=11.00
}
