//=============================================================================
// ComputerCameraUIChoice
//=============================================================================

class ComputerCameraUIChoice extends DXREnumButton
	abstract;

var Tab_cameraView winCamera;
var ComputerScreenSecurity securityWindow; // to be removed ))

// ----------------------------------------------------------------------
// SetCameraView()
// ----------------------------------------------------------------------

function SetCameraView(Tab_cameraView newCamera)
{
	winCamera = newCamera;
//	log(self@"SetCameraView="$newCamera);
}

// ----------------------------------------------------------------------
// SetSecurityWindow()
// ----------------------------------------------------------------------

/*function SetSecurityWindow(ComputerScreenSecurity newScreen)
{
	securityWindow = newScreen;
}*/

// ----------------------------------------------------------------------
// DisableChoice()
// ----------------------------------------------------------------------

function DisableChoice()
{
/*	btnAction.DisableWindow();
	btnInfo.DisableWindow();*/
	DisableMe();
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------
defaultproperties
{

}
