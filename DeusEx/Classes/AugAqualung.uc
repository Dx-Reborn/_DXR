//=============================================================================
// AugAqualung.
//=============================================================================
class AugAqualung extends Augmentation;

var float mult, pct;

state Active
{
Begin:
	mult = Player.SkillSystem.GetSkillLevelValue(class'SkillSwimming');
	pct = Player.swimTimer / Player.swimDuration;
	Player.UnderWaterTime = LevelValues[CurrentLevel];
	Player.swimDuration = Player.UnderWaterTime * mult;
	Player.swimTimer = Player.swimDuration * pct;
}

function Deactivate()
{
	Super.Deactivate();
	
	mult = Player.SkillSystem.GetSkillLevelValue(class'SkillSwimming');
	pct = Player.swimTimer / Player.swimDuration;
	Player.UnderWaterTime = Player.Default.UnderWaterTime;
	Player.swimDuration = Player.UnderWaterTime * mult;
	Player.swimTimer = Player.swimDuration * pct;
}

defaultproperties
{
     EnergyRate=10.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconAquaLung'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconAquaLung_Small'
     InternalAugmentationName="Aqualung"
     AugmentationName="Aqualung"
     Description="Soda lime exostructures imbedded in the alveoli of the lungs convert CO2 to O2, extending the time an agent can remain underwater.||TECH ONE: Lung capacity is extended slightly.||TECH TWO: Lung capacity is extended moderately.||TECH THREE: Lung capacity is extended significantly.||TECH FOUR: An agent can stay underwater indefinitely."
     LevelValues(0)=30.000000
     LevelValues(1)=60.000000
     LevelValues(2)=120.000000
     LevelValues(3)=240.000000
     AugmentationLocation=LOC_Torso
}
