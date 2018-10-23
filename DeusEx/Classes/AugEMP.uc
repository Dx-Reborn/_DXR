//=============================================================================
// AugEMP.
//=============================================================================
class AugEMP extends Augmentation;

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
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     AugmentationName="EMP Shield"
     InternalAugmentationName="EMP_Shield"
     Description="Nanoscale EMP generators partially protect individual nanites and reduce bioelectrical drain by canceling incoming pulses.||TECH ONE: Damage from EMP attacks is reduced slightly.||TECH TWO: Damage from EMP attacks is reduced moderately.||TECH THREE: Damage from EMP attacks is reduced significantly.||TECH FOUR: An agent is nearly invulnerable to damage from EMP attacks."
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     AugmentationLocation=LOC_Subdermal
}
