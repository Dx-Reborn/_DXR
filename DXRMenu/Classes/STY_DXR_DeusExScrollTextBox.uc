/**/
class STY_DXR_DeusExScrollTextBox extends DXRStyles;// STY2NoBackground;


function ApplyTheme(int index)
{
  FontColors[0]=class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(Index);
  FontColors[1]=class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(Index);
  FontColors[2]=class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(Index);
  FontColors[3]=class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(Index);
  FontColors[4]=class'DXR_Menu'.static.GetPlayerInterfaceTextLabels(Index);
}


defaultproperties
{
 	KeyName="STY_DXR_DeusExScrollTextBox"

    FontNames(0)="UT2SmallFont"
    FontNames(1)="UT2SmallFont"  
    FontNames(2)="UT2SmallFont"
    FontNames(3)="UT2SmallFont"
    FontNames(4)="UT2SmallFont"
    FontNames(5)="UT2SmallFont"
    FontNames(6)="UT2SmallFont"  
    FontNames(7)="UT2SmallFont"
    FontNames(8)="UT2SmallFont"
    FontNames(9)="UT2SmallFont"
    FontNames(10)="UT2SmallFont"
    FontNames(11)="UT2SmallFont"  
    FontNames(12)="UT2SmallFont"
    FontNames(13)="UT2SmallFont"
    FontNames(14)="UT2SmallFont"

    FontColors(0)=(R=255,G=255,B=255,A=255)
    FontColors(1)=(R=255,G=255,B=255,A=255)
    FontColors(2)=(R=255,G=255,B=255,A=255)
    FontColors(3)=(R=255,G=255,B=255,A=255)
    FontColors(4)=(R=255,G=255,B=255,A=255)
}
