/**/
class EmailList extends GUI2K4MultiColumnList;

struct eMailStruct
{
    var() string Title;
    var() string From;
    var() string to;
    var() string cc;
    var() array<string> text;
};
var() array<eMailStruct> myMailList;

var editconst string MySelectionStyle;
var GUIStyles SelStyle;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    // set delegates
    OnDrawItem = MyOnDrawItem;

    OnChange = MyOnChange;

    Super.Initcomponent(MyController, MyOwner);
    SelStyle = Controller.GetStyle(MySelectionStyle,FontScale);
}

function Clear()
{
    myMailList.Remove(0,myMailList.Length);
    ItemCount = 0;
    Super.Clear();
}

function MyOnChange(GUIComponent Sender)
{
  if ((Sender==Self) && (ComputerScreenEmail(PageOwner) != none) && (ItemCount > 0))
      ComputerScreenEmail(PageOwner).EmailListChanged(self);
}


function MyOnDrawItem(Canvas Canvas, int i, float X, float Y, float W, float H, bool bSelected, bool bPending)
{
    local float CellLeft, CellWidth;

    // Draw the selection border
    if(bSelected)
        SelStyle.Draw(Canvas,MSAT_Pressed, X, Y-2, W, H+2 );

    GetCellLeftWidth(0, CellLeft , CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$myMailList[SortData[i].SortItem].Title, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$myMailList[SortData[i].SortItem].From, FontScale);

    cellSpacing = -winleft + 1;
}

function string GetSortString(int i)
{
    local string s;

    switch( SortColumn )
    {
    case 0:
        s = Left(caps(myMailList[i].Title), 2);
        break;
    case 1:
        s = Left(caps(myMailList[i].From), 8);
        break;
    default:
        s = Left(caps(myMailList[i].Title), 8);
        break;
    }
    return s;
}




defaultproperties
{
    MySelectionStyle="STY_DXR_ListSelection"
    ColumnHeadings(0)="Title"
    ColumnHeadings(1)="From"
    InitColumnPerc(0)=0.40
    InitColumnPerc(1)=0.60
    SortColumn=1
    SortDescending=false
    ExpandLastColumn=false      // If true & columns widths do not add up to 100%, last column will be stretched
    CellSpacing=0
}