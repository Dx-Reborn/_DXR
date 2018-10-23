//=============================================================================
// HazMatSuit.
//=============================================================================
class HazMatSuitInv extends ChargedPickupInv;

//
// Reduces poison gas, tear gas, and radiation damage
//

defaultproperties
{
    skillNeeded=Class'SkillEnviro'
    LoopSound=Sound'DeusExSounds.Pickup.SuitLoop'
    ChargedIcon=Texture'DeusExUI.Icons.ChargedIconHazMatSuit'
    ExpireMessage="HazMatSuit power supply used up"
    ItemName="Hazmat Suit"
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00),

    FirstPersonViewMesh=Mesh'DeusExItems.HazMatSuit'
    PickupViewMesh=Mesh'DeusExItems.HazMatSuit'
    Mesh=Mesh'DeusExItems.HazMatSuit'

    LandSound=Sound'DeusExSounds.Generic.PaperHit2'
    Icon=Texture'DeusExUI.Icons.BeltIconHazMatSuit'
    largeIcon=Texture'DeusExUI.Icons.LargeIconHazMatSuit'
    largeIconWidth=46
    largeIconHeight=45
    Description="A standard hazardous materials suit that protects against a full range of environmental hazards including radiation, fire, biochemical toxins, electricity, and EMP. Hazmat suits contain an integrated bacterial oxygen scrubber that degrades over time and thus should not be reused."
    beltDescription="HAZMAT"
    Texture=Texture'DeusExItems.Skins.ReflectionMapTex1'
    CollisionRadius=17.00
    CollisionHeight=11.52
    Mass=20.00
    Buoyancy=12.00
}
