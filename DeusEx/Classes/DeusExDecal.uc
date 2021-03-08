//=============================================================================
// DeusExDecal
//=============================================================================
class DeusExDecal extends Projector; //xScorch;

#EXEC OBJ LOAD FILE=DeusExItems.ukx

var() float Lifetime;
var() float PushBack;
var() bool  RandomOrient;

event PreBeginPlay()
{
    local PlayerController PC;

    if ((Level.NetMode == NM_DedicatedServer) || (Level.DecalStayScale == 0.f))
    {
        Destroy();
        return;
    }
    PC = Level.GetLocalPlayerController();
    if (PC.BeyondViewDistance(Location, CullDistance))
    {
        Destroy();
        return;
    }

    Super.PreBeginPlay();
}

function PostBeginPlay()
{
    local Vector RX, RY, RZ;
    local Rotator R;

    if ( PhysicsVolume.bNoDecals )
    {
        Destroy();
        return;
    }
    if( RandomOrient )
    {
        R.Yaw = 0;
        R.Pitch = 0;
        R.Roll = Rand(65535);
        GetAxes(R,RX,RY,RZ);
        RX = RX >> Rotation;
        RY = RY >> Rotation;
        RZ = RZ >> Rotation;
        R = OrthoRotation(RX,RY,RZ);
        SetRotation(R);
    }
    SetLocation(Location - Vector(Rotation)*PushBack);
    Super.PostBeginPlay();

    Lifespan = FMax(0.5, LifeSpan + (Rand(4) - 2));

    if (Level.bDropDetail)
        LifeSpan *= 0.5;
    AbandonProjector(LifeSpan*Level.DecalStayScale);
//    Destroy();
}


defaultproperties
{
    drawScale=0.1
    Lifespan=20.00
    FOV=1
    PushBack=24
    MaxTraceDistance=60
    bClipStaticMesh=true
    bProjectBSP=true
    bProjectTerrain=true
    bProjectStaticMesh=true
    bProjectActor=false
    bClipBSP=true
    bNoDelete=false
    bStatic=false
    FadeInTime=0.125
    MaterialBlendingOp=PB_None
    FrameBufferBlendingOp=PB_Modulate
    GradientTexture=GRADIENT_Clip
}
