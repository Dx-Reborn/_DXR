//=============================================================================
// POVCorpse.
//=============================================================================
class POVCorpse extends DeusExPickup;

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

// From GMDX
var travel Inventory CarcassInv;

//Lork: Unconscious vars
var travel string deadName; 
var travel bool wasFemale;
var travel String flagName;
var travel bool wasImportant;

event SetInitialState()
{
   Super(RuntimePickup).SetInitialState();
}

defaultproperties
{
    MaxDamage=10
    ItemName="body"
    PlayerViewOffset=(X=20,Y=14,Z=-4)
    Mesh=Mesh'DeusExItems.POVCorpse'
    FirstPersonViewMesh=Mesh'DeusExItems.POVCorpse'
    CollisionRadius=1.000000
    CollisionHeight=1.000000
    Mass=40.000000
    Buoyancy=30.000000

    bDisplayableInv=False
    bActivatable=false // Even don't try to activate it ))

    LandSound=Sound'DeusExSounds.Generic.FleshHit1'
}
