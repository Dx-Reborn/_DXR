/* Запрос выхода в Главное Меню */
class DXRExitCurrentGameQuestion extends DXRQuitMessage;


function bool InternalOnClick(GUIComponent Sender)
{
    if(Sender==bOk)
    {
        PrepareToDxOnly(); 
        PlayerOwner().ConsoleCommand("OPEN DxOnly");
    }

    if(Sender==bCancel)
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

    stMessage="Do you want to exit to Main Menu ?"
    WinTitle="Exit current Game?"
    stOk="Yes"
    stCancel="No"
}