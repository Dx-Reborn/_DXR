//=============================================================================
// AugBallistic.
//=============================================================================
class AugBallistic extends Augmentation;

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
     EnergyRate=60.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconBallistic'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconBallistic_Small'
     AugmentationName="Ballistic Protection"
     InternalAugmentationName="Ballistic_Protection"
     Description="Monomolecular plates reinforce the skin's epithelial membrane, reducing the damage an agent receives from projectiles and bladed weapons.||TECH ONE: Damage from projectiles and bladed weapons is reduced slightly.||TECH TWO: Damage from projectiles and bladed weapons is reduced moderately.||TECH THREE: Damage from projectiles and bladed weapons is reduced significantly.||TECH FOUR: An agent is nearly invulnerable to damage from projectiles and bladed weapons."
     LevelValues(0)=0.800000
     LevelValues(1)=0.650000
     LevelValues(2)=0.500000
     LevelValues(3)=0.350000
     AugmentationLocation=LOC_Subdermal
}
