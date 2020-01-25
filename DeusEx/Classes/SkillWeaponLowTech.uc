//=============================================================================
// SkillWeaponLowTech.
//=============================================================================
class SkillWeaponLowTech extends Skill;

defaultproperties
{
     InternalSkillName="Weapons: Low-Tech"
     SkillName="Weapons: Low-Tech"
     Description="The use of melee weapons such as knives, throwing knives, swords, pepper guns, and prods.||UNTRAINED: An agent can use melee weaponry.||TRAINED: Accuracy, damage, and rate of attack all increase slightly.||ADVANCED: Accuracy, damage, and rate of attack all increase moderately.||MASTER: An agent can render most opponents unconscious or dead with a single blow."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponLowTech'
     cost(0)=1350
     cost(1)=2700
     cost(2)=4500
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
