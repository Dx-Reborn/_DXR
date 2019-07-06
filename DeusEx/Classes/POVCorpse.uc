//=============================================================================
// POVCorpse.
//=============================================================================
class POVCorpse extends DeusExPickupInv;

var travel String carcClassString;
var travel String KillerBindName;
var travel Name   KillerAlliance;
var travel Name   Alliance;
var travel bool   bNotDead;
var travel bool   bEmitCarcass;
var travel int    CumulativeDamage;
var travel int    MaxDamage;
var travel string CorpseItemName;
var travel Name   CarcassName;
var travel Inventory CarcassInv;

defaultproperties
{
    ItemName="body"
    PlayerViewOffset=(X=20,Y=14,Z=-4)
    Mesh=Mesh'DeusExItems.POVCorpse'
    FirstPersonViewMesh=Mesh'DeusExItems.POVCorpse'
    CollisionRadius=1.000000
    CollisionHeight=1.000000
    Mass=40.000000
    Buoyancy=30.000000
    PickupClass=class'DummyCorpsePickup'
    bActivatable=false // Even don't try to activate it ))
    LandSound=Sound'DeusExSounds.Generic.FleshHit1'
}
