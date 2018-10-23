//
// Визуальный стиль для кнопки со скошенными границами.
//

class STY_DXR_ImgBorder extends DXRStyles;//STY2SquareButton;

#exec OBJ LOAD FILE=GuiContent.utx

defaultproperties
{

/* Each style contains 5 values for each font, per size
      Small  0 - 4
      Medium 5 - 9
      Large 10 - 14
*/
	KeyName="STY_DXR_ImgBorder"
 // This array holds 1 material for each state (Blurry, Watched, Focused, Pressed, Disabled)
/*	Images(0)=Material'GuiContent.Menu.ButtonWatched'
	Images(1)=Material'GuiContent.Menu.ButtonWatched'
	Images(2)=Material'GuiContent.Menu.fbPlayerHighLight'
	Images(3)=Material'GuiContent.Menu.EditBox'
	Images(4)=Material'GuiContent.Menu.EditBoxWatched'*/

	imgStyle(0)=ISTY_Stretched
	imgStyle(1)=ISTY_Stretched
	imgStyle(2)=ISTY_Stretched
	imgStyle(3)=ISTY_Stretched
	imgStyle(4)=ISTY_Stretched

	Images(0)=Material'GUIContent.Borders.ShadowBox'
	Images(1)=Material'GUIContent.Borders.ShadowBox'
	Images(2)=Material'GUIContent.Borders.ShadowBox'
	Images(3)=Material'GUIContent.Borders.ShadowBox'
	Images(4)=Material'GUIContent.Borders.ShadowBox'

    ImgColors(0)=(R=255,G=255,B=255,A=0)
    ImgColors(1)=(R=255,G=255,B=255,A=0)
    ImgColors(2)=(R=255,G=255,B=255,A=255)
    ImgColors(3)=(R=255,G=255,B=255,A=0)
    ImgColors(4)=(R=100,G=100,B=100,A=0)
}
