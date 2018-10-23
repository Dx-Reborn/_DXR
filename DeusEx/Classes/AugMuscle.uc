//=============================================================================
// AugMuscle.
//=============================================================================
class AugMuscle extends Augmentation;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();

	// check to see if the player is carrying something too heavy for him
	if (Player.CarriedDecoration != None)
		if (!Player.CanBeLifted(Player.CarriedDecoration))
			Player.DropDecoration();
}

defaultproperties
{
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconMuscle'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconMuscle_Small'
     AugmentationName="Microfibral Muscle"
     InternalAugmentationName="Microfibral_Muscle"
     Description="Muscle strength is amplified with ionic polymeric gel myofibrils that allow the agent to push and lift extraordinarily heavy objects.||TECH ONE: Strength is increased slightly.||TECH TWO: Strength is increased moderately.||TECH THREE: Strength is increased significantly.||TECH FOUR: An agent is inhumanly strong."
     LevelValues(0)=1.250000
     LevelValues(1)=1.500000
     LevelValues(2)=1.750000
     LevelValues(3)=2.000000
     AugmentationLocation=LOC_Arm
}
