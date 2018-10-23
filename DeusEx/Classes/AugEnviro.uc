//=============================================================================
// AugEnviro.
//=============================================================================
class AugEnviro extends Augmentation;

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
     Icon=Texture'DeusExUI.UserInterface.AugIconEnviro'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconEnviro_Small'
     AugmentationName="Environmental Resistance"
     InternalAugmentationName="Environmental_Resistance"
     Description="Induced keratin production strengthens all epithelial tissues and reduces the agent's vulnerability to radiation and other toxins.||TECH ONE: Toxic resistance is increased slightly.||TECH TWO: Toxic resistance is increased moderately.||TECH THREE: Toxic resistance is increased significantly.||TECH FOUR: An agent is nearly invulnerable to damage from toxins."
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     LevelValues(3)=0.100000
     AugmentationLocation=LOC_Torso
}
