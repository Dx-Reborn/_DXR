//
//
//

class STY_DXR_DXWinHeader extends DXRStyles;// STY2Footer;

function ApplyTheme(int index)
{
  ImgColors[0]=class'DXR_Menu'.static.GetMenuHeader(Index);
  ImgColors[1]=class'DXR_Menu'.static.GetMenuHeader(Index);
  ImgColors[2]=class'DXR_Menu'.static.GetMenuHeader(Index);
  ImgColors[3]=class'DXR_Menu'.static.GetMenuHeader(Index);
  ImgColors[4]=class'DXR_Menu'.static.GetMenuHeader(Index);
}


defaultproperties
{
    KeyName="STY_DXR_DXWinHeader"

    RStyles(0)=MSTY_Normal
    RStyles(1)=MSTY_Normal
    RStyles(2)=MSTY_Normal
    RStyles(3)=MSTY_Normal
    RStyles(4)=MSTY_Normal

    ImgStyle(0)=ISTY_Stretched
    ImgStyle(1)=ISTY_Stretched
    ImgStyle(2)=ISTY_Stretched
    ImgStyle(3)=ISTY_Stretched
    ImgStyle(4)=ISTY_Stretched

    ImgColors(0)=(R=255,G=255,B=255,A=255)
    ImgColors(1)=(R=255,G=255,B=255,A=255)
    ImgColors(2)=(R=255,G=255,B=255,A=255)
    ImgColors(3)=(R=255,G=255,B=255,A=255)
    ImgColors(4)=(R=255,G=255,B=255,A=255)

    FontColors(0)=(R=255,G=255,B=255,A=255)
    FontColors(1)=(R=255,G=255,B=255,A=255)
    FontColors(2)=(R=255,G=255,B=255,A=255)
    FontColors(3)=(R=255,G=255,B=255,A=255)
    FontColors(4)=(R=133,G=133,B=133,A=255)

/*		FontNames(0)="UT2DefaultFont"
		FontNames(1)="UT2DefaultFont"
		FontNames(2)="UT2DefaultFont"
		FontNames(3)="UT2DefaultFont"
		FontNames(4)="UT2DefaultFont"*/  

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

/*    Images(0)=Material'RGB_MenuTitleBar'
    Images(1)=Material'RGB_MenuTitleBar'
    Images(2)=Material'RGB_MenuTitleBar'
    Images(3)=Material'RGB_MenuTitleBar'
    Images(4)=Material'RGB_MenuTitleBar'*/

    Images(0)=Material'DX_WinHeader'
    Images(1)=Material'DX_WinHeader'
    Images(2)=Material'DX_WinHeader'
    Images(3)=Material'DX_WinHeader'
    Images(4)=Material'DX_WinHeader'


		BorderOffsets(0)=5
		BorderOffsets(1)=-103
	 	BorderOffsets(2)=0
		BorderOffsets(3)=0
}
