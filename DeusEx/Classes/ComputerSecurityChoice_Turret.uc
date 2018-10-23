//=============================================================================
// ComputerSecurityChoice_Turret
//=============================================================================

class ComputerSecurityChoice_Turret extends ComputerCameraUIChoice;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(Tab_cameraView newCamera)
{
	Super.SetCameraView(newCamera);

	if (winCamera != None)
	{
		if (winCamera.turret != None)
		{
			EnableMe();		// In case was previously disabled

			if (winCamera.turret.bDisabled)
				SetValue(0);
			else if (winCamera.turret.bTrackPlayersOnly)
				SetValue(1);
			else if (winCamera.turret.bTrackPawnsOnly)
				SetValue(2);
			else
				SetValue(3);
		}
		else
		{
			// Disable!
			DisableMe();
			Info.SetText("");
		}
	}
	else
	{
		// Disable!
		DisableMe();
		Info.SetText("");
	}
}

// ----------------------------------------------------------------------
// ButtonActivated()
//
// If the action button was pressed, cycle to the next available
// choice (if any)
// ----------------------------------------------------------------------

function bool IntOnClick(GUIComponent Sender)
{
	Super.IntOnClick(Sender);
	SetTurretState();
	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool IntOnRightClick(GUIComponent Sender)
{
	Super.IntOnRightClick(Sender);
	SetTurretState();
	return True;
}

// ----------------------------------------------------------------------
// SetTurretState()
// ----------------------------------------------------------------------

function SetTurretState()
{
	switch(GetValue())
	{
		case 0:			// Disabled
			winCamera.SetTurretState(False, True);		
			break;

		case 1:			// Attack Allies
			winCamera.SetTurretState(True, False);		
			winCamera.SetTurretTrackMode(True, False);
			break;

		case 2:			// Attack Enemies
			winCamera.SetTurretState(True, False);		
			winCamera.SetTurretTrackMode(False, True);
			break;

		case 3:			// Attack Everything
			winCamera.SetTurretState(True, False);		
			winCamera.SetTurretTrackMode(False, False);
			break;
	}
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    enumText(0)="Bypassed"
    enumText(1)="Allies"
    enumText(2)="Enemies"
    enumText(3)="Everything"
    actionText="Turret Status"
}
