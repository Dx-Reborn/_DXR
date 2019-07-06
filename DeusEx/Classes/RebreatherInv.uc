class RebreatherInv extends chargedpickupInv;

function ChargedPickupUpdate(DeusExPlayer Player)
{
	Super.ChargedPickupUpdate(Player);

	Player.swimTimer = Player.swimDuration;
}

defaultproperties
{
    skillNeeded=Class'SkillEnviro'

    LoopSound=Sound'DeusExSounds.Pickup.RebreatherLoop'
    LandSound=Sound'DeusExSounds.Generic.PaperHit2'

    ChargedIcon=Texture'DeusExUI.Icons.ChargedIconRebreather'
    ExpireMessage="Rebreather power supply used up"
    ItemName="Rebreather"
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-6.00),

    FirstPersonViewMesh=Mesh'DeusExItems.Rebreather'
    PickupViewMesh=Mesh'DeusExItems.Rebreather'
    Mesh=Mesh'DeusExItems.Rebreather'

    LandSound=Sound'DeusExSounds.Generic.PaperHit2'
    Icon=Texture'DeusExUI.Icons.BeltIconRebreather'
    largeIcon=Texture'DeusExUI.Icons.LargeIconRebreather'
    largeIconWidth=44
    largeIconHeight=34
    Description="A disposable chemical scrubber that can extract oxygen from water during brief submerged operations."
    beltDescription="REBREATHR"

    CollisionRadius=6.90
    CollisionHeight=3.61
    Mass=10.00
    Buoyancy=8.00
}
