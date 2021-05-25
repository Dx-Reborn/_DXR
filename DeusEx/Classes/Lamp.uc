//=============================================================================
// Lamp. 
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
        bUnlit = True;
        ScaleGlow = 2.0;
    }
    else
    {
        bOn = False;
        LightType = LT_None;
        PlaySound(sound'Switch4ClickOff');
        bUnlit = False;
    }
    ToggleUnlit();

    // DXR: From Revision mod
    // Alert AI.
    // DXR: Only if player really wants that!
    if (class'DeusExGlobals'.static.GetGlobals().bMoreAINotifications)
    {
        Instigator = Pawn(Frobber);
        AISendEvent('LoudNoise', EAITYPE_Audio,, 384);
        AISendEvent('LoudNoise', EAITYPE_Visual);
    }
    // End of changes
}

event PostSetInitialState()
{
    if (bOn)
        LightType = LT_Steady;
    else
        LightType = LT_None;

    SetTimer(0.1, false);
}

event Timer()
{
   ToggleUnlit();
}


function ToggleUnlit()
{
   if(bOn)
   {
      bUnlit = true;
   }
   else
   {
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
     bOwned=true
}
