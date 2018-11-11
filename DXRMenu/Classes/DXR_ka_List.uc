/* Список сохранений */

class DXR_ka_List extends GUI2K4MultiColumnList;

struct S_Keys
{
    var string action;
    var string key;
};

var() array<S_Keys> Keys;
var string MySelectionStyle;
var GUIStyles SelStyle;

function bool InternalOnClick(GUIComponent Sender)
{
  super.InternalOnClick(Sender);

  if (DXRCustomizeKeys(PageOwner) != none)
      DXRCustomizeKeys(PageOwner).InternalOnClick(self);

  return true;
}

function bool MyOnDblClick(GUIComponent Sender)      // The mouse was double-clicked on this control
{
//  log("dblClick!");
  if (DXRCustomizeKeys(PageOwner) != none)
      DXRCustomizeKeys(PageOwner).ListDoubleClick(self);

  return true;
}

function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
	local Interactions.EInputKey iKey;

	iKey = EInputKey(Key);

	if ((ikey == IK_ENTER) && (DXRCustomizeKeys(PageOwner) != none) && (DXRCustomizeKeys(PageOwner).bWaitingForInput))
	{
  if (DXRCustomizeKeys(PageOwner) != none)
      DXRCustomizeKeys(PageOwner).ListDoubleClick(self); // Переслать "двойной клик" в окно
		return true;
	}
	else
  if (DXRCustomizeKeys(PageOwner) != none)
      DXRCustomizeKeys(PageOwner).InternalOnKeyEvent(Key, State, delta); // Переслать в окно

 return false;
}



function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
    // set delegates
    OnDrawItem  = MyOnDrawItem;

    Super.Initcomponent(MyController, MyOwner);
    SelStyle = Controller.GetStyle(MySelectionStyle,FontScale);
}

function Clear()
{
    Keys.Remove(0,Keys.Length);
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
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$Keys[SortData[i].SortItem].action, FontScale);

    GetCellLeftWidth(1, CellLeft, CellWidth);
    Style.DrawText(Canvas, MenuState, X+CellLeft, Y, CellWidth, H, TXTA_Left, ""$Keys[SortData[i].SortItem].key, FontScale);

        cellSpacing = -winleft + 1;
}

function string GetSortString(int i)
{
    local string s;

    switch( SortColumn )
    {
    case 0:
        s = Left(caps(Keys[i].key), 2);
        break;
    case 1:
        s = Left(caps(Keys[i].action), 8);
        break;
    default:
        s = Left(caps(Keys[i].key), 8);
        break;
    }
    return s;
}


defaultproperties
{
    MySelectionStyle="STY_DXR_ListSelection"
    ColumnHeadings(0)="Action"
    ColumnHeadings(1)="Assigned Key/Button"

    InitColumnPerc(0)=0.430000
    InitColumnPerc(1)=0.57

    OnDblClick=MyOnDblClick

    SortColumn=1
    SortDescending=False
    ExpandLastColumn=false      // If true & columns widths do not add up to 100%, last column will be stretched

    CellSpacing=0

  FontScale=FNS_Small
}
