//=============================================================================
// BallisticArmorInv.uc
//=============================================================================
class BallisticArmorInv extends ChargedPickupInv;

//
// Reduces ballistic damage
//

defaultproperties
{
    skillNeeded=Class'SkillEnviro'
    LoopSound=Sound'DeusExSounds.Pickup.SuitLoop'
    LandSound=Sound'DeusExSounds.Generic.PaperHit2'

    ChargedIcon=Texture'DeusExUI.Icons.ChargedIconArmorBallistic'
    ExpireMessage="Ballistic Armor power supply used up"
    ItemName="Ballistic Armor"
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)

    FirstPersonViewMesh=Mesh'DeusExItems.BallisticArmor'
    PickupViewMesh=Mesh'DeusExItems.BallisticArmor'
    Mesh=Mesh'DeusExItems.BallisticArmor'

    Charge=1000
    Icon=Texture'DeusExUI.Icons.BeltIconArmorBallistic'
    largeIcon=Texture'DeusExUI.Icons.LargeIconArmorBallistic'
    largeIconWidth=34
    largeIconHeight=49
    Description="Ballistic armor is manufactured from electrically sensitive polymer sheets that intrinsically react to the violent impact of a bullet or an explosion by 'stiffening' in response and absorbing the majority of the damage.  These polymer sheets must be charged before use; after the charge has dissipated they lose their reflexive properties and should be discarded."
    beltDescription="B ARMOR"
    
    CollisionRadius=11.50
    CollisionHeight=13.81
    Mass=40.00
    Buoyancy=30.00
}
