/* Запрос удаления сохранения */
class DXRDeleteSaveQuestion extends DXRQuitMessage;

function bool InternalOnClick(GUIComponent Sender)
{
	if(Sender==bOk) // 
	{
	  if (DXRSaveWindow(ParentPage) != none)
	  {
     DXRSaveWindow(ParentPage).DeleteSaveGame();
    }
	  if (DXRLoadWindow(ParentPage) != none)
	  {
     DXRLoadWindow(ParentPage).DeleteSaveGame();
    }
    Controller.CloseMenu();
	}
  if(Sender==bCancel)
	{
		Controller.CloseMenu();
	}
	return true;
}

event Opened(GUIComponent Sender)
{
  super.Opened(Sender);

   if (DXRLoadWindow(ParentPage) != none)
   {
     lMessage.Caption = stMessage $ DXRLoadWindow(ParentPage).lSaveList.aList.SaveData[DXRLoadWindow(ParentPage).lSaveList.aList.CurrentListId()].SaveName;
     lMessage.Caption @= DXRLoadWindow(ParentPage).lSaveList.aList.SaveData[DXRLoadWindow(ParentPage).lSaveList.aList.CurrentListId()].SaveDate;
   }

   if (DXRSaveWindow(ParentPage) != none)
   {
     lMessage.Caption = stMessage $ DXRSaveWindow(ParentPage).lSaveList.aList.SaveData[DXRSaveWindow(ParentPage).lSaveList.aList.CurrentListId()].SaveName;
     lMessage.Caption @= DXRSaveWindow(ParentPage).lSaveList.aList.SaveData[DXRSaveWindow(ParentPage).lSaveList.aList.CurrentListId()].SaveDate;
   }
}


defaultproperties
{
    openSound=sound'DeusExSounds.UserInterface.Menu_Activate'

    stMessage="Are you sure you want to delete this savegame?|"
    WinTitle="Really delete savegame?"
    stOk="Yes"
    stCancel="No"
}