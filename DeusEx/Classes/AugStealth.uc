//=============================================================================
// AugStealth.
//=============================================================================
class AugStealth extends Augmentation;

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconRunSilent'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconRunSilent_Small'
     AugmentationName="Run Silent"
     InternalAugmentationName="Run_Silent"
     Description="The necessary muscle movements for complete silence when walking or running are determined continuously with reactive kinematics equations produced by embedded nanocomputers.||TECH ONE: Sound made while moving is reduced slightly.||TECH TWO: Sound made while moving is reduced moderately.||TECH THREE: Sound made while moving is reduced significantly.||TECH FOUR: An agent is completely silent."
     LevelValues(0)=0.750000
     LevelValues(1)=0.500000
     LevelValues(2)=0.250000
     AugmentationLocation=LOC_Leg
}
