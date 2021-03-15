//=============================================================================
// AppleJuice
//=============================================================================
class AppleJuice extends DeusExPickup;

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
            player.HealPlayer(3 + Rand(2), False);
        
        UseOnce();
    }
Begin:
}

defaultproperties
{
    maxCopies=10
    bCanHaveMultipleCopies=True
    bActivatable=True

    PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
    Description="Natural apple juice. Probably import from Germany."
    ItemName="Apple Juice"
    BeltDescription="APPJUICE"
    Icon=Texture'DeusExUI.Icons.BeltIconSoyFood'
    largeIcon=Texture'DeusExUI.Icons.LargeIconSoyFood'
    largeIconWidth=42
    largeIconHeight=46

    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_Pickups.AppleJuice_Pickup'
    PickupViewStaticMesh=StaticMesh'DXR_Pickups.AppleJuice_Pickup'
    FirstPersonViewStaticMesh=StaticMesh'DXR_Pickups.AppleJuice'
    bUseFirstPersonStaticMesh=true
    bUsePickupViewStaticMesh=true

    CollisionRadius=2.000000
    CollisionHeight=6.000000

    Mass=3.000000
    Buoyancy=4.000000
}

