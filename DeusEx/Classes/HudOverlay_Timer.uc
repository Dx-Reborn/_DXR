/*
   HUD Overlay for Timer actor (never been used in the original game).
*/

class HudOverlay_Timer extends DXRHudOverlay;

var Texture timerBackground;
var Color colNormal, colCritical, colBlack;
var bool bCritical;
var bool bFlash;
var float time;
var float flashTime;
var string message;
var float offsetX, offsetY;
        
event PostSetInitialState()
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

function Render(Canvas u)
{
   local string str;
   local int mins;
   local float secs;

   // Draw the timer
   u.Font = Font'DS_Digits_18';

   if (bCritical)
       u.DrawColor = colCritical;
   else
       u.DrawColor = colNormal;

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
       u.DrawColor = colBlack;
       if (flashTime >= 1.0)
           flashTime = 0;
   }

   u.SetPos(u.sizeX - offsetX,u.sizeY - offsetY);
   u.DrawText(str);

   // draw title
   u.Font = Font'EU_14';
   u.SetPos(u.sizeX - offsetX, u.sizeY - offsetY - 40);
   u.DrawText(message);
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
   offsetX=120
   offsetY=100
   timerBackground=Texture'DeusExUI.UserInterface.ConWindowBackground'
   colNormal=(R=0,G=255,B=0,A=255)
   colCritical=(R=255,G=0,B=0,A=255)
}
