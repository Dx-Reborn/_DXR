//=============================================================================
// SkillDemolition.
//=============================================================================
class SkillDemolition extends Skill;

defaultproperties
{
     InternalSkillName="Weapons: Demolition"
     SkillName="Weapons: Demolition"
     Description="The use of thrown explosive devices, including LAMs, gas grenades, EMP grenades, and even electronic scramble grenades.||UNTRAINED: An agent can throw grenades, attach them to a surface as a proximity device, or attempt to disarm and remove a previously armed proximity device.||TRAINED: Grenade accuracy and damage increases slightly, as does the safety margin for disarming proximity devices.||ADVANCED: Grenade accuracy and damage increases moderately, as does the safety margin for disarming proximity devices.||MASTER: An agent is an expert at all forms of demolition."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconDemolition'
     cost(0)=900
     cost(1)=1800
     cost(2)=3000
     LevelValues(1)=-0.100000
     LevelValues(2)=-0.250000
     LevelValues(3)=-0.500000
}
