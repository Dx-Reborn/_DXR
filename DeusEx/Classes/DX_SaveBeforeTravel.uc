// IMPORTANT!!!
// Do not add Touch function to this trigger! If this trigger if fired by touching,
// in loaded savegame Player will loose controller (as i understand). So use regular trigger to trigger this trigger :)

Class DX_SaveBeforeTravel extends DeusExTrigger;

var() teleporter Teleporter;

//function Touch(Actor Other)
/*
singular function Trigger(Actor Other, Pawn Instigator)
{
		local PlayerController DC;
		local DeusExLevelInfo Info;

		DC = Level.GetLocalPlayerController();
		Info = GetLevelInfo();

			if (Teleporter !=none)
			{
				Log("MoveToTeleporter="$Info.MoveToTeleporter);

				DC.pawn.setLocation(Teleporter.Location);
				DC.pawn.setViewRotation(Teleporter.Rotation);
				DeusExPlayerController(DC).SaveByIndex();
			}
//	Super.Trigger(Other, Instigator);
}

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

	return info;
}*/




defaultproperties
{
	collisionRadius=0
	collisionHeight=0
}
