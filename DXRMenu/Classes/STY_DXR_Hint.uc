/*
   Визуальный стиль для всплывающих подсказок
*/

class STY_DXR_Hint extends DXRStyles;// STY2MouseOverLabel;

function ApplyTheme(int index)
{
FontColors[0]=class'DXR_Menu'.static.GetHintText(index);
FontColors[1]=class'DXR_Menu'.static.GetHintText(index);
FontColors[2]=class'DXR_Menu'.static.GetHintText(index);
FontColors[3]=class'DXR_Menu'.static.GetHintText(index);
FontColors[4]=class'DXR_Menu'.static.GetHintText(index);

ImgColors[0]=class'DXR_Menu'.static.GetHintBG(index);
ImgColors[1]=class'DXR_Menu'.static.GetHintBG(index);
ImgColors[2]=class'DXR_Menu'.static.GetHintBG(index);
ImgColors[3]=class'DXR_Menu'.static.GetHintBG(index);
ImgColors[4]=class'DXR_Menu'.static.GetHintBG(index);
}


defaultproperties
{
	KeyName="MouseOver"

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

	Images(0)=Material'ItemNameBox'
	Images(1)=Material'ItemNameBox'
	Images(2)=Material'ItemNameBox'
	Images(3)=Material'ItemNameBox'
	Images(4)=Material'ItemNameBox'

	ImgColors(0)=(R=192,G=192,B=192,A=128)
	ImgColors(1)=(R=192,G=192,B=192,A=128)
	ImgColors(2)=(R=192,G=192,B=192,A=128)
	ImgColors(3)=(R=192,G=192,B=192,A=128)
	ImgColors(4)=(R=192,G=192,B=192,A=128)

  BorderOffsets(0)=5
  BorderOffsets(1)=5
  BorderOffsets(2)=5
  BorderOffsets(3)=5
}