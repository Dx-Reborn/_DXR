/*
   A lighter, to burn flammable things!
*/

class Lighter extends DeusExPickup;

var int AddLighterUseCounter;

function GiveTo(pawn Other)
{
    local DeusExPlayer player;

    if (Other.IsA('DeusExPlayer'))
    {
        player = DeusExPlayer(Other);
        player.LighterUseCount += AddLighterUseCounter;
        SetTimer(0.01, false);
//        player.ClientMessage(PickupMessage @ "("$player.LighterUseCount$")");
//        Destroy();
    }
    else
    {
        Super.GiveTo(Other);
    }
}

function bool HandlePickupQuery(Inventory Item)
{
    local DeusExPlayer player;

    if (Item.class == class)
    {
        player = DeusExPlayer(Owner);
        player.LighterUseCount += AddLighterUseCounter;
        SetTimer(0.01, false);
//        player.ClientMessage(PickupMessage @ "("$player.LighterUseCount$")");
//        item.Destroy();
            
        return true;
    }
    return Super.HandlePickupQuery(Item);
}

event Timer()
{
    Destroy();
}

event Destroyed()
{
    log(self@" has been destroyed!",'Debug');
}


defaultproperties
{
     Description="Should not appear in the inventory!"
     beltDescription="LIGHTER"
     ItemName="Lighter"
     Icon=Texture'DeusExUI.Icons.BeltIconNanoKey'

     bUsePickupViewStaticMesh=true
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes7.Lighter_a'
     PickupViewStaticMesh=StaticMesh'DeusExStaticMeshes7.Lighter_a'

     AddLighterUseCounter=20
     PrePivot=(Z=4.000000)
     CollisionRadius=2.000000
     CollisionHeight=4.000000

     Mass=1.000000
}
