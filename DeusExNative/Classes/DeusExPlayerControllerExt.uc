class DeusExPlayerControllerExt extends PlayerController native;


// Set bWantsLedgeCheck to true, and player will "hold yourself" on ledges. False by default,
// so you can jump off from skyscrapers even when crouched (but for unknown reason, sometimes this will not work)

var() bool bWantsLedgeCheck;


cpptext
{
	virtual UBOOL WantsLedgeCheck() {
		return bWantsLedgeCheck;
	}

	void SetWantsLedgeCheck(UBOOL bWantsLedgeCheck) {
		this->bWantsLedgeCheck = bWantsLedgeCheck;
	}
}
