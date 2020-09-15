//=============================================================================
// AugTarget.
//=============================================================================
class AugTarget extends Augmentation;

state Active
{
Begin:
    Player.bTargetActive = True;
    Player.targetLevel = CurrentLevel;
}

function Deactivate()
{
    Super.Deactivate();
    Player.bTargetActive = false;
}



defaultproperties
{
     EnergyRate=40.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconTarget'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconTarget_Small'
     AugmentationName="Targeting"
     InternalAugmentationName="Targeting"
     Description="Image-scaling and recognition provided by multiplexing the optic nerve with doped polyacetylene 'quantum wires' not only increases accuracy, but also delivers limited situational info about a target.||TECH ONE: Slight increase in accuracy and general target information.||TECH TWO: Additional increase in accuracy and more target information.||TECH THREE: Additional increase in accuracy and specific target information.||TECH FOUR: Additional increase in accuracy and telescopic vision."
     LevelValues(0)=-0.050000
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.150000
     LevelValues(3)=-0.200000
     AugmentationLocation=LOC_Eye
}
