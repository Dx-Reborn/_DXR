//=============================================================================
// VialCrackInv
//=============================================================================
class VialCrack extends DeusExPickup;

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
        {
            player.drugEffectTimer += 60.0;
            player.HealPlayer(-10, False);
        }

        UseOnce();
    }
Begin:
}


defaultproperties
{
    maxCopies=20
    bCanHaveMultipleCopies=True
    bActivatable=True

    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    ItemName="Zyme Vial"
    beltDescription="ZYME"
    Description="A vial of zyme, brewed up in some basement lab."

    Mesh=Mesh'DeusExItems.VialCrack'
    PickupViewMesh=Mesh'DeusExItems.VialCrack'
    FirstPersonViewMesh=Mesh'DeusExItems.VialCrack'

    Icon=Texture'DeusExUI.Icons.BeltIconVial_Crack'
    largeIcon=Texture'DeusExUI.Icons.LargeIconVial_Crack'
    LandSound=Sound'DeusExSounds.Generic.GlassHit1'
    largeIconWidth=24
    largeIconHeight=43
    CollisionRadius=0.910000
    CollisionHeight=1.410000
    Mass=2.000000
    Buoyancy=3.000000
}
