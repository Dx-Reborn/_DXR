//=============================================================================
// SodacanInv.
//=============================================================================
class Sodacan extends DeusExPickup;

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
            player.HealPlayer(2, False);

        PlaySound(sound'MaleBurp');
        UseOnce();
    }
Begin:
}


defaultproperties
{
    maxCopies=10
    bCanHaveMultipleCopies=True
    bActivatable=True

    LandSound=Sound'DeusExSounds.Generic.MetalHit1'

    Description="The can is blank except for the phrase 'PRODUCT PLACEMENT HERE.' It is unclear whether this is a name or an invitation."
    ItemName="Soda"
    beltDescription="SODA"
    Icon=Texture'DeusExUI.Icons.BeltIconSodaCan'
    largeIcon=Texture'DeusExUI.Icons.LargeIconSodaCan'
    largeIconWidth=24
    largeIconHeight=45

    Mesh=Mesh'DeusExItems.Sodacan'
    PickupViewMesh=Mesh'DeusExItems.Sodacan'
    FirstPersonViewMesh=Mesh'DeusExItems.Sodacan'

    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    CollisionRadius=3.000000
    CollisionHeight=4.500000
    Mass=5.000000
    Buoyancy=3.000000
}
