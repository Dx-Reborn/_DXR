//
// Ќовый визуальный стиль из-за одной текстовой метки! ƒа вы издеваетесь!
//

class STY_DXR_Conlabel extends DXRStyles;// STY2SquareButton;

defaultproperties
{
	KeyName="STY_DXR_ConLabel"

	Images(0)=texture'Solid' // не в фокусе
	Images(1)=texture'Solid' //?
	Images(2)=texture'Solid' // курсор над (в фокусе)
	Images(3)=texture'Solid' // нажато
	Images(4)=texture'Solid' // недоступно

  FontColors(0)=(R=255,G=255,B=255,A=255)
  FontColors(1)=(R=255,G=255,B=255,A=255)
	FontColors(2)=(R=255,G=255,B=255,A=255)
  FontColors(3)=(R=255,G=255,B=255,A=255)
  FontColors(4)=(R=255,G=255,B=255,A=255)

/*  ImgColors(0)=(R=0,G=0,B=0,A=200)
  ImgColors(1)=(R=0,G=0,B=0,A=200)
  ImgColors(2)=(R=0,G=0,B=255,A=200)
  ImgColors(3)=(R=0,G=0,B=255,A=200)
  ImgColors(4)=(R=0,G=0,B=0,A=255)*/

  RStyles(0)=MSTY_Normal
  RStyles(1)=MSTY_Normal
  RStyles(2)=MSTY_Normal
  RStyles(3)=MSTY_Normal
  RStyles(4)=MSTY_Normal

/*  FontBKColors(0)=(R=0,G=0,B=0,A=200)
  FontBKColors(1)=(R=0,G=0,B=0,A=200)
  FontBKColors(2)=(R=0,G=0,B=0,A=200)
  FontBKColors(3)=(R=0,G=0,B=0,A=200)
  FontBKColors(4)=(R=0,G=0,B=0,A=200)
*/
}
