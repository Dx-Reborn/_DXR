/* Контроллер интерфейса */


class DeusExGUIController extends UT2K4GUIController;

#exec OBJ LOAD FILE=DeusExCursor

static simulated function string GetQuitPage()
{
	Validate();
	return "DXRMenu.DXRQuitMessage";
}

static simulated function string GetSettingsPage()
{
	Validate();
	return "DXRMenu.DXRMenuSettings";
}

/* Возвращает указатель на меню вместо false/true */
event /*bool*/ object OpenMenuEx(string NewMenuName, optional string Param1, optional string Param2)
{
    local GUIPage NewMenu;

    // Sanity Check
	if (bModAuthor)
		log(Class@"OpenMenuEx ["$NewMenuName$"] ("$Param1$") ("$Param2$")",'ModAuthor');

	if (ActivePage != none)
	{
		if ( !ActivePage.AllowOpen(NewMenuName) )
			return none; //false;
	}

	if (!bCurMenuInitialized && MenuStack.Length > 1)
	{
		if ( bModAuthor )
			log("Cannot open menu until menu initialization is complete!",'ModAuthor');

		return none; //false;
	}

    NewMenu = CreateMenu(NewMenuName);
    if (NewMenu!=None)
    {
    	// do not allow the same menu to be duplicated in the stack
    	if (FindMenuIndex(NewMenu) != -1)
    	{
    		bCurMenuInitialized = True;
    		return none; //false;
    	}

        NewMenu.ParentPage = ActivePage;
        ResetFocus();
        PushMenu(MenuStack.Length, NewMenu, Param1, Param2);

		if (NewMenu.bDisconnectOnOpen)
			ConsoleCommand("DISCONNECT");
        return NewMenu;//true;
    }
	log("Could not open menu"@NewMenuName);
	return none; //false;
}


