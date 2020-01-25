//=============================================================================
// AugRadarTrans.
//=============================================================================
class AugRadarTrans extends Augmentation;

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
     Icon=Texture'DeusExUI.UserInterface.AugIconRadarTrans'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconRadarTrans_Small'
     AugmentationName="Radar Transparency"
     InternalAugmentationName="Radar_Transparency"
     Description="Radar-absorbent resin augments epithelial proteins; microprojection units distort agent's visual signature. Provides highly effective concealment from automated detection systems -- bots, cameras, turrets.||TECH ONE: Power drain is normal.||TECH TWO: Power drain is reduced slightly.||TECH THREE: Power drain is reduced moderately.||TECH FOUR: Power drain is reduced significantly."
     LevelValues(0)=1.000000
     LevelValues(1)=0.830000
     LevelValues(2)=0.660000
     LevelValues(3)=0.500000
     AugmentationLocation=LOC_Subdermal
}
