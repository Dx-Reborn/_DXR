/*
  Убран ужасающий (СКРИМЕР!!!) звук при открытии, заменен на близкий и родной :)
*/

class DeusExConsole extends ExtendedConsole;

#exec OBJ LOAD FILE=DeusExSounds.u

const MAX_Messages = 200;

var DeusExPlayer p;
var int LogHead, LogPos;    // Where in the scrollback buffer are we
var config int jShotCounter;

/*--- Передать оповещение о смене карты контроллеру игрока ---*/
//event NotifyLevelChange()
//{
//  DeusExPlayerController(Viewportowner.Actor).NotifyLevelChange();
//  ConsoleClose();
//}

/*--- Добавить сообщение в историю ---*/
event Message(coerce string Msg, float MsgLife)
{
  super.Message(Msg, MsgLife);

  p = DeusExPlayer(Viewportowner.Actor.pawn);

    if (p.logMessages.Length==MAX_Messages) // if full, Remove Entry 0
    {
        p.logMessages.Remove(0,1);
        LogHead = MAX_Messages - 1;
    }
    else
        LogHead++;

    p.logMessages.Length = p.logMessages.Length + 1;

    p.logMessages[LogHead] = Msg;
}

// DXR: Сохранить скриншот в JPG.
exec function JPGShot()
{
   local texture tex;
   local string path;

   path = class'FileManager'.static.GetSystemDirectory();

   class'GraphicsManager'.static.TakeScreenShot(Viewportowner.Actor.XLevel, tex);
   class'GraphicsManager'.static.SaveTextureJpeg(Path$"\\..\\ScreenShots\\Shot_"$jShotCounter$".jpg", tex, 100);
   jShotCounter++;
   SaveConfig();
}


defaultproperties
{
    SMOpenSound=sound'DeusExSounds.UserInterface.Menu_Activate'
    SMAcceptSound=sound'DeusExSounds.UserInterface.Menu_OK'
    SMDenySound=sound'DeusExSounds.UserInterface.Menu_Cancel'
    ConsoleSoundVol=0.2
    ConsoleBackground=texture'DeusExUI.UserInterface.MenuAugsBackground_5'
    ConsoleLowerLine=texture'DXRMenuImg.Dithered'
//    ConsoleLowerLine=texture'InterfaceContent.Menu.BorderBoxA2'
}

