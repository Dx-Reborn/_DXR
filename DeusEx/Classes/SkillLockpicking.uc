//=============================================================================
// SkillLockpicking.
//=============================================================================
class SkillLockpicking extends Skill;


defaultproperties
{
     InternalSkillName="Lockpicking"
     SkillName="Lockpicking"
     Description="Lockpicking is as much art as skill, but with intense study it can be mastered by any agent with patience and a set of lockpicks.||UNTRAINED: An agent can pick locks.||TRAINED: The efficiency with which an agent picks locks increases slightly.||ADVANCED: The efficiency with which an agent picks locks increases moderately.||MASTER: An agent can defeat almost any mechanical lock."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconLockPicking'
     cost(0)=1800
     cost(1)=3600
     cost(2)=6000
     LevelValues(0)=0.100000
     LevelValues(1)=0.250000
     LevelValues(2)=0.400000
     LevelValues(3)=0.750000
     itemNeeded=Class'DeusEx.Lockpick'
}
