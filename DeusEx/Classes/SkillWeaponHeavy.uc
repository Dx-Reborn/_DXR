//=============================================================================
// SkillWeaponHeavy.
//=============================================================================
class SkillWeaponHeavy extends Skill;


defaultproperties
{
     InternalSkillName="Weapons: Heavy"
     SkillName="Weapons: Heavy"
     Description="The use of heavy weaponry, including flamethrowers, LAWs, and the experimental plasma and GEP guns.||UNTRAINED: An agent can use heavy weaponry, but their accuracy is low and movement is difficult.||TRAINED: Accuracy and damage increases slightly, while reloading and movement is somewhat faster.||ADVANCED: Accuracy and damage increases moderately, while reloading and movement is even more rapid.||MASTER: An agent is a walking tank when equipped with heavy weaponry."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     cost(0)=1350
     cost(1)=2700
     cost(2)=4500
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
