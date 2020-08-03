//=============================================================================
// CEDoor. By Carone. To be used with the CaroneElevator. Can be used as normal
// DeusExMover also: No functional difference (None that I know of at least)
// Feb.2001: I took out everything that I added to this class because I found
// another way to Check the state of the Doors. I've kept this class to keep
// options available for the future. The Door-Control-feature of the
// CaroneElevator will still work ONLY with this Mover-class.
//=============================================================================
class CEDoor extends DeusExMover;

var bool bIsMoving;

event BeginPlay()
{
    Super.BeginPlay();
    bIsMoving = False;
}

defaultproperties
{
    bPickable=False
    bHighlight=False
    bFrobbable=False
    minDamageThreshold=25
    FragmentClass=Class'DeusEx.MetalFragment'
    MoverEncroachType=1
    EncroachDamage=1
}
