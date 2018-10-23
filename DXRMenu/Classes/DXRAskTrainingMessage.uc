/* Запрос тренировки */

class DXRAskTrainingMessage extends DXRQuitMessage;

function bool InternalOnClick(GUIComponent Sender)
{
	if(Sender==bOk) // Начать тренировку
	{
		PlayerOwner().ConsoleCommand("Open 00_Training");
	}

  if(Sender==bCancel)
	{
		Controller.CloseMenu();
	}
	return true;
}

/*event Opened(GUIComponent Sender)                   // Called when the Menu Owner is opened
{
  if (ParentPage != none)
  ParentPage.bVisible=false;
}

event Closed(GUIComponent Sender, bool bCancelled)  // Called when the Menu Owner is closed
{
  if (ParentPage != none)
  ParentPage.bVisible=true;
}*/

defaultproperties
{
    stMessage="Proceed to UNATCO Training Facilities?"
    WinTitle="Training"
    stOk="Yes"
    stCancel="No"
}