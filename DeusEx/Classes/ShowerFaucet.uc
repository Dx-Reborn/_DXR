//=============================================================================
// ShowerFaucet.
//=============================================================================
class ShowerFaucet extends DeusExDecoration;

#exec OBJ LOAD FILE=Ambient
#exec OBJ LOAD FILE=MoverSFX
#exec OBJ LOAD FILE=Effects

var() bool              bOpen;
var EM_showerwater      waterGen[4];
var Vector              sprayOffsets[4];

event Destroyed()
{
    local int i;

    for (i=0; i<4; i++)
        if (waterGen[i] != None)
            waterGen[i].Kill();

    Super.Destroyed();
}

function Frob(actor Frobber, Inventory frobWith)
{
    local int i;

    Super.Frob(Frobber, frobWith);

    bOpen = !bOpen;
    if (bOpen)
    {
        PlaySound(sound'ValveOpen',,,, 256, 2.0);
        PlayAnim('On');

        for (i=0; i<4; i++)
            if (waterGen[i] != None)
                {
                    waterGen[i].emitters[0].Disabled = false;
                    waterGen[i].AmbientSound = Sound'Shower';
                }

        // extinguish the player if he frobbed this
        if (DeusExPlayer(Frobber) != None)
            if (DeusExPlayer(Frobber).bOnFire)
                DeusExPlayer(Frobber).ExtinguishFire();
    }
    else
    {
        PlaySound(sound'ValveClose',,,, 256, 2.0);
        PlayAnim('Off');

        for (i=0; i<4; i++)
            if (waterGen[i] != None)
                {
                    waterGen[i].emitters[0].Disabled = true;
                    waterGen[i].AmbientSound = none;
                }
    }
}

event PostBeginPlay()
{
    local ShowerHead head, linkedHead;
    local Vector loc;
    local int i;

    Super.PostBeginPlay();

    // find the matching shower head
    linkedHead = None;
    if (Tag != '')
        foreach AllActors(class'ShowerHead', head, Tag)
            linkedHead = head;

    // spawn a particle generator
    if (linkedHead != None)
    {
        for (i=0; i<4; i++)
        {
            // rotate the spray offsets into object coordinate space
            loc = sprayOffsets[i];
            loc.X += linkedHead.CollisionRadius * 0.57; // 0.7
            loc.Z -= linkedHead.CollisionHeight * 0.65; // 0.85
            loc = loc >> linkedHead.Rotation;
            loc += linkedHead.Location;

            waterGen[i] = Spawn(class'EM_showerwater', linkedHead,, loc, linkedHead.Rotation-rot(8192,0,0));
            if (waterGen[i] != None)
            {
                waterGen[i].emitters[0].Disabled = !bOpen;
                waterGen[i].SetBase(linkedHead);

                // only have sound on one of them
                if (i == 0)
                {
                   // waterGen[i].AmbientSound = Sound'Shower';
                    waterGen[i].SoundRadius = 16;
                }
            }
        }
    }

    // play the correct startup animation
    if (bOpen)
        PlayAnim('On', 10.0, 0.001);
    else
        PlayAnim('Off', 10.0, 0.001);
}


defaultproperties
{
     sprayOffsets(0)=(X=2.000000,Z=2.000000)
     sprayOffsets(1)=(Y=-2.000000)
     sprayOffsets(2)=(X=-2.000000,Z=-2.000000)
     sprayOffsets(3)=(Y=2.000000)
     bInvincible=True
     ItemName="Shower Faucet"
     bPushable=False
     Physics=PHYS_None
     mesh=mesh'DeusExDeco.ShowerFaucet'
     CollisionRadius=6.800000
     CollisionHeight=6.410000
     Mass=20.000000
     Buoyancy=10.000000
}
