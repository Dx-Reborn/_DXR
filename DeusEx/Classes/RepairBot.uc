//=============================================================================
// RepairBot.
//=============================================================================
class RepairBot extends Robot;

var int chargeAmount;
var int chargeRefreshTime;
var Float lastchargeTime;


function PostBeginPlay()
{
    Super.PostBeginPlay();

    lastChargeTime = -chargeRefreshTime;
}

function StandStill()
{
    Controller.GotoState('Idle', 'Idle');
    Acceleration=Vect(0, 0, 0);
}

function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExPlayer Player;
    local DeusExPlayerController pc;
    local RepairBotInterfaceA interface;

    Player = DeusExPlayer(Frobber);
    pc = DeusExPlayerController(level.GetLocalPlayerController());

    if (player != None) 
    {
      interface = RepairBotInterfaceA(pc.OpenMenuEx("DXRMenu.RepairBotInterface"));
      interface.SetRepairBot(self); // :)
    }
}

function int ChargePlayer(DeusExPlayer player)
{
    local int chargedPoints;

    if (player != None)
    {
        chargedPoints = player.ChargePlayer(chargeAmount);
        lastChargeTime = Level.TimeSeconds;
    }

    return chargedPoints;
}

// ----------------------------------------------------------------------
// CanCharge()
// Returns whether or not the bot can charge the player
// ----------------------------------------------------------------------
function bool CanCharge()
{   
    return (Level.TimeSeconds - lastChargeTime > chargeRefreshTime);
}

function float GetRefreshTimeRemaining()
{
    return chargeRefreshTime - (Level.TimeSeconds - lastChargeTime);
}

function int GetAvailableCharge()
{
    if (CanCharge())
        return chargeAmount; 
    else
        return 0;
}

/* Anim notify, so bot will keep arm raised until interface is closed */
function RepairBotHoldArm()
{
  freezeAnimAt(18);
}

// ----------------------------------------------------------------------

defaultproperties
{
     chargeAmount=75
     chargeRefreshTime=60
     BindName="RepairBot"
     FamiliarName="Repair Bot"
     UnfamiliarName="Repair Bot"
     GroundSpeed=100.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=100.000000
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     AmbientSound=Sound'DeusExSounds.Robot.RepairBotMove'
     Mesh=mesh'DeusExCharacters.RepairBot'
     SoundRadius=16
     SoundVolume=128
     CollisionRadius=34.000000
     CollisionHeight=42.97
     //CollisionHeight=47.470001
     Mass=150.000000
     Buoyancy=97.000000
     bFullVolume=true
}
