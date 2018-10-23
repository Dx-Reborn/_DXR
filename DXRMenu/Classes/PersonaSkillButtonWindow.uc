/*
   Наверное стоит просто нарисовать всё нужное через Canvas,
   поскольку есть только два пункта:
   * Если эта кнопка-элемент списка выделена, то задействовать кнопку повышения навыка.
   * Отображает иконку, текст и уровень навыка (четыре квадратика).

   Размеры можно сразу задать заранее и потом исходить из них.
   Что-то можно дорисовать через стиль, или перехватить всё на себя...

   Значок > Название > Обучен_и_тд #### > требуется_единиц
*/
class PersonaSkillButtonWindow extends GUIButton;

const levelSQ = texture'PersonaSkillsChicklet';

var() Skill skill; // Указатель на определенный навык.
var localized string NotAvailableLabel;

/*
  UCanvas постоянно обновляется, поэтому
  нет необходимости использовать функции
  обновления, нужно лишь передать указатель
  на Skill.
*/
function InternalOnRendered(Canvas C)
{
  local float x, y;

  x = ActualLeft(); // Позиция рисования относительно себя
  y = ActualTop();
// Чтобы не было спама на случай none
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
  WinLeft=200 // x можно задать заранее, y придется добавлять.
  OnRendered=InternalOnRendered
  StyleName="STY_DXR_ButtonNavbar"
  bMouseOverSound=false
}