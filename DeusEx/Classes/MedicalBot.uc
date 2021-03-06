//=============================================================================
// MedicalBot.
//=============================================================================
class MedicalBot extends Robot;

var int healAmount;
var int healRefreshTime;
var float lastHealTime;


event PostBeginPlay()
{
    Super.PostBeginPlay();

    lastHealTime = -healRefreshTime;
}

function StandStill()
{
    Controller.GotoState('Idle', 'Idle');
    Acceleration=Vect(0, 0, 0);
}

// ----------------------------------------------------------------------
// Invoke the Augmentation Upgrade 
// ----------------------------------------------------------------------
function Frob(Actor Frobber, Inventory frobWith)
{
    local DeusExPlayer player;
    local DeusExPlayerController pc;
    local Object mi;
    local AugmentationCannister augCan;
    local DeusExGlobals gl;

    gl = class'DeusExGlobals'.static.GetGlobals();

    Super.Frob(Frobber, frobWith);

    pc = DeusExPlayerController(level.GetLocalPlayerController());
    player = DeusExPlayer(pc.pawn);
    
    if (player != None)
    {
       // First check to see if the player has any augmentation cannisters.
       // If so, then we'll pull up the Add Augmentations screen.  
       // Otherwise pull up the Health screen first.
       augCan = AugmentationCannister(player.FindInventoryType(Class'AugmentationCannister'));

       if (augCan != None)
       {
          gl.lastMedBot = self;
          mi = pc.OpenMenuEx("DeusEx.MedBotInterface",false, "AUGS");
          MedBotInterface(mi).SetMedicalBot(Self, True);
       }
       else
       {
          gl.lastMedBot = self;
          mi = pc.OpenMenuEx("DeusEx.MedBotInterface",false, "HEALTH");
          MedBotInterface(mi).SetMedicalBot(Self, True);
       }
    }
}

function int HealPlayer(DeusExPlayer player)
{
    local int healedPoints;

    if (player != None)
    {
        healedPoints = player.HealPlayer(healAmount);
        lastHealTime = Level.TimeSeconds;
    }

    return healedPoints;
}

// ----------------------------------------------------------------------
// Returns whether or not the bot can heal the player
// ----------------------------------------------------------------------
function bool CanHeal()
{   
    return (Level.TimeSeconds - lastHealTime > healRefreshTime);
}

function float GetRefreshTimeRemaining()
{
    return healRefreshTime - (Level.TimeSeconds - lastHealTime);
}

// Mesh notify
function MedBotHoldArm()
{
   freezeAnimAt(7);
}

// Mesh notify
function HoldUpAndScan()
{
   freezeAnimAt(6);
}


defaultproperties
{
     healAmount=300
     healRefreshTime=60
     BindName="MedicalBot"
     FamiliarName="Medical Bot"
     UnfamiliarName="Medical Bot"
     WalkingPct=0.200000
     GroundSpeed=200.000000
     WaterSpeed=50.000000
     AirSpeed=144.000000
     AccelRate=500.000000
     UnderWaterTime=20.000000
     bFullVolume=false
     AmbientSound=Sound'DeusExSounds.Robot.MedicalBotMove'
     Mesh=mesh'DeusExCharacters.MedicalBot'
     SoundRadius=16
     SoundVolume=128
     CollisionRadius=25.000000
     CollisionHeight=31.85
     //CollisionHeight=36.310001
     Buoyancy=97.000000
}
