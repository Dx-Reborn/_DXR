//=============================================================================
// AugCombat.
//=============================================================================
class AugCombat extends Augmentation;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

defaultproperties
{
     EnergyRate=20.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCombat'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCombat_Small'
     AugmentationName="Combat Strength"
     InternalAugmentationName="Combat Strength"
     Description="Sorting rotors accelerate calcium ion concentration in the sarcoplasmic reticulum, increasing an agent's muscle speed several-fold and multiplying the damage they inflict in melee combat.||TECH ONE: The effectiveness of melee weapons is increased slightly.||TECH TWO: The effectiveness of melee weapons is increased moderately.||TECH THREE: The effectiveness of melee weapons is increased significantly.||TECH FOUR: Melee weapons are almost instantly lethal."
     LevelValues(0)=1.250000
     LevelValues(1)=1.500000
     LevelValues(2)=1.750000
     LevelValues(3)=2.000000
     AugmentationLocation=LOC_Arm
}
