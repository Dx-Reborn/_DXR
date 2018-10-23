/* ScrollBar thumb */

class STY_DXR_VertGrip extends DXRStyles;// GUI2Styles;



function ApplyTheme(int index)
{
  ImgColors[0]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[1]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[2]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[3]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[4]=class'DXR_Menu'.static.GetScrollBarColor(Index);
}


    
//    ScrollBarButtonsColor=(R=255,G=255,B=255,A=255)


defaultproperties
{
    KeyName="VertGrip"
    Images(0)=Material'DXR_Scroll'
    Images(1)=Material'DXR_Scroll'
    Images(2)=Material'DXR_Scroll'
    Images(3)=Material'DXR_Scroll'
    Images(4)=Material'DXR_Scroll'
    ImgStyle(0)=ISTY_Tiled//Stretched
    ImgStyle(1)=ISTY_Tiled//Stretched
    ImgStyle(2)=ISTY_Tiled//Stretched
    ImgStyle(3)=ISTY_Tiled//Stretched
    ImgStyle(4)=ISTY_Tiled//Stretched
    ImgWidths(0)=11
    ImgWidths(1)=11
    ImgWidths(2)=11
    ImgWidths(3)=11
    ImgWidths(4)=11
    ImgHeights(0)=19
    ImgHeights(1)=19
    ImgHeights(2)=19
    ImgHeights(3)=19
    ImgHeights(4)=19

}
