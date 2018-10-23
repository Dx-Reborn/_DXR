//=============================================================================
// SkillWeaponRifle.
//=============================================================================
class SkillWeaponRifle extends Skill;

defaultproperties
{
     InternalSkillName="Weapons: Rifle"
     SkillName="Weapons: Rifle"
     Description="The use of rifles, including assault rifles, sniper rifles, and shotguns.||UNTRAINED: An agent can use rifles.||TRAINED: Accuracy and damage increases slightly, while reloading is faster.||ADVANCED: Accuracy and damage increases moderately, while reloading is even more rapid.||MASTER: An agent can take down a target a mile away with one shot."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponRifle'
     cost(0)=1575
     cost(1)=3150
     cost(2)=5250
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
