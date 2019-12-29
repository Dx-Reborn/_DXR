//=============================================================================
// DeusExDecal
//=============================================================================
class DeusExDecal extends xScorch;

var bool bAttached, bStartedLife, bImportant;
var int MultiDecalLevel;
/*
event PostBeginPlay()
{
    Super.PostBeginPlay();
    SetTimer(1.0, false);
}

simulated function Timer()
{
    // Check for nearby players, if none then destroy self

    if ( !bAttached )
    {
        Destroy();
        return;
    }

    if ( !bStartedLife )
    {
        RemoteRole = ROLE_None;
        bStartedLife = true;
        if ( Level.bDropDetail )
            SetTimer(5.0 + 2 * FRand(), false);
        else
            SetTimer(18.0 + 5 * FRand(), false);
        return;
    }
    if (Level.bDropDetail && (MultiDecalLevel < 3))
    {
        if ( (Level.TimeSeconds - LastRenderTime > 0.35)
            || (!bImportant && (FRand() < 0.2)) )
            Destroy();
        else
        {
            SetTimer(1.0, true);
            return;
        }
    }
    else if ( Level.TimeSeconds - LastRenderTime < 1 )
    {
        SetTimer(5.0, true);
        return;
    }
    Destroy();
}    */


defaultproperties
{
     bAttached=True
     bImportant=True
     MultiDecalLevel=2 //5
     FadeInTime=0.05
     drawScale=0.1
     bClipBSP=true
     bClipStaticMesh=true
}
