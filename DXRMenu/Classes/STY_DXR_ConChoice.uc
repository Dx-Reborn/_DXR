//
//
//

class STY_DXR_ConChoice extends DXRStyles;// STY2SquareButton;

defaultproperties
{
	KeyName="STY_DXR_ConChoice"

	Images(0)=texture'ItemNameBox' // не в фокусе
	Images(1)=texture'ItemNameBox' //?
	Images(2)=texture'ItemNameBox' // курсор над (в фокусе)
	Images(3)=texture'ItemNameBox' // нажато
	Images(4)=texture'ItemNameBox' // недоступно

  FontColors(0)=(R=0,G=255,B=255,A=255)
  FontColors(1)=(R=0,G=255,B=0,A=255)
	FontColors(2)=(R=0,G=255,B=255,A=255)
  FontColors(3)=(R=0,G=255,B=0,A=255)
  FontColors(4)=(R=255,G=255,B=255,A=255)

  ImgColors(0)=(R=0,G=0,B=0,A=200)
  ImgColors(1)=(R=0,G=0,B=0,A=200)
  ImgColors(2)=(R=0,G=255,B=255,A=255)
  ImgColors(3)=(R=0,G=0,B=255,A=255)
  ImgColors(4)=(R=0,G=0,B=0,A=255)

  RStyles(0)=MSTY_Normal//Translucent
  RStyles(1)=MSTY_Normal//Translucent
  RStyles(2)=MSTY_Normal//Translucent
  RStyles(3)=MSTY_Normal//Translucent
  RStyles(4)=MSTY_Alpha

/*  FontBKColors(0)=(R=0,G=0,B=0,A=200)
  FontBKColors(1)=(R=0,G=0,B=0,A=200)
  FontBKColors(2)=(R=0,G=0,B=0,A=200)
  FontBKColors(3)=(R=0,G=0,B=0,A=200)
  FontBKColors(4)=(R=0,G=0,B=0,A=200)
*/
}
