/*
   �������� ����� ������ ���������� �� ������ ����� Canvas,
   ��������� ���� ������ ��� ������:
   * ���� ��� ������-������� ������ ��������, �� ������������� ������ ��������� ������.
   * ���������� ������, ����� � ������� ������ (������ ����������).

   ������� ����� ����� ������ ������� � ����� �������� �� ���.
   ���-�� ����� ���������� ����� �����, ��� ����������� �� �� ����...

   ������ > �������� > ������_�_�� #### > ���������_������
*/
class PersonaSkillButtonWindow extends GUIButton;

const levelSQ = texture'PersonaSkillsChicklet';

var() Skill skill; // ��������� �� ������������ �����.
var localized string NotAvailableLabel;

/*
  UCanvas ��������� �����������, �������
  ��� ������������� ������������ �������
  ����������, ����� ���� �������� ���������
  �� Skill.
*/
function InternalOnRendered(Canvas C)
{
  local float x, y;

  x = ActualLeft(); // ������� ��������� ������������ ����
  y = ActualTop();
// ����� �� ���� ����� �� ������ none
  if (skill != none)
  {
    c.font=font'MSS_9';

    c.setPos(x + 4, y + 4);
//    c.SetDrawColor(255,255,255,255);
    c.DrawIcon(skill.SkillIcon, 1);
//    c.DrawIcon(texture'SkillIconComputer', 1);

    c.SetPos(x + 30, y + 2);
    c.DrawText(skill.SkillName);
    //c.DrawText("Environmental training");

    c.SetPos(x + 30, y + 15);
    c.DrawText(skill.GetCurrentLevelString());
//    c.DrawText("UNTRAINED LEVEL");

    c.setPos(x + 200, y + 14);
    c.DrawIcon(levelSQ, 1);

    c.setPos(x + 206, y + 14);
      if (skill.GetCurrentLevel() >= 1)
      c.DrawIcon(levelSQ, 1);

    c.setPos(x + 212, y + 14);
      if (skill.GetCurrentLevel() >= 2)
      c.DrawIcon(levelSQ, 1);

    c.setPos(x + 218, y + 14);
      if (skill.GetCurrentLevel() >= 3)
      c.DrawIcon(levelSQ, 1);

      c.setPos(x + 256, y + 9);
      if (skill.GetCurrentLevel() == 3)
       c.DrawText(NotAvailableLabel);
        else
       c.DrawText(skill.GetCost());
//      c.DrawText(WinPointsNeeded);
//    c.DrawText("9999");
  }
}

function SetSkill(Skill newSkill)
{
	skill = newSkill;
}

function Skill GetSkill()
{
	return skill;
}




defaultProperties
{
  NotAvailableLabel="N/A"
  bBoundToParent=true
  WinHeight=32
  WinWidth=319
  WinLeft=200 // x ����� ������ �������, y �������� ���������.
  OnRendered=InternalOnRendered
  StyleName="STY_DXR_ButtonNavbar"
  bMouseOverSound=false
}