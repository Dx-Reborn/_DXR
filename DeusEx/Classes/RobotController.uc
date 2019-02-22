/*
   Контроллер для роботов
*/
class RobotController extends DXRAiController;



state Disabled
{
	ignores Notifybump, frob, reacttoinjury;
	function BeginState()
	{
		Robot(pawn).StandUp();
		Robot(pawn).BlockReactions(true);
		Robot(pawn).bCanConverse = False;
		Robot(pawn).SeekPawn = None;
	}
	function EndState()
	{
		Robot(pawn).ResetReactions();
		Robot(pawn).bCanConverse = true;
	}

Begin:
	Robot(pawn).Acceleration=vect(0,0,0);
	Robot(pawn).DesiredRotation=Rotation;
	Robot(pawn).PlayDisabled();

Disabled:
}

state Fleeing
{
	function PickDestination()
	{
		local int     iterations;
		local float   magnitude;
		local rotator rot1;

		iterations = 4;
		magnitude  = 400*(FRand()*0.4+0.8);  // 400, +/-20%
		rot1       = Rotator(pawn.Location-Enemy.Location);
		if (!AIPickRandomDestination(40, magnitude, rot1.Yaw, 0.6, rot1.Pitch, 0.6, iterations,
		                             FRand()*0.4+0.35, Robot(pawn).destLoc))
			Robot(pawn).destLoc = pawn.Location;  // we give up
	}
}
