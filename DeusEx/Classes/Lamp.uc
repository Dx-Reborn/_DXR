//=============================================================================
// Lamp. Fixed version from GMDX mod
//=============================================================================
class Lamp extends Furniture
	abstract;

var() bool bOn;

function Frob(Actor Frobber, Inventory frobWith)
{
   Super.Frob(Frobber, frobWith);

   if (!bOn)
   {
      bOn = True;
      LightType = LT_Steady;
      PlaySound(sound'Switch4ClickOn');
   }
   else
   {
      bOn = False;
      LightType = LT_None;
      PlaySound(sound'Switch4ClickOff');
   }
   ResetScaleGlow();
}

function SetInitialState()
{
   lighttype = LT_Steady;
   bUnlit = True;
   bOn = True;
   ScaleGlow=1.5;
   ResetScaleGlow();//might as well do this every time, because seriously, what the fuck is your problem, light?
   Super.SetInitialState();
}


function ResetScaleGlow()
{
//   local float mod;

   //if (!bInvincible)
   //   mod = 1.5;//float(HitPoints) / float(Default.HitPoints) * 0.9 + 0.1;
   //else
   //   mod = 1.5;

   if(bOn)
   {
      ScaleGlow = 1.5;// * mod;
      bUnlit = true;
   }
   else
   {
      ScaleGlow = 0.5;
      bUnlit = false;
   }

}


defaultproperties
{
     FragType=Class'DeusEx.GlassFragment'
     bPushable=False
     LightBrightness=255
     LightSaturation=255
     LightRadius=4
     bDynamicLight=true
}
