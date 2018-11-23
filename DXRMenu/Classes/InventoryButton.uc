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


function SetCursorPos(float newX, float newY)
{
   PlayerOwner().ConsoleCommand("SETMOUSE" @ NewX @ NewY);
}

function ConvertCoordinates(GUIComponent fromWin, float fromX, float fromY, GUIComponent toWin, out float toX, out float toY)
{
 toX = toWin.ActualLeft();// fromX;
 toY = toWin.ActualTop();// fromY;
}

defaultproperties
{
	bMouseOverSound=false
	OnClickSound=CS_None
   bNeverScale=true
}