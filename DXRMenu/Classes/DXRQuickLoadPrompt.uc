/*
   Запрос выхода в Главное Меню 
*/

class DXRQuickLoadPrompt extends DXRQuitMessage;


function bool InternalOnClick(GUIComponent Sender)
{
    if(Sender == bOk)
    {
        PrepareToDxOnly(); 
        DeusExPlayerController(PlayerOwner()).ReallyQuickLoad();
    }

    if(Sender == bCancel)
    {
        Controller.CloseMenu();
    }
    return false;
}

function PrepareToDxOnly()
{
    gl.resetAll(); // Обнулить сохраняемые данные в DeusExGlobals.
    DeusExGameInfo(PlayerOwner().level.game).DeleteAlmostAllFlags(); // 
}

defaultproperties
{
    openSound=sound'DeusExSounds.UserInterface.Menu_Activate'

    stMessage="Do you want to load QuickSave?"
    WinTitle="Load saved game?"
    stOk="Yes"
    stCancel="No"
}