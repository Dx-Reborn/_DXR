//
// ConChoiceWindow
//

class ConChoiceWindow extends GUIButton Transient;

var Object userObject;

//function InitWindow()
function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
		Super.InitComponent(MyController, MyOwner);
//	Super.InitWindow();
}

function SetUserObject(object newUserObject)
{
	userObject = newUserObject;
}

function Object GetUserObject()
{
	return userObject;
}

function SetText(string newtext)
{
	Caption = newText;
}

final function SetButtonTextures(optional texture normal,optional texture pressed,optional texture normalFocus,
                                 optional texture pressedFocus,optional texture normalInsensitive,optional texture pressedInsensitive);

final function SetButtonColors(optional color normal,optional color pressed,optional color normalFocus,
                                            optional color pressedFocus,optional color normalInsensitive,optional color pressedInsensitive);

final function SetTextColors(optional color normal,optional color pressed,optional color normalFocus,
                             optional color pressedFocus,optional color normalInsensitive,optional color pressedInsensitive);



defaultproperties
{

	bAutoShrink=false
	bMouseOverSound=false
	onClickSound=CS_None
	FontScale=FNS_Small
	StyleName="STY_DXR_ConChoice"
}
