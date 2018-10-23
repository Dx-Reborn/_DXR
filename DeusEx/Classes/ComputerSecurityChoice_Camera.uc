//=============================================================================
// ComputerSecurityChoice_Camera
//=============================================================================

class ComputerSecurityChoice_Camera extends ComputerCameraUIChoice;

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(Tab_cameraView newCamera)
{
	Super.SetCameraView(newCamera);

	if (winCamera != None)
	{
		if (winCamera.Selectedcamera != None)
		{
			if (winCamera.Selectedcamera.bActive)
				SetValue(0);
			else
				SetValue(1);

			EnableMe();
		}
		else
		{
			// Disable!
			DisableMe();
			Info.SetText("");
		}

/*		if (securityWindow != None)
			securityWindow.EnableCameraButtons(winCamera.Selectedcamera != None);*/
	}
	else
	{
		// Disable!
		DisableMe();
		Info.SetText("");

/*		if (securityWindow != None)
			securityWindow.EnableCameraButtons(False);*/
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
	winCamera.ToggleCameraState();
	return True;
}

// ----------------------------------------------------------------------
// ButtonActivatedRight()
// ----------------------------------------------------------------------

function bool IntOnRightClick(GUIComponent Sender)
{
	Super.IntOnRightClick(Sender);
	winCamera.ToggleCameraState();
	return True;
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{
    enumText(0)="On"
    enumText(1)="Off"
    actionText="Camera Status"
}
