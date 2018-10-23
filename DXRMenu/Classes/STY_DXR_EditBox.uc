/* */

class STY_DXR_EditBox extends DXRStyles;//STY2EditBox;

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
 	KeyName="STY_DXR_EditBox"
	Images(0)=Material'DXR_MenuInfoButton'
	Images(1)=Material'DXR_MenuInfoButton'
	Images(2)=Material'DXR_MenuInfoButton'
	Images(3)=Material'DXR_MenuInfoButton'
	Images(4)=Material'DXR_MenuInfoButton'

  ImgColors(0)=(r=228,g=228,b=228,a=255)
  ImgColors(1)=(r=255,g=255,b=255,a=255)
  ImgColors(2)=(r=255,g=255,b=255,a=255)
  ImgColors(3)=(r=255,g=255,b=255,a=255)
  ImgColors(4)=(r=128,g=128,b=128,a=255)

	FontColors(0)=(R=255,g=255,b=255,A=180)
	FontColors(1)=(R=255,g=255,b=255,A=255)
	FontColors(2)=(R=255,g=255,b=255,A=255)
	FontColors(3)=(R=255,g=255,b=255,A=255)
	FontColors(4)=(R=200,G=200,B=200,A=180)

	BorderOffsets(0)=5
}