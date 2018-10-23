//
// Визуальный стиль для кнопки со скошенными границами.
//

class STY_DXR_DeusExRectButton extends DXRStyles;// STY2SquareButton;

#exec OBJ LOAD FILE=GuiContent.utx
/* copy-paste template :)
function ApplyTheme(int index)
{
  FontColors[0]=class'DXR_Menu'.static.(index);
  FontColors[1]=class'DXR_Menu'.static.(index);
  FontColors[2]=class'DXR_Menu'.static.(index);
  FontColors[3]=class'DXR_Menu'.static.(index);
  FontColors[4]=class'DXR_Menu'.static.(index);

  ImgColors[0]=class'DXR_Menu'.static.(index);
  ImgColors[1]=class'DXR_Menu'.static.(index);
  ImgColors[2]=class'DXR_Menu'.static.(index);
  ImgColors[3]=class'DXR_Menu'.static.(index);
  ImgColors[4]=class'DXR_Menu'.static.(index);
}*/

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

/* Each style contains 5 values for each font, per size
      Small  0 - 4
      Medium 5 - 9
      Large 10 - 14
*/
	KeyName="STY_DXR_DeusExRectButton"
 // This array holds 1 material for each state (Blurry, Watched, Focused, Pressed, Disabled)
/*	Images(0)=Material'GuiContent.Menu.ButtonWatched'
	Images(1)=Material'GuiContent.Menu.ButtonWatched'
	Images(2)=Material'GuiContent.Menu.fbPlayerHighLight'
	Images(3)=Material'GuiContent.Menu.EditBox'
	Images(4)=Material'GuiContent.Menu.EditBoxWatched'*/
///RGB_MenuButtonLarge_Pressed
///RGB_MenuButtonLarge_Normal
///RGB_MenuButtonLarge_Focus

	imgStyle(0)=ISTY_Stretched
	imgStyle(1)=ISTY_Stretched
	imgStyle(2)=ISTY_Stretched
	imgStyle(3)=ISTY_Stretched
	imgStyle(4)=ISTY_Stretched

	Images(0)=Material'RGB_MenuButtonLarge_Normal'
	Images(1)=Material'RGB_MenuButtonLarge_Focus'
	Images(2)=Material'RGB_MenuButtonLarge_Focus'
	Images(3)=Material'RGB_MenuButtonLarge_Pressed'
	Images(4)=Material'RGB_MenuButtonLarge_Normal'


		FontColors(0)=(R=255,G=255,B=255,A=255)
    FontColors(1)=(R=255,G=255,B=255,A=255)
    FontColors(2)=(R=255,G=255,B=255,A=255)
    FontColors(3)=(R=255,G=255,B=255,A=255)
    FontColors(4)=(R=64,G=64,B=64,A=255)

    ImgColors(0)=(R=255,G=255,B=255,A=255)
    ImgColors(1)=(R=255,G=255,B=255,A=255)
    ImgColors(2)=(R=255,G=255,B=255,A=255)
    ImgColors(3)=(R=255,G=255,B=255,A=255)
    ImgColors(4)=(R=100,G=100,B=100,A=255)


/*    ImgColors(0)=(R=64,G=64,B=64,A=255)
    ImgColors(1)=(R=120,G=120,B=120,A=255)
    ImgColors(2)=(R=100,G=100,B=100,A=255)
    ImgColors(3)=(R=128,G=128,B=128,A=255)
    ImgColors(4)=(R=100,G=100,B=100,A=255)*/

		FontNames(0)="UT2MenuFont" // Мелкие
		FontNames(1)="UT2MenuFont"
		FontNames(2)="UT2MenuFont"
		FontNames(3)="UT2MenuFont"
		FontNames(4)="UT2MenuFont"
    FontNames(5)="UT2MenuFont" // Средние
    FontNames(6)="UT2MenuFont"
    FontNames(7)="UT2MenuFont"
    FontNames(8)="UT2MenuFont"
    FontNames(9)="UT2MenuFont"
    FontNames(10)="UT2MenuFont" // Большие
    FontNames(11)="UT2MenuFont"
    FontNames(12)="UT2MenuFont"
    FontNames(13)="UT2MenuFont"
    FontNames(14)="UT2MenuFont"

}
