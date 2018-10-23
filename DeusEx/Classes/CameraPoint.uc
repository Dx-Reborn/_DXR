//=============================================================================
// Адаптация CameraPoint.
// 03/02/2018: работает, но вид почему-то очень сильно трясется 0_o
// 04/02/2018: нервный тик устранен :)
//=============================================================================
class CameraPoint extends Keypoint
                         placeable;

//
// DEUS_EX CNN
// CameraPoint.uc - Cinematic camera control script
// These points are to be placed in the editor to control
// the camera during a cinematic cut-scene.
//

enum ECameraCommand
{
	CAMCMD_MOVE,						// cut (or smoothly move if timeSmooth > 0) to XYZPYR
	CAMCMD_PUSH,						// move forward along view axis
	CAMCMD_FOV,							// change FOV
	CAMCMD_TILT,						// change Pitch
	CAMCMD_PAN,							// change Yaw
	CAMCMD_ROLL,						// change Roll
	CAMCMD_WAIT,						// wait time or for a specific event
	CAMCMD_TRIGGER						// trigger an event
};

var() ECameraCommand	cmd;			// what command to execute
var() float				value;			// parameter for command
var() name				eventName;		// used by CAMCMD_WAIT_EVENT
var() float				timeSmooth;		// execute command smoothly over time (0 = instant)
var() float				timeWaitPost;	// delay after executing command
var() bool				bParallel;		// execute the next command simultaneously
var() bool				bRandom;		// the next point is chosen at random from other bRandoms
var() int				randomCount;	// number of times to choose randomly
var() int				postRandomNum;	// sequence to start at after random sequence

// internal vars not editable by the user
var() const int			sequenceNum;	// assigned in editor automatically
var CameraPoint			nextPoint;		// next point to be executed - points linked at runtime
var CameraPoint			prevPoint;		// point that was just executed - used by bParallel
var float				curTime;		// timer used by movement routines
var vector				startLoc;		// init location at beginning of command
var rotator				startRot;		// init rotation at beginning of command
var float				startFOV;		// init FOV at beginning of command
var vector				endLoc;			// dest location
var rotator				endRot;			// dest rotation
var float				endFOV;			// dest FOV
var PlayerPawn			Player;			// which player is being controlled
var bool				bTickReady;		// can we tick now?
var bool				bFirstRandom;	// are we the first random point in this sequence?
var int					randomRemain;	// how many random choices are left?
var CameraPoint			continuePoint;	// where we continue after a random sequence

// link all CameraPoints together
function InitAllPoints()
{
	local CameraPoint cur, next;
	local int num;
	local rotator rot;

	cur = Self;
	num = 0;
	while (num != 999999)
	{
		num = 999999;
		foreach AllActors(class'CameraPoint', next)
		{
			// clamp the rotation
			rot.Pitch = Rotation.Pitch % 65536;
			rot.Yaw = Rotation.Yaw % 65536;
			rot.Roll = Rotation.Roll % 65536;
			SetRotation(rot);

			// find the next highest number in the sequence
			if ((next.sequenceNum < num) && (next.sequenceNum > cur.sequenceNum))
			{
				num = next.sequenceNum;
				cur.nextPoint = next;
			}
		}

		if (num != 999999)
		{
//			log("** CameraPoint.InitAllPoints - linked "$cur.sequenceNum$" to "$num);
			cur = cur.nextPoint;
		}
	}
}

//
// state control code
//
auto state Idle
{
	// wait to be triggered
	function Trigger(Actor Other, Pawn Instigator)
	{
		Super.Trigger(Other, Instigator);
		Tag = '';
		Next();
	}

Begin:
	// find the player in this level
	// if there's not a player, destroy ourself
	Player = GetPlayerPawn();
	if (Player == None)
	{
//		log("** WARNING - CameraPoint.Idle.Begin() - "$sequenceNum$" - can't find the player!");
		Destroy();
		Stop;
	}

	// if we are the first one, link up the points and begin execution
	if (sequenceNum == 0)
	{
		// grab the player, make it not collide, and freeze it's controls
//		Player.GotoState('Paralyzed', 'Letterbox');
		DeusExPlayerController(Player.Controller).GotoState('Paralyzed', 'Letterbox');
//    Player.BaseEyeHeight=0.0;//
		Player.bHidden = True;
		Player.bCollideWorld = False;
		Player.SetCollision(False, False, False);
		DeusExPlayerController(Player.Controller).bSnapToLevel = false;
		if (Player.Shadow != None)
		{
			Player.Shadow.Destroy();
			Player.Shadow = None;
		}
		InitAllPoints();
		GotoState('Running');
	}

Wait:
	// do nothing until somebody wakes us up
	Stop;
}

