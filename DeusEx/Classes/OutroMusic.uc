/*

*/
class OutroMusic extends DeusExTrigger;

function DeusExLevelInfo GetLevelInfo()
{
	local DeusExLevelInfo info;

	foreach AllActors(class'DeusExLevelInfo', info)
		break;

	return info;
}

function Trigger(actor Other, pawn EventInstigator)
{
  if (GetLevelInfo().OutroMusic != "")
   level.GetLocalPlayerController().ClientSetMusic(GetLevelInfo().OutroMusic, MTRAN_FastFade);
}

defaultproperties
{
  texture=OutroMusic
  DrawScale=0.5
}