//=============================================================================
// ShakeTrigger.
//=============================================================================
class ShakeTrigger extends DeusExTrigger;

// Shakes the screen when touched or triggered
// Set bCollideActors to False to make it triggered

var() float shakeTime;
var() float shakeRollMagnitude;
var() float shakeVertMagnitude;

/*var() float  ShakeRadius;		// radius within which to shake player views
var() vector RotMag;			// how far to rot view
var() vector RotRate;			// how fast to rot view
var() float  RotTime;			// how much time to rot the instigator's view
var() vector OffsetMag;		    // max view offset vertically
var() vector OffsetRate;		// how fast to offset view vertically
var() float  OffsetTime;	    // how much time to offset view


function Trigger(Actor Other, Pawn Instigator)
{
	Instigator.ShakeView(shakeTime, shakeRollMagnitude, shakeVertMagnitude);

	Super.Trigger(Other, Instigator);
}

function Touch(Actor Other)
{
	local DeusExPlayer player;

	if (IsRelevant(Other))
	{
		player = DeusExPlayer(Other);
		if (player != None)
			player.ShakeView(shakeTime, shakeRollMagnitude, shakeVertMagnitude);

		Super.Touch(Other);
	}
}*/


defaultproperties
{
     shaketime=1.000000
     shakeRollMagnitude=1024.000000
     shakeVertMagnitude=16.000000
}
