/**/
class STY_DXR_ButtonNavbar extends DXRStyles;//GUIStyles;

function ApplyTheme(int index)
{
  ImgColors[0]=class'DXR_Menu'.static.GetPlayerInterfaceButton(index);
  ImgColors[1]=class'DXR_Menu'.static.GetPlayerInterfaceButtonWatched(index);
  ImgColors[2]=class'DXR_Menu'.static.GetPlayerInterfaceButtonFocused(index);
  ImgColors[3]=class'DXR_Menu'.static.GetPlayerInterfaceButtonPressed(index);
  ImgColors[4]=class'DXR_Menu'.static.GetPlayerInterfaceButtonDisabled(index);

  FontColors[0]=class'DXR_Menu'.static.GetPlayerInterfaceButtonText(index);
  FontColors[1]=class'DXR_Menu'.static.GetPlayerInterfaceButtonWatchedText(index);
  FontColors[2]=class'DXR_Menu'.static.GetPlayerInterfaceButtonFocusedText(index);
  FontColors[3]=class'DXR_Menu'.static.GetPlayerInterfaceButtonPressedText(index);
  FontColors[4]=class'DXR_Menu'.static.GetPlayerInterfaceButtonDisabledText(index);
}

defaultproperties
{
	KeyName="STY_DXR_ButtonNavbar"

	FontNames(0)="UT2HeaderFont"
	FontNames(1)="UT2HeaderFont"
	FontNames(2)="UT2HeaderFont"
	FontNames(3)="UT2HeaderFont"
	FontNames(4)="UT2HeaderFont"
	FontNames(5)="UT2HeaderFont"
	FontNames(6)="UT2HeaderFont"
	FontNames(7)="UT2HeaderFont"
	FontNames(8)="UT2HeaderFont"
	FontNames(9)="UT2HeaderFont"
	FontNames(10)="UT2HeaderFont"
	FontNames(11)="UT2HeaderFont"
	FontNames(12)="UT2HeaderFont"
	FontNames(13)="UT2HeaderFont"
	FontNames(14)="UT2HeaderFont"

	RStyles(0)=MSTY_Normal
	RStyles(1)=MSTY_Normal
	RStyles(2)=MSTY_Normal
	RStyles(3)=MSTY_Normal
	RStyles(4)=MSTY_Normal

		FontColors(0)=(R=211,G=211,B=211,A=255)
    FontColors(1)=(R=255,G=255,B=255,A=255)
    FontColors(2)=(R=225,G=225,B=225,A=255)
    FontColors(3)=(R=255,G=255,B=255,A=255)
    FontColors(4)=(R=164,G=164,B=164,A=255)

    ImgColors(0)=(R=225,G=225,B=225,A=255)
    ImgColors(1)=(R=225,G=225,B=225,A=255)
    ImgColors(2)=(R=255,G=255,B=255,A=255)
    ImgColors(3)=(R=255,G=255,B=255,A=255)
    ImgColors(4)=(R=255,G=255,B=255,A=255)

    BorderOffsets(0)=0
    BorderOffsets(1)=2
    BorderOffsets(2)=0
    BorderOffsets(3)=0

	imgStyle(0)=ISTY_Stretched
	imgStyle(1)=ISTY_Stretched
	imgStyle(2)=ISTY_Stretched
	imgStyle(3)=ISTY_Stretched
	imgStyle(4)=ISTY_Stretched

	Images(0)=Material'DXR_PersonaButton'
	Images(1)=Material'DXR_PersonaButton'
	Images(2)=Material'DXR_PersonaButton'
	Images(3)=Material'DXR_PersonaButton'
	Images(4)=Material'DXR_PersonaButton'

}

