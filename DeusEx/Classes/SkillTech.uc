//=============================================================================
// SkillTech.
//=============================================================================
class SkillTech extends Skill;


var localized String MultitoolString;

defaultproperties
{
     MultitoolString="Multitooling"
     InternalSkillName="Electronics"
     SkillName="Electronics"
     Description="By studying electronics and its practical application, agents can more efficiently bypass a number of security systems using multitools.||UNTRAINED: An agent can bypass security systems.||TRAINED: The efficiency with which an agent bypasses security increases slightly.||ADVANCED: The efficiency with which an agent bypasses security increases moderately.||MASTER: An agent encounters almost no security systems of any challenge."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconTech'
     cost(0)=1800
     cost(1)=3600
     cost(2)=6000
     LevelValues(0)=0.100000
     LevelValues(1)=0.250000
     LevelValues(2)=0.400000
     LevelValues(3)=0.750000
     itemNeeded=Class'DeusEx.Multitool'
}
