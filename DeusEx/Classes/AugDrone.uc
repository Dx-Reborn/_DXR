//=============================================================================
// AugDrone.
//=============================================================================
class AugDrone extends Augmentation;

var float reconstructTime;
var float lastDroneTime;
var localized string ReconstructA, ReconstructB;

state Active
{
Begin:
	if (Level.TimeSeconds - lastDroneTime < reconstructTime)
	{
		Player.ClientMessage(ReconstructA @ Int(reconstructTime - (Level.TimeSeconds - lastDroneTime)) @ ReconstructB);
		Deactivate();
	}
	else
	{
		DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bSpyDroneActive = True;
		DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).spyDroneLevel = CurrentLevel;
		DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).spyDroneLevelValue = LevelValues[CurrentLevel];
	}
}

function Deactivate()
{
	Super.Deactivate();

	// record the time if we were just active
	if (DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bSpyDroneActive)
		lastDroneTime = Level.TimeSeconds;

	DeusExHud(DeusExPlayerController(Level.GetLocalPlayerController()).myHUD).bSpyDroneActive = False;
}

defaultproperties
{
     reconstructTime=30.000000
     lastDroneTime=-30.000000
     EnergyRate=150.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconDrone'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconDrone_Small'
     InternalAugmentationName="Spy_Drone"
     AugmentationName="Spy Drone"
     Description="Advanced nanofactories can assemble a spy drone upon demand which can then be remotely controlled by the agent until released or destroyed, at which a point a new drone will be assembled. Further upgrades equip the spy drones with better armor and a one-shot EMP attack.||TECH ONE: The drone can take little damage and has a very light EMP attack.||TECH TWO: The drone can take minor damage and has a light EMP attack.||TECH THREE: The drone can take moderate damage and has a medium EMP attack.||TECH FOUR: The drone can take heavy damage and has a strong EMP attack."
     ReconstructA="Reconstruction will be complete in"
     ReconstructB="seconds"
     LevelValues(0)=10.000000
     LevelValues(1)=20.000000
     LevelValues(2)=35.000000
     LevelValues(3)=50.000000
}
