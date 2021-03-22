/* Запрос тренировки */

class DXRAskTrainingMessage extends DXRQuitMessage;

var localized string AskToTrainMessage;

function bool InternalOnClick(GUIComponent Sender)
{
   if (Sender == bOk) // Начать тренировку
       DeusExPlayer(PlayerOwner().pawn).StartTrainingMission();

   if (Sender == bCancel)
       Controller.CloseMenu();

   return true;
}

defaultproperties
{
    AskToTrainMessage="Before starting a new game for the first time, we suggest running through the Training Mission.  Would you like to do this now?"
    stMessage="Proceed to UNATCO Training Facilities?"
    WinTitle="Training Mission"
    stOk="Yes"
    stCancel="No"
}