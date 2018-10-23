//=============================================================================
// AdaptiveArmor.
//=============================================================================
class AdaptiveArmorInv extends ChargedPickupInv;

//
// Behaves just like the cloak augmentation
//

defaultproperties
{
    skillNeeded=Class'SkillEnviro'
    LoopSound=Sound'DeusExSounds.Pickup.SuitLoop'
    ChargedIcon=Texture'DeusExUI.Icons.ChargedIconArmorAdaptive'
    ExpireMessage="Thermoptic camo power supply used up"
    ItemName="Thermoptic Camo"
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    FirstPersonViewMesh=Mesh'DeusExItems.AdaptiveArmor'
    PickupViewMesh=Mesh'DeusExItems.AdaptiveArmor'
    Charge=500
    LandSound=Sound'DeusExSounds.Generic.PaperHit2'
    Icon=Texture'DeusExUI.Icons.BeltIconArmorAdaptive'
    largeIcon=Texture'DeusExUI.Icons.LargeIconArmorAdaptive'
    largeIconWidth=35
    largeIconHeight=49
    Description="Integrating woven fiber-optics and an advanced computing system, thermoptic camo can render an agent invisible to both humans and bots by dynamically refracting light and radar waves; however, the high power drain makes it impractial for more than short-term use, after which the circuitry is fused and it becomes useless."
    beltDescription="T CAMO"
    Mesh=Mesh'DeusExItems.AdaptiveArmor'
    CollisionRadius=11.50
    CollisionHeight=13.81
    Mass=30.00
    Buoyancy=20.00
}
