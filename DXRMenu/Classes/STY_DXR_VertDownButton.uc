/* Стиль для кнопки прокрутки "Вниз" */

#exec obj load file=DeusExUI.u

class STY_DXR_VertDownButton extends DXRStyles;// GUI2Styles;



function ApplyTheme(int index)
{
  ImgColors[0]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[1]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[2]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[3]=class'DXR_Menu'.static.GetScrollBarColor(Index);
  ImgColors[4]=class'DXR_Menu'.static.GetScrollBarColor(Index);
}



defaultproperties
{
    KeyName="VertDownButton"
    Images(0)=Texture'DeusExUI.UserInterface.MenuVScrollDownButton_Normal'
    Images(1)=Texture'DeusExUI.UserInterface.MenuVScrollDownButton_Normal'
    Images(2)=Texture'DeusExUI.UserInterface.MenuVScrollDownButton_Normal'
    Images(3)=Texture'DeusExUI.UserInterface.MenuVScrollDownButton_Pressed'
    Images(4)=Texture'DeusExUI.UserInterface.MenuVScrollDownButton_Normal'

    imgStyle(0)=ISTY_Scaled
    imgStyle(1)=ISTY_Scaled
    imgStyle(2)=ISTY_Scaled
    imgStyle(3)=ISTY_Scaled
    imgStyle(4)=ISTY_Scaled

    BorderOffsets(0)=0
    BorderOffsets(1)=0
    BorderOffsets(2)=0
    BorderOffsets(3)=0

}