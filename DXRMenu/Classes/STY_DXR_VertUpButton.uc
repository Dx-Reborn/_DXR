/* Стиль для кнопки прокрутки "Вверх" */
class STY_DXR_VertUpButton extends DXRStyles;// GUI2Styles;

#exec obj load file=DeusExUI.u



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
    KeyName="VertUpButton"
    Images(0)=Texture'DeusExUI.UserInterface.MenuVScrollUpButton_Normal'
    Images(1)=Texture'DeusExUI.UserInterface.MenuVScrollUpButton_Normal'
    Images(2)=Texture'DeusExUI.UserInterface.MenuVScrollUpButton_Normal'
    Images(3)=Texture'DeusExUI.UserInterface.MenuVScrollUpButton_Pressed'
    Images(4)=Texture'DeusExUI.UserInterface.MenuVScrollUpButton_Normal'

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