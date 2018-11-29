/* Список сохранений */

class DXRConList extends GUI2K4MultiColumnList;

struct S_Convos
{
    var string Speaker; // Who
    var string Location; // Where
    var string type; // regular/infolink? maybe bool?
    var string Message;
};

var() array<S_Convos> ConvoHistory;
var string MySelectionStyle;
var GUIStyles SelStyle;

/*function bool InternalOnClick(GUIComponent Sender)
{
  super.InternalOnClick(Sender);

  if (DXRCustomizeKeys(PageOwner) != none)
      DXRCustomizeKeys(PageOwner).InternalOnClick(self);

  return true;
}*/

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    // set delegates
    OnDrawItem  = MyOnDrawItem;

    Super.Initcomponent(MyController, MyOwner);
    SelStyle = Controller.GetStyle(MySelectionStyle,FontScale);
}

function Clear()
{
    ConvoHistory.Remove(0,ConvoHistory.Length);
    ItemCount = 0;
    Super.Clear();
}

function MyOnDrawItem(Canvas u, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;

    // Draw the selection border
    if (bSelected)
        SelStyle.Draw(u,MSAT_Pressed, X, Y-2, W, H+2);

    GetCellLeftWidth(0, CellLeft , CellWidth);
    Style.DrawText(u, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$ConvoHistory[SortData[i].SortItem].Speaker, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    Style.DrawText(u, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$ConvoHistory[SortData[i].SortItem].Location, FontScale);

    GetCellLeftWidth(2, CellLeft, CellWidth);

    if (ConvoHistory[SortData[i].SortItem].Type == "A")
    {
      u.Font = font'FontHUDWingDings';
      u.Style = EMenuRenderStyle.MSTY_Normal;
      u.SetPos(X + CellLeft + 20, Y+1);
      u.DrawText("A");
    }
    else if (ConvoHistory[SortData[i].SortItem].Type == "B")
    {
      u.Font = font'FontHUDWingDings';
      u.Style = EMenuRenderStyle.MSTY_Normal;
      u.SetPos(X + CellLeft + 20, Y+1);
      u.DrawText("B");
    }

    //Style.DrawText(u, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$ConvoHistory[SortData[i].SortItem].Type, FontScale);

    cellSpacing = -winleft + 1;
}

function string GetSortString(int i)
{
    local string s;

    switch(SortColumn)
    {
    case 0:
        s = Left(caps(ConvoHistory[i].Speaker), 2);
        break;
    case 1:
        s = Left(caps(ConvoHistory[i].Location), 8);
        break;
    case 2:
        s = Left(caps(ConvoHistory[i].Type), 8);
        break;
    default:
        s = Left(caps(ConvoHistory[i].Speaker), 8);
        break;
    }
    return s;
}


defaultproperties
{
    MySelectionStyle="STY_DXR_ListSelection"
    ColumnHeadings(0)="Speaker"
    ColumnHeadings(1)="Location"
    ColumnHeadings(2)=""

    InitColumnPerc(0)=0.4
    InitColumnPerc(1)=0.52
    InitColumnPerc(2)=0.01

    SortColumn=1
    SortDescending=False
    ExpandLastColumn=true      // If true & columns widths do not add up to 100%, last column will be stretched

    CellSpacing=0

    FontScale=FNS_Small
}
