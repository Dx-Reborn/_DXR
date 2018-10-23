/* Класс списка навыков */
class DXRSkillsList extends GUI2K4MultiColumnList;

struct sSkill
{
    var() string SkillName;  // Навык
    var() string SkillDesc;
    var() material SkillIcon;
    var() string currentLevel; // Текущий (Новичок, Тренированный и т.д.)
    var() int NextLevel; // Сколько очков до след. уровня.
    var() object UserObject;
};

var() array<sSkill> SkillData;
var GUIStyles SelStyle;
var string current;
var DXRNewGame ng;

function bool InternalOnClick(GUIComponent Sender)
{
  super.InternalOnClick(Sender);

  if (DXRNewGame(PageOwner) != none)
    {
      DXRNewGame(PageOwner).InternalOnClick(self);
    }
  return true;
}


/*function object GetUserObject()
{

}*/
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    // set delegates
    OnDrawItem  = MyOnDrawItem;

    Super.Initcomponent(MyController, MyOwner);

    SelStyle = Controller.GetStyle("STY_DXR_ConChoice",FontScale);
//    ng = DXRNewGame(PageOwner);
}

function FillData()
{
	local int skillIndex;
//	local int rowIndex;

	Clear();
	skillIndex = 0;

	// Iterate through the skills, adding them to our list
	while(ng.localSkills[skillIndex] != None)
	{
    SkillData.Length++;
 		skillIndex++;
	  SkillData[skillIndex].SkillName = (ng.localSkills[skillIndex].SkillName);
	  SkillData[skillIndex].SkillDesc = (ng.localSkills[skillIndex].Description);
	  SkillData[skillIndex].SkillIcon = (ng.localSkills[skillIndex].SkillIcon);
	  SkillData[skillIndex].UserObject = (ng.localSkills[skillIndex]);
/*		rowIndex = lstSkills.AddRow(BuildSkillString(localSkills[skillIndex]));
		lstSkills.SetRowClientObject(rowIndex, localSkills[skillIndex]);*/
    AddedItem();
	}

}

function Clear()
{
    SkillData.Remove(0,SkillData.Length);
    ItemCount = 0;
    Super.Clear();
}

function MyOnDrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;

    // Draw the selection border
    if( bSelected )
        SelStyle.Draw(Canvas,MSAT_Pressed, X, Y-2, W, H+2 );

    GetCellLeftWidth(0, CellLeft , CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$SkillData[SortData[i].SortItem].SkillName, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$SkillData[SortData[i].SortItem].currentLevel, FontScale);

    GetCellLeftWidth(2, CellLeft, CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$SkillData[SortData[i].SortItem].NextLevel, FontScale);
}

function string GetSortString(int i)
{
    local string s;

    switch( SortColumn )
    {
    case 0:
        s = Left(caps(SkillData[i].SkillName), 2);
        break;
    case 1:
        s = Left(caps(SkillData[i].currentLevel), 2);
        break;
    default:
        s = Left(caps(SkillData[i].NextLevel), 2);
        break;
    }
    return s;
}


defaultproperties
{
    ColumnHeadings(0)="Skill Points"
    ColumnHeadings(1)="Skill Level"
    ColumnHeadings(2)="Points Needed"

    InitColumnPerc(0)=0.70
    InitColumnPerc(1)=0.15
    InitColumnPerc(2)=0.15

    SortColumn=0
    SortDescending=False
    ExpandLastColumn=false      // If true & columns widths do not add up to 100%, last column will be stretched

    CellSpacing=0 //1.5
}
