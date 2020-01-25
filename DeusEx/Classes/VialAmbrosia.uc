//=============================================================================
// VialAmbrosia.
//=============================================================================
class VialAmbrosia extends DeusExPickup;

var localized String msgNoEffect;

state Activated
{
    function Activate()
    {
        // can't turn it off
    }

    function BeginState()
    {
        local DeusExPlayer player;
        
        Super.BeginState();

        player = DeusExPlayer(Owner);
        if (player != None)
            player.ClientMessage(msgNoEffect);

        UseOnce();
    }
Begin:
}


defaultproperties
{
    LandSound=Sound'DeusExSounds.Generic.GlassHit1'
    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    msgNoEffect="Strange...nothing happens..."
    Description="The only known vaccine against the 'Gray Death.' Unfortunately, it is quickly metabolized by the body making its effects temporary at best."
    ItemName="Ambrosia Vial"
    beltDescription="AMBROSIA"
    Icon=Texture'DeusExUI.Icons.BeltIconVialAmbrosia'
    largeIcon=Texture'DeusExUI.Icons.LargeIconVialAmbrosia'
    largeIconWidth=18
    largeIconHeight=44

    Mesh=Mesh'DeusExItems.VialAmbrosia'
    PickupViewMesh=Mesh'DeusExItems.VialAmbrosia'
    FirstPersonViewMesh=Mesh'DeusExItems.VialAmbrosia'

    CollisionRadius=2.200000
    CollisionHeight=4.890000
    Mass=2.000000
    Buoyancy=3.000000
}