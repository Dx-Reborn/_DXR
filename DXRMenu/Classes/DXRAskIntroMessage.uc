/* Запрос вступления */

class DXRAskIntroMessage extends DXRQuitMessage;

function bool InternalOnClick(GUIComponent Sender)
{
	if(Sender==bOk)
	{
		PlayerOwner().ConsoleCommand("Open 00_Intro");
	}

  if(Sender==bCancel)
	{
		Controller.CloseMenu();
	}
	return true;
}

defaultproperties
{
    stMessage="Do you want to view intro ?"
    WinTitle="View Intro"
    stOk="Yes"
    stCancel="No"
}