class DeusExPlayerPawn extends DeusExPawn native;


var bool bScriptedCrouchMode;


defaultproperties
{
	bScriptedCrouchMode = true
	bIgnoreLedges = true
}


cpptext
{
	void performPhysics(FLOAT DeltaSeconds);
}
