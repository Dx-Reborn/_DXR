class DrinksAndFood extends DeusExPickup
                                abstract;

var int HealAmount;


state Activated
{
    function Activate()
    {
        // can't turn it off
    }

    event BeginState()
    {
        local DeusExPlayer player;
        
        Super.BeginState();

        player = DeusExPlayer(Owner);
        if (player != None)
            player.HealPlayer(HealAmount, False);
        
        UseOnce();
    }
Begin:
}

defaultproperties
{
    HealAmount=1
    maxCopies=10
    bCanHaveMultipleCopies=true
    bActivatable=true
    Mass=3.000000
    Buoyancy=4.000000
}

