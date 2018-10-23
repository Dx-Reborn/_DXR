//=============================================================================
// ComputerSecurity.
//=============================================================================
class ComputerSecurity extends Computers;

struct sViewInfo
{
	var() localized string	titleString;
	var() name				cameraTag;
	var() name				turretTag;
	var() name				doorTag;
};

var() sViewInfo Views[3];


defaultproperties
{
     terminalType=Class'NetworkTerminalSecurity'
     lockoutDelay=120.000000
     UserList(0)=(userName="SECURITY",Password="SECURITY")
     BindName="ComputerSecurity"
     ItemName="Security Computer Terminal"
     Physics=PHYS_None
     AmbientSound=Sound'DeusExSounds.Generic.SecurityL'
     mesh=mesh'DeusExDeco.ComputerSecurity'
     SoundRadius=8
     SoundVolume=255
     SoundPitch=96
     CollisionRadius=11.590000
     CollisionHeight=10.100000
     bCollideWorld=False
}
