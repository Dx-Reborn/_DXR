/* Клавиша кодового замка */

class HUDKeypadButton extends GUIDXRButton; //GUIButton;

var int num;	// what number should I be?

defaultproperties
{
   winHeight=25
   winWidth=27
   bBoundToParent=true
   bMouseOverSound=false
   OnClickSound=CS_None
   bAutoShrink=false
}
