/*
   А он нужен?
*/

class HudOverlay_Timer extends HudOverlay;

var Texture timerBackground;
var Color colNormal, colCritical, colBlack;
var bool bCritical;
var bool bFlash;
var float time;
var float flashTime;
var string message;
        
event SetInitialState()
{
    time = 0;
    flashTime = 0;
}

event Tick(float deltaTime)
{
    if (bFlash)
        flashTime += deltaTime;
}

// ----------------------------------------------------------------------
// DrawWindow()
// ----------------------------------------------------------------------

function Render(Canvas c)
{
/*  local string str;
    local int mins;
    local float secs;

    // Draw the timer
    c.Font=Font'FontComputer8x20_B';

    if (bCritical)
        c.DrawColor(colCritical);
    else
        c.DrawColor(colNormal);

    // print the time nicely
    mins = time / 60;
    secs = time % 60;

    if (mins < 10)
        str = "0";
    str = str $ mins $ ":";
    if (secs < 10)
        str = str $ "0";
    str = str $ secs;

    if (bFlash && (flashTime >= 0.75))
    {
        c.DrawColor(colBlack);
        if (flashTime >= 1.0)
            flashTime = 0;
    }

    c.DrawText(0, 0, width, height, str);

    // draw title
    c.Font=Font'TechSmall';
    c.DrawText(2, 2, width-2, height-2, message);*/
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
    timerBackground=Texture'DeusExUI.UserInterface.ConWindowBackground'
    colNormal=(R=0,G=255,B=0,A=255),
    colCritical=(R=255,G=0,B=0,A=255),
}
