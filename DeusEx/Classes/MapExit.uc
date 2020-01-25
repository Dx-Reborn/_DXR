//=============================================================================
// MapExit.
// MapExit transports you to the next map
// change bCollideActors to False to make it triggered instead of touched
//=============================================================================
class MapExit extends NavigationPoint
		placeable
    hideCategories(Actor,Advanced,Display,Sound,Trailer, Movement, NavigationPoint, Hidden);


var() string DestMap;
var bool bPlayTransition;
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
	   Level.Game.SendPlayer(Level.GetLocalPlayerController(), DestMap);
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


defaultproperties
{
     Texture=S_Door
     bCollideActors=True
     CollisionRadius=12.00
     CollisionHeight=15.00
     bForcedOnly=true
}
