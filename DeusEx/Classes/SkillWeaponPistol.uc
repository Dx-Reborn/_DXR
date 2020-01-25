//=============================================================================
// SkillWeaponPistol.
//=============================================================================
class SkillWeaponPistol extends Skill;

defaultproperties
{
     InternalSkillName="Weapons: Pistol"
     SkillName="Weapons: Pistol"
     Description="The use of hand-held weapons, including the standard 10mm pistol, its stealth variant, and the mini-crossbow.||UNTRAINED: An agent can use pistols.||TRAINED: Accuracy and damage increases slightly, while reloading is faster.||ADVANCED: Accuracy and damage increases moderately, while reloading is even more rapid.||MASTER: An agent is lethally precise with pistols."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponPistol'
     cost(0)=1575
     cost(1)=3150
     cost(2)=5250
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
    CurrentLevel=1
}
