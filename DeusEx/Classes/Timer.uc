//=============================================================================
// Timer.
//=============================================================================
class Timer extends Keypoint;

var() bool bCountDown;          // count down?
var() float startTime;          // what time do we start from?
var() float criticalTime;       // when does the text turn red?
var() float destroyDelay;       // after timer has expired, how long until we destroy the window
var() string message;           // message to print on timer window
var HudOverlay_Timer timerWin;  // DXR: HUD overlay instead of window.
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
        bDone = False;
        PlaySound(sound'Beep3', SLOT_Misc);
        player.ClientMessage("Timer started");
    }
    else if (!bDone && (timerWin != None))
    {
        bDone = true;
        SetTimer(destroyDelay, False);
        PlaySound(sound'Beep3', SLOT_Misc);
        player.ClientMessage("Timer stopped");
    }
}


defaultproperties
{
     bCountDown=True
     StartTime=60.000000
     criticalTime=10.000000
     destroyDelay=5.000000
     Message="Countdown"
     bStatic=False
}
