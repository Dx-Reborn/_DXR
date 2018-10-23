/* */
class InventoryButton extends GUIButton;

var() transient editconst Object clientObject;
var DeusExGlobals gl;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.Initcomponent(MyController, MyOwner);
  gl = class'DeusExGlobals'.static.GetGlobals();
}

final function SetClientObject(object newClientObject)
{
   clientObject = newClientObject;
}

final function object GetClientObject()
{
   return clientObject;
}

function SetSize(float newWidth, float newHeight)
{
   WinHeight = newHeight; WinWidth = newWidth;
}

function SetPos(float newX, float newY);

defaultproperties
{
	bMouseOverSound=false
	OnClickSound=CS_None
   bNeverScale=true
}