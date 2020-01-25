//=============================================================================
// SkillEnviro.
//=============================================================================
class SkillEnviro extends Skill;

defaultproperties
{
     InternalSkillName="Environmental Training"
     SkillName="Environmental Training"
     Description="Experience with using hazmat suits, ballistic armor, thermoptic camo, and rebreathers in a number of dangerous situations.||UNTRAINED: An agent can use hazmat suits, ballistic armor, thermoptic camo, and rebreathers.||TRAINED: Armor, suits, camo, and rebreathers can be used slightly longer and more efficiently.||ADVANCED: Armor, suits, camo, and rebreathers can be used moderately longer and more efficiently.||MASTER: An agent wears suits and armor like a second skin."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconEnviro'
     bAutomatic=True
     cost(0)=675
     cost(1)=1350
     cost(2)=2250
     LevelValues(0)=1.000000
     LevelValues(1)=0.750000
     LevelValues(2)=0.500000
     LevelValues(3)=0.250000
}
