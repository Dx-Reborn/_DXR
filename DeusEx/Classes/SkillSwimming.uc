//=============================================================================
// SkillSwimming.
//=============================================================================
class SkillSwimming extends Skill;

defaultproperties
{
     InternalSkillName="Swimming"
     SkillName="Swimming"
     Description="Underwater operations require their own unique set of skills that must be developed by an agent with extreme physical dedication.||UNTRAINED: An agent can swim normally.||TRAINED: The swimming speed and lung capacity of an agent increases slightly.||ADVANCED:  The swimming speed and lung capacity of an agent increases moderately.||MASTER: An agent moves like a dolphin underwater."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconSwimming'
     bAutomatic=True
     cost(0)=675
     cost(1)=1350
     cost(2)=2250
     LevelValues(0)=1.000000
     LevelValues(1)=1.500000
     LevelValues(2)=2.000000
     LevelValues(3)=2.500000
}
