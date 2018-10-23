//=============================================================================
// AugPower.
//=============================================================================
class AugPower extends Augmentation;

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
     EnergyRate=10.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconPowerRecirc_Small'
     AugmentationName="Power Recirculator"
     InternalAugmentationName="Power_Recirculator"
     Description="Power consumption for all augmentations is reduced by polyanilene circuits, plugged directly into cell membranes, that allow nanite particles to interconnect electronically without leaving their host cells.||TECH ONE: Power drain of augmentations is reduced slightly.||TECH TWO: Power drain of augmentations is reduced moderately.||TECH THREE: Power drain of augmentations is reduced.||TECH FOUR: Power drain of augmentations is reduced significantly."
     LevelValues(0)=0.900000
     LevelValues(1)=0.800000
     LevelValues(2)=0.600000
     LevelValues(3)=0.400000
     AugmentationLocation=LOC_Torso
}
