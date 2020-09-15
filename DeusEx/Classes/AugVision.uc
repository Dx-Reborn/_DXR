//=============================================================================
// AugVision.
//=============================================================================
class AugVision extends Augmentation;



state Active
{
Begin:

    if (++Player.activeCount == 1)
        Player.bVisionActive = True;
    
    Player.visionLevel = CurrentLevel;
    Player.visionLevelValue = LevelValues[CurrentLevel];
}

function Deactivate()
{
    Super.Deactivate();

    if (--Player.activeCount == 0)
        Player.bVisionActive = False;
}




defaultproperties
{
     EnergyRate=40.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconVision'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconVision_Small'
     AugmentationName="Vision Enhancement"
     InternalAugmentationName="Vision_Enhancement"
     Description="By bleaching selected rod photoreceptors and saturating them with metarhodopsin XII, the 'nightvision' present in most nocturnal animals can be duplicated. Subsequent upgrades and modifications add infravision and sonar-resonance imaging that effectively allows an agent to see through walls.||TECH ONE: Nightvision.||TECH TWO: Infravision.||TECH THREE: Close range sonar imaging.||TECH FOUR: Long range sonar imaging."
     LevelValues(2)=320.000000
     LevelValues(3)=800.000000
     AugmentationLocation=LOC_Eye
}
