//=============================================================================
// TechGoggles.
//=============================================================================
class TechGoggles extends ChargedPickup;


function ChargedPickupBegin(DeusExPlayer Player)
{
    Super.ChargedPickupBegin(Player);

    Player.activeCount++;
    UpdateHUDDisplay(Player);
}

function UpdateHUDDisplay(DeusExPlayer Player)
{
   if ((Player.activeCount == 0) && (IsActive()))
        Player.ActiveCount++;

    Player.bVisionActive = true;
    Player.visionLevel = 0;
    Player.visionLevelValue = 0;
}

function ChargedPickupEnd(DeusExPlayer Player)
{
    Super.ChargedPickupEnd(Player);

    if (--Player.activeCount == 0)
        Player.bVisionActive = false;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    LoopSound=Sound'DeusExSounds.Pickup.TechGogglesLoop'
    LandSound=Sound'DeusExSounds.Generic.PaperHit2'

    ChargedIcon=Texture'DeusExUI.Icons.ChargedIconGoggles'
    ExpireMessage="TechGoggles power supply used up"
    ItemName="Tech Goggles"
    PlayerViewOffset=(X=20.00,Y=0.00,Z=-6.00)

    FirstPersonViewMesh=Mesh'DeusExItems.GogglesIR'
    PickupViewMesh=Mesh'DeusExItems.GogglesIR'
    Mesh=Mesh'DeusExItems.GogglesIR'

    Charge=500
    Icon=Texture'DeusExUI.Icons.BeltIconTechGoggles'
    largeIcon=Texture'DeusExUI.Icons.LargeIconTechGoggles'
    largeIconWidth=49
    largeIconHeight=36
    Description="Tech goggles are used by many special ops forces throughout the world under a number of different brand names, but they all provide some form of portable light amplification in a disposable package."
    beltDescription="GOGGLES"
    CollisionRadius=8.00
    CollisionHeight=2.80
    Mass=10.00
    Buoyancy=5.00
}
