//===========================================================================================//
// EventManager. Рассылает событие акторам. Используется как аналог EventManager из Deus Ex. //
//===========================================================================================//


class EventManager extends Info;

static function AISetEventCallback(name eventName, name callback, 
                                                        optional name scoreCallback, 
                                                        optional bool bCheckVisibility, 
                                                        optional bool bCheckDir,
                                                        optional bool bCheckCylinder,
                                                        optional bool bCheckLOS)
{
    // пока заглушка
//  Log("AISetEventCallback("@eventName@callback@scoreCallback@bCheckVisibility@bCheckDir@bCheckCylinder@bCheckLOS@")");
}

static function AIClearEventCallback(name eventName)
{
    // пока заглушка
//  Log("AIClearEventCallback("@eventName);
}

static function AISendEvent(actor A, name eventName, DeusExPawn.EAIEventType eventType, optional float Value, optional float Radius)
{
//   log("AISendEvent"@A@EventName@eventType@Value@radius);

   if (Radius < 1)
       Radius = 800;

   if (eventName == 'Futz')
   {
         foreach A.RadiusActors(class'Actor', A, Radius)
         {
            if (A.IsA('ScriptedPawn'))
                ScriptedPawn(A).ReactToFutz();
         }
   }
}

static function AIStartEvent(actor A, name eventName, DeusExPawn.EAIEventType eventType, optional float Value, optional float Radius)
{
    if (eventName == 'Alarm')
    {
//      Log("AIStartEvent"@EventName@eventType@Value@radius);

        foreach A.RadiusActors(class'Actor', A, Radius)
        {
            If (A.IsA('AutoTurret')) // && (A != none))
                AutoTurret(A).AlarmHeard(eventName, EAISTATE_Begin); //, XAIParams);
        }
    }
}

static function AIEndEvent(actor A, name eventName, DeusExPawn.EAIEventType eventType)
{
    if (eventName == 'Alarm')
    {
//  Log("AIEndEvent"@EventName@eventType);

        foreach A.AllActors(class'Actor', A) // RadiusActors(class'Actor', A, Radius)
        {
            If (A.IsA('AutoTurret')) //&& (A != none))
                AutoTurret(A).AlarmHeard(eventName, EAISTATE_End); //, XAIParams);
        }
    }
}

static function AIClearEvent(name eventName)
{
//  Log("AIClearEvent"@EventName);
}


//=============================================================================
// Подсказка

/* Пример реакции:  EventManager.AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));
function AlarmHeard(Name event, EAIEventState state, XAIParams params)
{
    if (state == EAISTATE_Begin)
    {
        if (!bActive)
        {
            bPreAlarmActiveState = bActive;
            bActive = True;
        }
    }
    else if (state == EAISTATE_End)
    {
        if (bActive)
            bActive = bPreAlarmActiveState;
    }
}*/

defaultproperties
{
}
