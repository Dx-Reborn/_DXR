//=============================================================================
// AugCloak.
//=============================================================================
class AugCloak extends Augmentation;

state Active
{
Begin:
}

function Deactivate()
{
	Super.Deactivate();
}

function float GetEnergyRate()
{
	return energyRate * LevelValues[CurrentLevel];
}

defaultproperties
{
     EnergyRate=300.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconCloak'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconCloak_Small'
     AugmentationName="Cloak"
     InternalAugmentationName="Cloak"
     Description="Subdermal pigmentation cells allow the agent to blend with their surrounding environment, rendering them effectively invisible to observation by organic hostiles.||TECH ONE: Power drain is normal.||TECH TWO: Power drain is reduced slightly.||TECH THREE: Power drain is reduced moderately.||TECH FOUR: Power drain is reduced significantly."
     LevelValues(0)=1.000000
     LevelValues(1)=0.830000
     LevelValues(2)=0.660000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Subdermal
}
