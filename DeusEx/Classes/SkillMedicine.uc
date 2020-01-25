//=============================================================================
// SkillMedicine.
//=============================================================================
class SkillMedicine extends Skill;


defaultproperties
{
     InternalSkillName="Medicine"
     SkillName="Medicine"
     Description="Practical knowledge of human physiology can be applied by an agent in the field allowing more efficient use of medkits.||UNTRAINED: An agent can use medkits.||TRAINED: An agent can heal slightly more damage and reduce the period of toxic poisoning.||ADVANCED: An agent can heal moderately more damage and further reduce the period of toxic poisoning.||MASTER: An agent can perform a heart bypass with household materials."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconMedicine'
     cost(0)=900
     cost(1)=1800
     cost(2)=3000
     LevelValues(0)=1.000000
     LevelValues(1)=2.000000
     LevelValues(2)=2.500000
     LevelValues(3)=3.000000
}