state Running
{
	// used for smooth moves/rotations
	function Tick(float deltaTime)
	{
		local float alpha, beta;
		local vector loc;
		local rotator rot, diffrot;
		local float fov;

		if (!bTickReady)
			return;

		Super.Tick(deltaTime);

		// update the timer and see if we're done
		curTime += deltaTime;

		if (curTime >= timeSmooth)
		{
			Player.SetViewRotation(endRot); //= endRot;
			Player.SetLocation(endLoc);
			PlayerController(Player.Controller).SetFOVAngle(endFOV);
			PlayerController(Player.Controller).DesiredFOV = endFOV; //Player.DesiredFOV = endFOV;
			Next();
		}
		else
		{
			alpha = curTime / timeSmooth;

			// make sure we rotate the shortest direction
			diffrot = endRot - startRot;

			if (diffrot.Pitch >= 32768)
				diffrot.Pitch = diffrot.Pitch - 65536;
			else if (diffrot.Pitch <= -32768)
				diffrot.Pitch = diffrot.Pitch + 65536;

			if (diffrot.Yaw >= 32768)
				diffrot.Yaw = diffrot.Yaw - 65536;
			else if (diffrot.Yaw <= -32768)
				diffrot.Yaw = diffrot.Yaw + 65536;

			if (diffrot.Roll >= 32768)
				diffrot.Roll = diffrot.Roll - 65536;
			else if (diffrot.Roll <= -32768)
				diffrot.Roll = diffrot.Roll + 65536;

			// calculate our smoothing coefficient
			beta = 3.0*alpha*alpha - 2.0*alpha*alpha*alpha;

			// smooth the camera rotation, movement, and FOV
			rot = startRot + beta * diffrot;
			loc = startLoc + beta * (endLoc - startLoc);
			fov = startFOV + beta * (endFOV - startFOV);

			Player.SetLocation(loc);
			Player.SetViewRotation(rot);
			PlayerController(Player.Controller).SetFOVAngle(fov);
			PlayerController(Player.Controller).DesiredFOV = fov; //Player.DesiredFOV = endFOV;
		}
	}

Begin:
//	log("** starting "$sequenceNum);
	// save the starting location/rotation
	startLoc = Player.Location;
	startRot = Player.GetViewRotation();
	startFOV = PlayerController(Player.Controller).FOVAngle;

	// init the destination
	endLoc = startLoc;
	endRot = startRot;
	endFOV = startFOV;

	// evaluate the command
	EvaluateCommand();
	bTickReady = True;

	// should we execute the next command in parallel?
	if (bParallel)
	{
		nextPoint.prevPoint = Self;
		Next();
	}

	Stop;

Next:
	if (!bParallel)
		bTickReady = False;

	// if there's a postdelay, wait for it
	if (timeWaitPost > 0.0)
		Sleep(timeWaitPost);

	if (bRandom && !bParallel)
	{
		bTickReady = False;

		// if this is the first random encounter, set some values
		if (randomRemain == -1)
		{
			bFirstRandom = True;
			randomRemain = randomCount;
			SetContinuePoint();
		}

		// if we're done being random, continue where we left off
		if (randomRemain == 0)
			continuePoint.WakeUp();
		else
			WakeUpRandomPoint();
	}
	else if (nextPoint != None)
		nextPoint.WakeUp();
	else
//		log("** CameraPoint.Running.Next - "$sequenceNum$" - finished with path!");

Wait:
	GoToSleep();
}


//
// state control functions
//

// called to find another random camerapoint
function WakeUpRandomPoint()
{
	local CameraPoint point;
	local int count, rnd;

	// count how many there are
	count = 0;
	foreach AllActors(class'CameraPoint', point)
		if (point.bRandom)
			count++;

	// pick one at random
	rnd = Rand(count);
	count = 0;
	foreach AllActors(class'CameraPoint', point)
		if (point.bRandom && (count++ == rnd))
		{
			point.randomRemain = randomRemain - 1;
			point.continuePoint = continuePoint;
			point.WakeUp();
			break;
		}
}

// called to set the point to continue at after the random sequence
function SetContinuePoint()
{
	local CameraPoint point;
	
	foreach AllActors(class'CameraPoint', point)
		if (point.sequenceNum == postRandomNum)
		{
			continuePoint = point;
			break;
		}
}

// called when command is complete to move on to next command
function Next()
{
	GotoState('Running', 'Next');
}

// called to wake this camerapoint up
function WakeUp()
{
	GotoState('Running', 'Begin');
}

// called to put this camerapoint into it's idle state
function GoToSleep()
{
	if (IsInState('Running'))
		GotoState('Idle', 'Wait');
	else
		log("** WARNING - CameraPoint.GoToSleep() - "$sequenceNum$" - already sleeping!");
}

// wait for the timer to expire
function Timer()
{
	Next();
}

// evaluate the current command
function /*bool*/ EvaluateCommand()
{
	local vector loc;
	local Actor A;

	loc = vect(0,0,0);

	// init the movement timer
	curTime = 0.0;

//	log("** CameraPoint.EvaluateCommand - "$sequenceNum$" - cmd = "$cmd$" value = "$value$" eventName = "$eventName);

	switch (cmd)
	{
		case CAMCMD_MOVE:		endLoc = Location;
								endRot = Rotation;
								break;

		case CAMCMD_PUSH:		loc.X = value;
								endLoc += (loc >> Player.GetViewRotation());
								break;

		case CAMCMD_FOV:		endFOV += value;
								break;

		case CAMCMD_TILT:		endRot.Pitch += value;
								break;

		case CAMCMD_PAN:		endRot.Yaw += value;
								break;

		case CAMCMD_ROLL:		endRot.Roll += value;
								break;

		case CAMCMD_WAIT:		if (eventName != '')
								{
									Tag = eventName;
									GoToSleep();
								}
								else
									SetTimer(timeSmooth, False);
								break;

		case CAMCMD_TRIGGER:	if (eventName != '')
								{
									foreach AllActors(class'Actor', A, eventName)
										A.Trigger(None, None);
								}
								break;
	}

	// if we are running in parallel with the previous point,
	// add its parameters to ours
	if (prevPoint != None)
	{
		endLoc += prevPoint.endLoc - prevPoint.startLoc;
		endRot += prevPoint.endRot - prevPoint.startRot;
		endFOV += prevPoint.endFOV - prevPoint.startFOV;
	}
}

function PlayerPawn GetPlayerPawn()
{
  return PlayerPawn(level.GetLocalPlayerController().pawn);
}

defaultproperties
{
    randomRemain=-1
    bStatic=False
    bDirectional=True
    Texture=Texture'S_Camera'
}
