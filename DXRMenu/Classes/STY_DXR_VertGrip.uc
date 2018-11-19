/* ScrollBar thumb */

class STY_DXR_VertGrip extends DXRStyles;

function ApplyTheme(int index)
{
/*  ImgColors[0]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[1]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[2]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[3]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[4]=class'DXR_Menu'.static.GetScrollBarColor(Index);*/
}

function bool MyOnDraw(Canvas u, eMenuState MenuState, float left, float top, float width, float height)
{
  u.Style = RStyles[0];//EMenuRenderStyle.MSTY_Normal;
  u.DrawColor = class'DXR_Menu'.static.GetScrollBarColor(gl.MenuThemeIndex);
  u.SetPos(left + 2, top - 1);
  u.DrawTileStretched(Material'ItemNameBox',width -6,height);
//  u.DrawTileStretched(Material'ToolWindowVScrollThumb_Bottom',width ,height);
//  u.DrawTileStretched(Material'MenuVScrollThumb_Center',width,height);
//  u.DrawTile(Material'EmptySlot',width,height,0,0,width,height);

//u. DrawTile(Images[0], float XL, float YL, float U, float V, float UL, float VL ) 

  return true;
}



defaultproperties
{
    KeyName="VertGrip"
    Images(0)=none//Material'DXR_Scroll'
    Images(1)=none
    Images(2)=none
    Images(3)=none
    Images(4)=none
    ImgStyle(0)=ISTY_Tiled
    ImgStyle(1)=ISTY_Tiled
    ImgStyle(2)=ISTY_Tiled
    ImgStyle(3)=ISTY_Tiled
    ImgStyle(4)=ISTY_Tiled

    RStyles(0)=MSTY_Normal
    RStyles(1)=MSTY_None
    RStyles(2)=MSTY_None
    RStyles(3)=MSTY_None
    RStyles(4)=MSTY_None

/*    ImgWidths(0)=11
    ImgWidths(1)=11
    ImgWidths(2)=11
    ImgWidths(3)=11
    ImgWidths(4)=11
    ImgHeights(0)=19
    ImgHeights(1)=19
    ImgHeights(2)=19
    ImgHeights(3)=19
    ImgHeights(4)=19*/
    OnDraw=MyOnDraw
}
