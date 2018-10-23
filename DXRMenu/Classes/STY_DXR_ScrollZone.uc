/*---------------------------------------------------------------------

---------------------------------------------------------------------*/

class STY_DXR_ScrollZone extends DXRStyles;// GUIStyles;


function ApplyTheme(int index)
{
  ImgColors[0]=class'DXR_Menu'.static.GetScrollBarArea(Index);
  ImgColors[1]=class'DXR_Menu'.static.GetScrollBarArea(Index);
  ImgColors[2]=class'DXR_Menu'.static.GetScrollBarArea(Index);
  ImgColors[3]=class'DXR_Menu'.static.GetScrollBarArea(Index);
  ImgColors[4]=class'DXR_Menu'.static.GetScrollBarArea(Index);
}


    
//    ScrollBarButtonsColor=(R=255,G=255,B=255,A=255)


defaultproperties
{
	KeyName="ScrollZone"
	Images(0)=Material'DeusExUI.UserInterface.MenuVScrollScale'
	Images(1)=Material'DeusExUI.UserInterface.MenuVScrollScale'
	Images(2)=Material'DeusExUI.UserInterface.MenuVScrollScale'
	Images(3)=Material'DeusExUI.UserInterface.MenuVScrollScale'

/*	Images(0)=Material'Solid'
	Images(1)=Material'Solid'
	Images(2)=Material'Solid'
	Images(3)=Material'Solid'*/
//	FontColors(0)=(R=255,G=255,B=255,A=255)	
//	FontColors(3)=(R=255,G=255,B=255,A=255)	

}
