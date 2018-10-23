//=============================================================================
// FadeViewTrigger.
//=============================================================================
class FadeViewTrigger extends DeusExTrigger;

var() color fadeColor;
var() float fadeTime;
var() float postFadeTime;
var() bool bFadeDown;
var DeusExPlayer player;
var float time;

defaultproperties
{
     fadeColor=(R=255,G=255,B=255)
     fadeTime=2.000000
     bTriggerOnceOnly=True
     CollisionRadius=96.000000
}
