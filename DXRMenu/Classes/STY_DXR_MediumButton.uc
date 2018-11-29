//
// Уменьшенная версия кнопки
//

class STY_DXR_MediumButton extends DXRStyles;

#exec OBJ LOAD FILE=GuiContent.utx

function ApplyTheme(int index)
{
  ImgColors[0]=class'DXR_Menu'.static.GetMenuButton(index);
  ImgColors[1]=class'DXR_Menu'.static.GetMenuButtonWatched(index);
  ImgColors[2]=class'DXR_Menu'.static.GetMenuButtonButtonFocused(index);
  ImgColors[3]=class'DXR_Menu'.static.GetMenuButtonPressed(index);
  ImgColors[4]=class'DXR_Menu'.static.GetMenuButtonDisabled(index);

  FontColors[0]=class'DXR_Menu'.static.GetMenuButtonText(index);
  FontColors[1]=class'DXR_Menu'.static.GetMenuButtonWatchedText(index);
  FontColors[2]=class'DXR_Menu'.static.GetMenuButtonButtonFocusedText(index);
  FontColors[3]=class'DXR_Menu'.static.GetMenuButtonPressedText(index);
  FontColors[4]=class'DXR_Menu'.static.GetMenuButtonDisabledText(index);
}


defaultproperties
{
	KeyName="STY_DXR_MediumButton"
 // This array holds 1 material for each state (Blurry, Watched, Focused, Pressed, Disabled)
/*	Images(0)=Material'GuiContent.Menu.ButtonWatched'
	Images(1)=Material'GuiContent.Menu.ButtonWatched'
	Images(2)=Material'GuiContent.Menu.fbPlayerHighLight'
	Images(3)=Material'GuiContent.Menu.EditBox'
	Images(4)=Material'GuiContent.Menu.EditBoxWatched'*/

	BorderOffsets(1)=0
	BorderOffsets(3)=0//10

	imgStyle(0)=ISTY_Stretched //Scaled
	imgStyle(1)=ISTY_Stretched
	imgStyle(2)=ISTY_Stretched
	imgStyle(3)=ISTY_Stretched
	imgStyle(4)=ISTY_Stretched

/*	Images(0)=Material'RGB_MenuButtonSmall_Normal'
	Images(1)=Material'RGB_MenuButtonSmall_Normal'
	Images(2)=Material'RGB_MenuButtonSmall_Normal'
	Images(3)=Material'RGB_MenuButtonSmall_Pressed'
	Images(4)=Material'RGB_MenuButtonSmall_Normal'*/

	Images(0)=Material'DXR_MediumButton_Normal'
	Images(1)=Material'DXR_MediumButton_Normal'
	Images(2)=Material'DXR_MediumButton_Normal'
	Images(3)=Material'DXR_MediumButton_Pressed'
	Images(4)=Material'DXR_MediumButton_Normal'



		FontColors(0)=(R=211,G=211,B=211,A=255)
    FontColors(1)=(R=255,G=255,B=255,A=255)
    FontColors(2)=(R=255,G=255,B=255,A=255)
    FontColors(3)=(R=100,G=100,B=100,A=255)
    FontColors(4)=(R=64,G=64,B=64,A=255)

    ImgColors(0)=(R=225,G=225,B=225,A=255)
    ImgColors(1)=(R=225,G=225,B=225,A=255)
    ImgColors(2)=(R=255,G=255,B=255,A=255)
    ImgColors(3)=(R=255,G=255,B=255,A=255)
    ImgColors(4)=(R=100,G=100,B=100,A=255)

		FontNames(0)="UT2HeaderFont" // Мелкие
		FontNames(1)="UT2HeaderFont"
		FontNames(2)="UT2HeaderFont"
		FontNames(3)="UT2HeaderFont"
		FontNames(4)="UT2HeaderFont"
    FontNames(5)="UT2HeaderFont" // Средние
    FontNames(6)="UT2HeaderFont"
    FontNames(7)="UT2HeaderFont"
    FontNames(8)="UT2HeaderFont"
    FontNames(9)="UT2HeaderFont"
    FontNames(10)="UT2HeaderFont" // Большие
    FontNames(11)="UT2HeaderFont"
    FontNames(12)="UT2HeaderFont"
    FontNames(13)="UT2HeaderFont"
    FontNames(14)="UT2HeaderFont"


}
