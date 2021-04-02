/*
   Контроллер интерфейса 
*/


class DeusExGUIController extends UT2K4GUIController;

#exec OBJ LOAD FILE=DeusExCursor

function ShowMouseCursor(bool bShow)
{
   if (bShow)
       MouseCursors[0] = default.MouseCursors[0]; // TexScaler(DynamicLoadObject("DeusExCursor.DeusExCursor_main_0_5", class'TexScaler', false));
   else
       MouseCursors[0] = texture'PinkMaskTex';
}

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
event object OpenMenuEx(string NewMenuName, optional string Param1, optional string Param2)
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

        return None;
    }

    NewMenu = CreateMenu(NewMenuName);
    if (NewMenu!=None)
    {
        // do not allow the same menu to be duplicated in the stack
        if (FindMenuIndex(NewMenu) != -1)
        {
            bCurMenuInitialized = True;
            return None;
        }

        NewMenu.ParentPage = ActivePage;
        ResetFocus();
        PushMenu(MenuStack.Length, NewMenu, Param1, Param2);

        if (NewMenu.bDisconnectOnOpen)
            ConsoleCommand("DISCONNECT");
        return NewMenu;
    }
    log("Could not open menu"@NewMenuName);
    return None;
}

defaultproperties
{
    /* Все курсоры уменьшены примерно в три раза */
    MouseCursors(0)=TexScaler'DeusExCursor.DeusExCursor_main_0_5' // Arrow
    MouseCursors(1)=TexScaler'DeusExCursor.ResizeAll_SC'          // SizeAll
    MouseCursors(2)=TexScaler'DeusExCursor.ResizeSWNE_SC'         // Size NE SW
    MouseCursors(3)=TexScaler'DeusExCursor.Resize_SC'             // Size NS
    MouseCursors(4)=TexScaler'DeusExCursor.ResizeNWSE_SC'         // Size NW SE
    MouseCursors(5)=TexScaler'DeusExCursor.ResizeHorz_SC'         // Size WE
}