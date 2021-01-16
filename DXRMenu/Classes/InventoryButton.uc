/* */
class InventoryButton extends GUICheckBoxButton; //GUIButton;

var gui_Inventory winInv;       // Pointer back to the inventory window
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
function SetSensitivity(bool newSensitivity);


function SetCursorPos(float newX, float newY)
{
   PlayerOwner().ConsoleCommand("SETMOUSE" @ NewX @ NewY);
}

function AssignWinInv(gui_Inventory newWinInventory)
{
    winInv = newWinInventory;
}

// Pointless?
function ConvertCoordinates(GUIComponent fromWin, float fromX, float fromY, GUIComponent toWin, out float toX, out float toY)
{
   toX = toWin.winLeft; //ActualLeft();// fromX;
   toY = toWin.winTop;//ActualTop();// fromY;
}

defaultproperties
{
    bMouseOverSound=false
    OnClickSound=CS_None
    bNeverScale=true
}

