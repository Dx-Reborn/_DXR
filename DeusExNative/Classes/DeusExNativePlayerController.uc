class DeusExNativePlayerController extends PlayerController native;


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
