//=============================================================================
// WineBottleInv.
//=============================================================================
class WineBottle extends DeusExPickup;

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
            player.HealPlayer(2, False);
            player.drugEffectTimer += 5.0;
        }

        UseOnce();
    }
Begin:
}


defaultproperties
{
   bBreakable=True
   maxCopies=10
   bCanHaveMultipleCopies=True
   bActivatable=True

   PlayerViewOffset=(X=30.00,Y=0.00,Z=-12.00)
   LandSound=Sound'DeusExSounds.Generic.GlassHit1'
   Description="A nice bottle of wine."
   ItemName="Wine"
   beltDescription="WINE"
   Icon=Texture'DeusExUI.Icons.BeltIconWineBottle'
   largeIcon=Texture'DeusExUI.Icons.LargeIconWineBottle'
   largeIconWidth=36
   largeIconHeight=48

/*    Mesh=Mesh'DeusExItems.WineBottle'
    PickupViewMesh=Mesh'DeusExItems.WineBottle'
    FirstPersonViewMesh=Mesh'DeusExItems.WineBottle'*/

   DrawType=DT_StaticMesh
   StaticMesh=StaticMesh'DXR_Pickups.WineBottle_HD'
   PickupViewStaticMesh=StaticMesh'DXR_Pickups.WineBottle_HD_Pickup'
   FirstPersonViewStaticMesh=StaticMesh'DXR_Pickups.WineBottle_HD'
   bUseFirstPersonStaticMesh=true
   bUsePickupViewStaticMesh=true


   CollisionRadius=4.060000
   CollisionHeight=16.180000
   Mass=10.000000
   Buoyancy=8.000000
}

   



