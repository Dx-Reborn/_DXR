//=============================================================================
// AugSpeed.
//=============================================================================
class AugSpeed extends Augmentation;

state Active
{
Begin:
	Player.GroundSpeed *= LevelValues[CurrentLevel];
	Player.JumpZ *= LevelValues[CurrentLevel];
}

function Deactivate()
{
	Super.Deactivate();
	Player.GroundSpeed = Player.default.GroundSpeed;
	Player.JumpZ = Player.default.JumpZ;
}


defaultproperties
{
     EnergyRate=40.000000
     Icon=Texture'DeusExUI.UserInterface.AugIconSpeedJump'
     smallIcon=Texture'DeusExUI.UserInterface.AugIconSpeedJump_Small'
     AugmentationName="Speed Enhancement"
     InternalAugmentationName="Speed_Enhancement"
     Description="Ionic polymeric gel myofibrils are woven into the leg muscles, increasing the speed at which an agent can run and climb, the height they can jump, and reducing the damage they receive from falls.||TECH ONE: Speed and jumping are increased slightly, while falling damage is reduced.||TECH TWO: Speed and jumping are increased moderately, while falling damage is further reduced.||TECH THREE: Speed and jumping are increased significantly, while falling damage is substantially reduced.||TECH FOUR: An agent can run like the wind and leap from the tallest building."
     LevelValues(0)=1.200000
     LevelValues(1)=1.400000
     LevelValues(2)=1.600000
     LevelValues(3)=1.800000
     AugmentationLocation=LOC_Leg
}
