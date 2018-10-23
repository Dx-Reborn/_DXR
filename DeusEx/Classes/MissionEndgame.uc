//=============================================================================
// MissionEndgame.
//=============================================================================
class MissionEndgame extends MissionScript;

var byte savedSoundVolume;
var float endgameDelays[3];
var float endgameTimer;
var localized string endgameQuote[6];
//var HUDMissionStartTextDisplay quoteDisplay;
var bool bQuotePrinted;

// ----------------------------------------------------------------------
// InitStateMachine()
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// PreTravel()
// 
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// FinishCinematic()
// ----------------------------------------------------------------------
function FinishCinematic()
{
	local CameraPoint cPoint;

/*	if (quoteDisplay != None)
	{
		quoteDisplay.Destroy();
		quoteDisplay = None;
	}*/

	// Loop through all the CameraPoints and set the "nextPoint"
	// to None will will effectively cause them to halt.
	// This prevents the screen from fading while the credits are rolling.

	foreach player.AllActors(class'CameraPoint', cPoint)
		cPoint.nextPoint = None;

	flags.SetBool('EndgameExplosions', False);
	SetTimer(0, False);
//	Player.ShowCredits(True);
}


// ----------------------------------------------------------------------
// PrintEndgameQuote()
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// ExplosionEffects()
// ----------------------------------------------------------------------
function ExplosionEffects()
{
	local float size;
	local int i;
	local Vector loc, endloc, HitLocation, HitNormal;
	local Actor HitActor;
	local MetalFragment frag;

	if (FRand() < 0.8)
	{
		// pick a random explosion size and modify everything accordingly
		size = FRand();

		// play a sound
		if (size < 0.5)
			Player.PlaySound(Sound'LargeExplosion1', SLOT_None, 2.0,, 16384);
		else
			Player.PlaySound(Sound'LargeExplosion2', SLOT_None, 2.0,, 16384);

		// have random metal fragments fall from the ceiling
		if (FRand() < 0.8)
		{
			for (i=0; i<Int(size*10.0); i++)
			{
				loc = Player.Location + 512.0 * VRand();
				loc.Z = Player.Location.Z;
				endloc = loc;
				endloc.Z += 1024.0;
				HitActor = Trace(HitLocation, HitNormal, endloc, loc, False);
				if (HitActor == None)
					HitLocation = endloc;

				// spawn some explosion effects
				if (size < 0.5)
					Spawn(class'ExplosionMedium',,, HitLocation+8*HitNormal);
				else
					Spawn(class'ExplosionLarge',,, HitLocation+8*HitNormal);

				if (FRand() < 0.5)
				{
					frag = Spawn(class'MetalFragment',,, HitLocation);
					if (frag != None)
					{
						frag.CalcVelocity(vect(20000,0,0),256);
						frag.SetDrawScale(0.5 + 2.0 * FRand());
						if (FRand() < 0.75)
							frag.bSmoking = True;
					}
				}
			}
		}
	}
}



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     endgameDelays(0)=13.000000
     endgameDelays(1)=13.500000
     endgameDelays(2)=10.500000
     endgameQuote(0)="YESTERDAY WE OBEYED KINGS AND BENT OUR NECKS BEFORE EMPERORS.  BUT TODAY WE KNEEL ONLY TO TRUTH..."
     endgameQuote(1)="    -- KAHLIL GIBRAN"
     endgameQuote(2)="IF THERE WERE NO GOD, IT WOULD BE NECESSARY TO INVENT HIM."
     endgameQuote(3)="    -- VOLTAIRE"
     endgameQuote(4)="BETTER TO REIGN IN HELL, THAN SERVE IN HEAVEN."
     endgameQuote(5)="    -- PARADISE LOST, JOHN MILTON"
}
