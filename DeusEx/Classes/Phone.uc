//=============================================================================
// Phone.
//=============================================================================
class Phone extends ElectronicDevices;

enum ERingSound
{
    RS_Office1,
    RS_Office2
};

enum EAnswerSound //== Y|y: Expanded available selections to match number of available sounds
{
    AS_Dialtone,
    AS_Busy,
    AS_OutOfService,
    AS_Locked,
    AS_ShutDown,
    AS_Unrecognized,
    AS_Random
};

var() ERingSound RingSound;
var() EAnswerSound AnswerSound;
var() float ringFreq;
var float ringTimer;
var bool bUsing;
var localized String messages[4]; // Отображать сообщения телефона в текстовом виде.

event Tick(float deltaTime)
{
    Super.Tick(deltaTime);

    //== Y|y: If the phone is in use or a non-ringing phone don't make any noise
    if(bUsing || ringFreq <= 0.0)
        return;

    ringTimer += deltaTime;

    if (ringTimer >= 1.0)
    {
        ringTimer -= 1.0;

        if (FRand() < ringFreq)
        {
            switch (RingSound)
            {
                case RS_Office1:    PlaySound(sound'PhoneRing1', SLOT_Misc,,, 256); break;
                case RS_Office2:    PlaySound(sound'PhoneRing2', SLOT_Misc,,, 256); break;
            }
        }
    }
}

event Timer()
{
    bUsing = False;
}

function ShowPhoneMessage(int Idx)
{
   // ToDo: вывести особым образом на ГДИ или просто отправить ClientMessage?
}

function Frob(actor Frobber, Inventory frobWith)
{
    local float rnd;

    Super.Frob(Frobber, frobWith);

    if (bUsing)
        return;

    bUsing = True;

    //== Sounds play for about 3 seconds
    SetTimer(3.0, False);

    rnd = 1.0;

    //== Y|y: Phones using the default value play a random sound effect
    if(AnswerSound == AS_Random)
        rnd = FRand();

    //== Y|y: The AnswerSound variable can actually matter now, for the few phones that use anything but the default value anyway
    if (rnd < 0.1 || AnswerSound == AS_Busy)
        PlaySound(sound'PhoneBusy', SLOT_Misc,,, 256);
    else 
    if (rnd < 0.2 || AnswerSound == AS_Dialtone)
        PlaySound(sound'PhoneDialtone', SLOT_Misc,,, 256);
    else 
    if (rnd < 0.4 || AnswerSound == AS_Unrecognized)   //"You are not a recognized user for this device"
    {
        ShowPhoneMessage(0);
        PlaySound(sound'PhoneVoice1', SLOT_Misc,,, 256);
    }
    else 
    if (rnd < 0.6 || AnswerSound == AS_Locked)     //"This account has been locked, pending investigation"
    {
        ShowPhoneMessage(1);
        PlaySound(sound'PhoneVoice2', SLOT_Misc,,, 256);
    }
    else 
    if (rnd < 0.8 || AnswerSound == AS_OutOfService)   //"Awaiting authorization"
    {
        ShowPhoneMessage(2);
        PlaySound(sound'PhoneVoice3', SLOT_Misc,,, 256);
    }
    else    //AS_ShutDown                   //"This line has been shut down by order of UNATCO"
    {
        ShowPhoneMessage(3);
        PlaySound(sound'PhoneVoice4', SLOT_Misc,,, 256);
    }
}

defaultproperties
{
     messages[0]="You are not a recognized user for this device"
     messages[1]="This account has been locked, pending investigation"
     messages[2]="Awaiting authorization"
     messages[3]="This line has been shut down by order of UNATCO"
     AnswerSound=AS_Random
     ringFreq=0.010000
     ItemName="Telephone"
//     Mesh=LodMesh'DeusExDeco.Phone'
     CollisionRadius=11.870000
     CollisionHeight=3.780000
     Mass=20.000000
     Buoyancy=15.000000
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.Phone_HD'
}

