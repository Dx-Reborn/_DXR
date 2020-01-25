//=============================================================================
// NanoKey.
//=============================================================================
class NanoKey extends DeusExPickup;

var() name          KeyID;          // unique FName identifier used for movers and such

enum ESkinColor
{
    SC_Level1,
    SC_Level2,
    SC_Level3,
    SC_Level4
};

var() ESkinColor SkinColor;

// ----------------------------------------------------------------------
// BeginPlay()
// ----------------------------------------------------------------------

function BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
        case SC_Level1: Skins[0] = Texture'NanoKeyTex1'; break;
        case SC_Level2: Skins[0] = Texture'NanoKeyTex2'; break;
        case SC_Level3: Skins[0] = Texture'NanoKeyTex3'; break;
        case SC_Level4: Skins[0] = Texture'NanoKeyTex4'; break;
    }
}


// ----------------------------------------------------------------------
// GiveTo()
//
// Called during conversations since HandlePickupQuery() isn't called
// then
// ----------------------------------------------------------------------

function GiveTo(pawn Other)
{
    local DeusExPlayer player;

    if (Other.IsA('DeusExPlayer'))
    {
        player = DeusExPlayer(Other);
        player.PickupNanoKey(Self);
        Destroy();
    }
    else
    {
        /*log("Nanokey: something else");*/Super.GiveTo(Other);
    }
}


// ----------------------------------------------------------------------
// HandlePickupQuery()
//
// Adds the NanoKey to the player's NanoKeyRing and then destroys 
// this object
// ----------------------------------------------------------------------

function bool HandlePickupQuery(Inventory Item)
{
    local DeusExPlayer player;

    if (Item.Class == Class)
    {
        player = DeusExPlayer(Owner);
        player.PickupNanoKey(NanoKey(item));
        item.Destroy();
            
        return True;
    }
    return Super.HandlePickupQuery(Item);
}


// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     Description="NO KEY DESCRIPTION - REPORT THIS AS A BUG!"
     beltDescription="NANO"
     ItemName="NanoKey"

     Mesh=Mesh'DeusExItems.NanoKey'
     PickupViewMesh=Mesh'DeusExItems.NanoKey'
     FirstPersonViewMesh=Mesh'DeusExItems.NanoKey'

     CollisionRadius=2.050000
     CollisionHeight=3.110000
     Mass=1.000000
}
