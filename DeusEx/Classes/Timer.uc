//=============================================================================
// Timer.
//=============================================================================
class Timer extends Keypoint;

var() bool bCountDown;          // count down?
var() float startTime;          // what time do we start from?
var() float criticalTime;       // when does the text turn red?
var() float destroyDelay;       // after timer has expired, how long until we destroy the window
var HudOverlay_Timer timerWin;  // DXR: HUD overlay instead of window.
var() localized string strTimerStarted, strTimerStopped, message; // message to print on timer window // DXR: localized && new messages
var float time;
var bool bDone;

//
// count up or down depending on what the settings are
//
event Tick(float deltaTime)
{
   if (timerWin != None)
   {
       if (bDone)
       {
           timerWin.bFlash = true;
           return;
       }

       if (bCountDown)
       {
           time -= deltaTime;
           if (time < 0)
               time = 0;

           if (time <= criticalTime)
               timerWin.bCritical = true;
       }
       else
       {
           time += deltaTime;

           if (time >= criticalTime)
               timerWin.bCritical = true;
       }
       timerWin.time = time;
   }
}

//
// destroy the window
//
function Timer()
{
   timerWin.Destroy();
}

//
// start or stop the timer
//
function Trigger(Actor Other, Pawn EventInstigator)
{
   local DeusExPlayer player;

   player = DeusExPlayer(EventInstigator);

   if (player == None)
       return;

   Super.Trigger(Other, EventInstigator);
    
   if (timerWin == None)
   {
       if (bCountDown)
           time = startTime;
       else
           time = 0;

       timerWin = Spawn(class'HudOverlay_Timer');
       PlayerController(player.Controller).myHUD.AddHudOverlay(timerWin);
       timerWin.time = time;
       timerWin.bCritical = false;
       timerWin.message = message;
       bDone = false;
       PlaySound(sound'Beep3', SLOT_Misc);
       player.ClientMessage(strTimerStarted);
   }
   else if (!bDone && (timerWin != None))
   {
       bDone = true;
       SetTimer(destroyDelay, false);
       PlaySound(sound'Beep3', SLOT_Misc);
       player.ClientMessage(strTimerStopped);
   }
}


defaultproperties
{
   bCountDown=true
   StartTime=60.000000
   criticalTime=10.000000
   destroyDelay=5.000000
   Message="Countdown"
   bStatic=false
   strTimerStarted=""
   strTimerStopped=""
}
