//=============================================================================
// Poolball.
//=============================================================================
class Poolball extends DeusExDecoration;

enum ESkinColor
{
    SC_1,
    SC_2,
    SC_3,
    SC_4,
    SC_5,
    SC_6,
    SC_7,
    SC_8,
    SC_9,
    SC_10,
    SC_11,
    SC_12,
    SC_13,
    SC_14,
    SC_15,
    SC_Cue
};

var() ESkinColor SkinColor;
var bool bJustHit;
var string OtherModels[16];


event BeginPlay()
{
    Super.BeginPlay();

    switch (SkinColor)
    {
/*        case SC_1:      Skins[0] = Texture'PoolballTex1'; break;
        case SC_2:      Skins[0] = Texture'PoolballTex2'; break;
        case SC_3:      Skins[0] = Texture'PoolballTex3'; break;
        case SC_4:      Skins[0] = Texture'PoolballTex4'; break;
        case SC_5:      Skins[0] = Texture'PoolballTex5'; break;
        case SC_6:      Skins[0] = Texture'PoolballTex6'; break;
        case SC_7:      Skins[0] = Texture'PoolballTex7'; break;
        case SC_8:      Skins[0] = Texture'PoolballTex8'; break;
        case SC_9:      Skins[0] = Texture'PoolballTex9'; break;
        case SC_10:     Skins[0] = Texture'PoolballTex10'; break;
        case SC_11:     Skins[0] = Texture'PoolballTex11'; break;
        case SC_12:     Skins[0] = Texture'PoolballTex12'; break;
        case SC_13:     Skins[0] = Texture'PoolballTex13'; break;
        case SC_14:     Skins[0] = Texture'PoolballTex14'; break;
        case SC_15:     Skins[0] = Texture'PoolballTex15'; break;
        case SC_Cue:    Skins[0] = Texture'PoolballTex16'; break;*/
        case SC_1:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[0], class'StaticMesh', false))); break;  
        case SC_2:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[1], class'StaticMesh', false))); break;
        case SC_3:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[2], class'StaticMesh', false))); break;
        case SC_4:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[3], class'StaticMesh', false))); break;
        case SC_5:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[4], class'StaticMesh', false))); break;
        case SC_6:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[5], class'StaticMesh', false))); break;
        case SC_7:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[6], class'StaticMesh', false))); break;
        case SC_8:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[7], class'StaticMesh', false))); break;
        case SC_9:      SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[8], class'StaticMesh', false))); break;
        case SC_10:     SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[9], class'StaticMesh', false))); break;
        case SC_11:     SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[10], class'StaticMesh', false))); break;
        case SC_12:     SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[11], class'StaticMesh', false))); break;
        case SC_13:     SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[12], class'StaticMesh', false))); break;
        case SC_14:     SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[13], class'StaticMesh', false))); break;
        case SC_15:     SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[14], class'StaticMesh', false))); break;
        case SC_Cue:    SetStaticMesh(StaticMesh(DynamicLoadObject(OtherModels[15], class'StaticMesh', false))); break;
    }
}

event Tick(float deltaTime)
{
    local float speed;

    speed = VSize(Velocity);

    if ((speed >= 0) && (speed < 5))
    {
        bFixedRotationDir = False;
        Velocity = vect(0,0,0);
    }
    else if (speed >= 5)
    {
        bFixedRotationDir = True;
        SetRotation(Rotator(Velocity));
        RotationRate.Pitch = speed * 60000;
    }
}

event HitWall(vector HitNormal, actor HitWall)
{
    local Vector newloc;

    // if we hit the ground, make sure we are rolling
    if (HitNormal.Z == 1.0)
    {
        class'ActorManager'.static.SetPhysicsEx(self,PHYS_Walking, HitWall);
        if (Physics == PHYS_Walking)
        {
            bFixedRotationDir = False;
            Velocity = vect(0,0,0);
            return;
        }
    }

    Velocity = 0.9*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    Velocity.Z = 0;
    newloc = Location + HitNormal;  // move it out from the wall a bit
    SetLocation(newloc);
}

event Timer()
{
    bJustHit = False;
}

event Bump(actor Other)
{
    local Vector HitNormal;

    if (Other.IsA('Poolball'))
    {
        if (!Poolball(Other).bJustHit)
        {
            PlaySound(sound'PoolballClack', SLOT_None);
            HitNormal = Normal(Location - Other.Location);
            Velocity = HitNormal * VSize(Other.Velocity);
            Velocity.Z = 0;
//            bJustHit = True;
//            Poolball(Other).bJustHit = True;
            SetTimer(0.02, False);
            Poolball(Other).SetTimer(0.02, False);
        }
    }
}

function Frob(Actor Frobber, Inventory frobWith)
{
    Velocity = Normal(Location - Frobber.Location) * 400;
    Velocity.Z = 0;
}


defaultproperties
{
     OtherModels[0]="DXR_PoolTable_Set.Pool_Ball_1"
     OtherModels[1]="DXR_PoolTable_Set.Pool_Ball_2"
     OtherModels[2]="DXR_PoolTable_Set.Pool_Ball_3"
     OtherModels[3]="DXR_PoolTable_Set.Pool_Ball_4"
     OtherModels[4]="DXR_PoolTable_Set.Pool_Ball_5"
     OtherModels[5]="DXR_PoolTable_Set.Pool_Ball_6"
     OtherModels[6]="DXR_PoolTable_Set.Pool_Ball_7"
     OtherModels[7]="DXR_PoolTable_Set.Pool_Ball_8"
     OtherModels[8]="DXR_PoolTable_Set.Pool_Ball_9"
     OtherModels[9]="DXR_PoolTable_Set.Pool_Ball_10"
     OtherModels[10]="DXR_PoolTable_Set.Pool_Ball_11"
     OtherModels[11]="DXR_PoolTable_Set.Pool_Ball_12"
     OtherModels[12]="DXR_PoolTable_Set.Pool_Ball_13"
     OtherModels[13]="DXR_PoolTable_Set.Pool_Ball_14"
     OtherModels[14]="DXR_PoolTable_Set.Pool_Ball_15"
     OtherModels[15]="DXR_PoolTable_Set.Pool_Ball_White"

     bInvincible=true
     ItemName="Poolball"
     bPushable=False
     Physics=PHYS_Walking
//     mesh=mesh'DeusExDeco.Poolball'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_PoolTable_Set.Pool_Ball_White'
     CollisionRadius=1.700000
     CollisionHeight=1.700000
     bBounce=True
     Mass=5.000000
     Buoyancy=2.000000
}
