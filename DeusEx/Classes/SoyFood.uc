//=============================================================================
// SoyFood.
//=============================================================================
class SoyFood extends DeusExPickup;

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
            player.HealPlayer(5, False);
        
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
    Description="Fine print: 'Seasoned with nanoscale mechanochemical generators, this TSP (textured soy protein) not only tastes good but also self-heats when its package is opened.'"
    ItemName="Soy Food"
    BeltDescription="SOYFOOD"
    Icon=Texture'DeusExUI.Icons.BeltIconSoyFood'
    largeIcon=Texture'DeusExUI.Icons.LargeIconSoyFood'
    largeIconWidth=42
    largeIconHeight=46

//    Mesh=Mesh'DeusExItems.SoyFood'
//    PickupViewMesh=Mesh'DeusExItems.SoyFood'
//    FirstPersonViewMesh=Mesh'DeusExItems.SoyFood'
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_Pickups.SoyFood_HD'
    PickupViewStaticMesh=StaticMesh'DXR_Pickups.SoyFood_HD_Pickup'
    FirstPersonViewStaticMesh=StaticMesh'DXR_Pickups.SoyFood_HD'
    bUseFirstPersonStaticMesh=true
    bUsePickupViewStaticMesh=true


    CollisionRadius=8.000000
    CollisionHeight=0.980000
    Mass=3.000000
    Buoyancy=4.000000
}
