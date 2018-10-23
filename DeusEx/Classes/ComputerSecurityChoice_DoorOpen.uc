//=============================================================================
// ComputerSecurityChoice_DoorOpen
//=============================================================================

class ComputerSecurityChoice_DoorOpen extends ComputerCameraUIChoice;

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
			EnableMe();//EnableWindow();		// In case was previously disabled

			if (winCamera.door.KeyNum != 0)
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
	winCamera.TriggerDoor();
	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool IntOnRightClick(GUIComponent Sender)
{
	Super.IntOnRightClick(Sender);
	winCamera.TriggerDoor();
	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    enumText(0)="Open"
    enumText(1)="Closed"
    actionText="Door Status"
}
