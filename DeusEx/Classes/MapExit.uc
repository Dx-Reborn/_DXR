//=============================================================================
// MapExit.
//=============================================================================
class MapExit extends NavigationPoint
		placeable;

//
// MapExit transports you to the next map
// change bCollideActors to False to make it triggered instead of touched
//
// DXR: To travel to another map using flying camera, you have to trigger this MapExit
// using SubActionTrigger in SceneManager.

var() string DestMap;
var() bool bPlayTransition;
var() name cameraPathTag;

var DeusExPlayer Player;

function Pawn GetPlayerPawn()
{
    return Level.GetLocalPlayerController().Pawn;
}

function LoadMap(Actor Other)
{
	// use GetPlayerPawn() because convos trigger by who's having the convo
	Player = DeusExPlayer(GetPlayerPawn());

	if (Player != None)
	{
		// Make sure we destroy all windows before sending the
		// player on his merry way.
//		DeusExRootWindow(Player.rootWindow).ClearWindowStack();

		if (bPlayTransition)
		{
			PlayTransitionPath();
			Player.NextMap = DestMap;
		}
		else
//			Level.Game.SendPlayer(PlayerController(Pawn(Other).Controller), DestMap);
			Level.Game.SendPlayer(Level.GetLocalPlayerController(), DestMap);
	}
}

function Trigger(Actor Other, Pawn Instigator)
{
	Super.Trigger(Other, Instigator);
	LoadMap(Other);
}

function Touch(Actor Other)
{
	Super.Touch(Other);
	LoadMap(Other);
}

function PlayTransitionPath()
{
/*	local InterpolationPoint I;

	if (Player != None)
	{
		foreach AllActors(class 'InterpolationPoint', I, cameraPathTag)
		{
			if (I.Position == 1)
			{
				Player.SetCollision(False, False, False);
				Player.bCollideWorld = False;
				Player.Target = I;
				Player.SetPhysics(PHYS_Interpolating);
				Player.PhysRate = 1.0;
				Player.PhysAlpha = 0.0;
				Player.bInterpolating = True;
				Player.bStasis = False;
				Player.ShowHud(False);
				Player.PutInHand(None);

				// if we're in a conversation, set the NextState
				// otherwise, goto the correct state
				if (Player.conPlay != None)
					Player.NextState = 'Interpolating';
				else
					Player.GotoState('Interpolating');

				break;
			}
		}
	}*/
}


defaultproperties
{
     Texture=Texture'Engine.S_Teleport'
     bCollideActors=True
     CollisionRadius=12.00
     CollisionHeight=15.00
}
