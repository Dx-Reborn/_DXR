//=============================================================================
// Timer.
//=============================================================================
class Timer extends Keypoint;

var() bool bCountDown;			// count down?
var() float startTime;			// what time do we start from?
var() float criticalTime;		// when does the text turn red?
var() float destroyDelay;		// after timer has expired, how long until we destroy the window
var() string message;			// message to print on timer window
//var TimerDisplay timerWin;
var float time;
var bool bDone;

//
// count up or down depending on what the settings are
//

//
// destroy the window
//

//
// start or stop the timer
//

defaultproperties
{
     bCountDown=True
     StartTime=60.000000
     criticalTime=10.000000
     destroyDelay=5.000000
     Message="Countdown"
     bStatic=False
}
