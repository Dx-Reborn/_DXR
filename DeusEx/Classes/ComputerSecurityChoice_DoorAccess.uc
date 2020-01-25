//=============================================================================
// ComputerSecurityChoice_DoorAccess
//=============================================================================

class ComputerSecurityChoice_DoorAccess extends ComputerCameraUIChoice;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(Tab_cameraView newCamera)
{
	Super.SetCameraView(newCamera);

	if (winCamera != None)
	{
		if (winCamera.door != None)
		{
			EnableMe();		// In case was previously disabled

			if (winCamera.door.bLocked)
				SetValue(0);
			else
				SetValue(1);
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
	winCamera.ToggleDoorLock();
	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool IntOnRightClick(GUIComponent Sender)
{
	Super.IntOnRightClick(Sender);
	winCamera.ToggleDoorLock();
	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    enumText(0)="Locked"
    enumText(1)="Unlocked"
    actionText="Door Access"
}
