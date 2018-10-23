/*
   Initially this was DynMusicActor from DynMusic mod by Kaiser.

   Should play music depending on situation on level:
   1) Regular ambient
   2) Wnen player has third-person conversation
   3) When someone tries to attack player
   4) When playing outro
   5) When player is dead.
*/

class DXRMusicController extends Info
                         placeable;

/*
var DeusExPlayer Watcher;
var DynMusicMutator DM;
var bool battling;
var bool conversing;
var bool inter;
var bool dead;

function Tick(float deltatime)
{
local DeusExPlayer DXP;
local ScriptedPawn SP;
local bool bFoundCombat;

		
	if(Watcher != None)
	{
		SetLocation(watcher.Location);
		if (Watcher.IsInState('Interpolating'))
		{
			if(!inter)
			{
				Watcher.ClientSetMusic(Level.Song, 5, 255, MTRAN_FastFade);
				inter = True;
				//SetTimer(1, True);
			}
		}
		else if (Watcher.IsInState('Conversation'))
		{
			if (!conversing)
			{
				Watcher.ClientSetMusic(Level.Song, 4, 255, MTRAN_Fade);
				conversing = True;
			}
		}
		else if (Watcher.IsInState('Dying'))
		{
			//#Log("Checking dead.");
			if (!dead)
			{
				//#Log("Doing dead track");
				Watcher.ClientSetMusic(Level.Song, 1, 255, MTRAN_Fade);
				dead = True;
			}
		}
	
		else if(!battling)
		{
			foreach VisibleActors(class'ScriptedPawn', SP, 785, Location)
			{
				if(!SP.IsA('Animal') && !SP.IsA('SuperCleanerBot') && !SP.IsA('CleanerBot') && !SP.IsA('MedicalBot') && !SP.IsA('RepairBot'))  
					if(SP.IsInState('Attacking') || SP.IsInState('Alerting') || SP.IsInState('Burning') || SP.IsInState('Seeking') || SP.IsInState('Stunned') || SP.IsInState('HandlingEnemy'))
						bFoundCombat=True;
			}

			if(bFoundCombat)
			{
				battling=True;
					if(DM.BattleEnterMsg != "")
						Watcher.ClientMessage(DM.BattleEnterMsg);
				Watcher.ClientSetMusic( Level.Song, 3, Level.CdTrack, MTRAN_Fade);
				//SetTimer(1,True);
			}
		}
	}
}

//alerting
//burning
//takinghit
//handlingenemy
//seeking
//stunned


function Timer()
{
local ScriptedPawn SP;
local bool bFoundCombat;

	if(inter)
	{
		if (!Watcher.IsInState('Interpolating'))
		{
				Watcher.ClientSetMusic(Level.Song, 0, 255, MTRAN_FastFade);
				inter = False;
		}
	}
	
	if(conversing)	
	{
		if (!watcher.IsInState('Conversation'))
		{
				Watcher.ClientSetMusic(Level.Song, 0, 255, MTRAN_Fade);
				conversing = False;
		}
	}
	if(dead)
	{
		//Log("End dead check");
		if (!watcher.IsInState('Dying'))
		{
			//#Log("Undeading");
				Watcher.ClientSetMusic(Level.Song, 0, 255, MTRAN_Fade);
				dead = False;
		}
	}
		
	if(battling)
	{
		foreach RadiusActors(class'ScriptedPawn', SP, 785, Location)
		{
			if(!SP.IsA('Animal') && !SP.IsA('SuperCleanerBot') && !SP.IsA('CleanerBot') && !SP.IsA('MedicalBot') && !SP.IsA('RepairBot'))  
				if(SP.IsInState('Attacking') || SP.IsInState('Alerting') || SP.IsInState('Burning') || SP.IsInState('TakingHit') || SP.IsInState('Seeking') || SP.IsInState('Stunned') || SP.IsInState('HandlingEnemy'))
					bFoundCombat=True;
		}
		
		if(!bFoundCombat)
		{
			battling=False;
					if(DM.BattleExitMsg != "")
						Watcher.ClientMessage(DM.BattleExitMsg);
			Watcher.ClientSetMusic( Level.Song, 0, Level.CdTrack, MTRAN_Fade);
		}
	}
}


*/