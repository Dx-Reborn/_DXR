/*

*/

class DeusExInteraction extends Interaction;

var DeusExPlayerController pc;
var DeusExPlayer DxPlayer;
var HudOverlay_ConWindowThird ConWindow;


event Initialized()
{
    if (ViewportOwner.Actor.Level.NetMode != NM_Client || True)
        foreach ViewportOwner.Actor.DynamicActors(class'DeusExPlayerController', pc)
            break;

    if (pc != none)
       DxPlayer = DeusExPlayer(pc.pawn);
}


function bool KeyEvent(EInputKey Key, EInputAction Action, float Delta)
{
    local DeusExGlobals gl;

    gl = class'DeusExGlobals'.static.GetGlobals();
    conWindow = gl.conWindow;

    Super.KeyEvent(Key,Action,Delta);

    if (Action != IST_Press)
        return false;

      if (ConWindow != none)
      {
          ConWindow.KeyEvent(Key); // Send KeyEvent to our HUD Overlay.
          return true;
      }

}
