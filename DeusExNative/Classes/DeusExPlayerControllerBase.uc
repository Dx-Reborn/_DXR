class DeusExPlayerControllerBase extends PlayerController native;


// Set bWantsLedgeCheck to true, and player will "hold yourself" on ledges. False by default,
// so you can jump off from skyscrapers even when crouched.

var() bool bWantsLedgeCheck;


exec function testIterator(optional int ArraySize, optional int MaxIterations, optional int StartIndex) {
    local int i;

    if (ArraySize == 0) {
        ArraySize = 10;
    }
    if (MaxIterations == 0) {
        MaxIterations = ArraySize + 1;
    }
    i = StartIndex;
    foreach NumericIterator(ArraySize, MaxIterations, i) {
        ClientMessage("NumericIterator: " $ ArraySize $ ", " $ MaxIterations $ " -> " $ i);
    }
}

native iterator function NumericIterator(int ArraySize, int MaxIterations, out int CurrentNumber);


cpptext
{
    virtual UBOOL WantsLedgeCheck() {
        return bWantsLedgeCheck;
    }

    void SetWantsLedgeCheck(UBOOL bWantsLedgeCheck) {
        this->bWantsLedgeCheck = bWantsLedgeCheck;
    }

    virtual UBOOL Tick(FLOAT DeltaSeconds, ELevelTick TickType);
}
