//=============================================================================
// AugHealing.
//=============================================================================
class AugHealing extends Augmentation;

state Active
{
Begin:
Loop:
	if (Player.Health < 100)
		Player.HealPlayer(Int(LevelValues[CurrentLevel]), False);
	else
		Deactivate();

//	Player.ClientFlash(0.5, vect(0, 0, 500));
	Sleep(1.0);
	Goto('Loop');
}

function Deactivate()
{
	Super.Deactivate();
}


defaultproperties
{
     EnergyRate=120.000000
     icon=Texture'DeusExUI.UserInterface.AugIconHealing'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconHealing_Small'
     AugmentationName="Regeneration"
     InternalAugmentationName="Regeneration"
     Description="Programmable polymerase automatically directs construction of proteins in injured cells, restoring an agent to full health over time.||TECH ONE: Healing occurs at a normal rate.||TECH TWO: Healing occurs at a slightly faster rate.||TECH THREE: Healing occurs at a moderately faster rate.||TECH FOUR: Healing occurs at a significantly faster rate."
     LevelValues(0)=5.000000
     LevelValues(1)=15.000000
     LevelValues(2)=25.000000
     LevelValues(3)=40.000000
     AugmentationLocation=LOC_Torso
}
