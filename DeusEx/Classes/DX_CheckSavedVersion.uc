//===============================================
// Триггер для проверки

class DX_CheckSavedVersion extends DeusExTrigger;

/*var() teleporter MoveToThisPoint;

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

	return info;
}


function Touch(Actor Other)
{
  Super.Touch(Other);
  CheckSavedVersion();
}


function CheckSavedVersion()
{
  local LevelSummary L;
  local PlayerController player;
  local DeusExLevelInfo info;

	Player = Level.GetLocalPlayerController();
	Info 	 = GetLevelInfo();

  L = LevelSummary(DynamicLoadObject("save"$info.SavedIndex$".usa"$".LevelSummary", class'LevelSummary'));
  if(L != None)
  {
      Player.ClientMessage("Saved version exists! Loading...");
			if (MoveToThisPoint!=none)
				{
					Player.ClientTravel( "?load="$info.SavedIndex, TRAVEL_Absolute, false);
					Player.pawn.setLocation(MoveToThisPoint.Location);
					Player.pawn.setViewRotation(MoveToThisPoint.Rotation);
				}

  }     
  else
  {
      Player.ClientMessage("There is no saved version!");
  }
}


defaultproperties
{
	bHidden=false // триггер тестовый, его должно быть видно.
}*/