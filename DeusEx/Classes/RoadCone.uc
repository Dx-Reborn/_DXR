/*

*/

class RoadCone extends DeusExDecoration;

var bool bFirstHit;


event Attach(Actor Other)
{
    Velocity.X = 0;
    Velocity.Y = 0;
    Velocity.Z = FMin(0, Velocity.Z);
}

event Timer()
{
    SetCollision(true,true,true);
    SetCollisionSize(19,11);
}

event Bump(actor Other)
{
    if(Other.Mass >= 40)
    {
        bBobbing = false;
        Velocity += 1.5 * VSize(Other.Velocity) * Normal(Location - Other.Location);

        if (Physics == PHYS_None) 
            Velocity.Z = FMax(Velocity.Z,250);

        SetPhysics(PHYS_Falling);
        SetTimer(0.3,false);
        Instigator = Pawn(Other);
        StartRotating();
    }
}

function StartRotating()
{
    RotationRate.Yaw = 250000*FRand() - 125000;
    RotationRate.Pitch = 250000*FRand() - 125000;
    RotationRate.Roll = 250000*FRand() - 125000;    
    DesiredRotation = RotRand();
    bRotateToDesired = False;
    bFixedRotationDir = True;
    bFirstHit = True;
    SetCollisionSize(19,11);
}

event Landed(vector HitNormal)
{
    local Rotator NewRot;
    Super.Landed(HitNormal);
    NewRot = Rotation;
    NewRot.Pitch = 18768;
    SetRotation(NewRot);
    SetCollisionSize(19,11);
}

auto State Animate
{
    event HitWall(vector HitNormal, actor Wall)
    {
        local float speed;

        Velocity = 0.5*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
        speed = VSize(Velocity);

        if (bFirstHit && speed < 400) 
        {
            bFirstHit=False;
            bRotatetoDesired=True;
            bFixedRotationDir=False;
            DesiredRotation.Yaw=Rand(65535);
            DesiredRotation.Pitch=Rand(65535);
            DesiredRotation.Roll=0;
        }
        RotationRate.Yaw = RotationRate.Yaw*0.75;
        RotationRate.Roll = RotationRate.Roll*0.75;
        RotationRate.Pitch = RotationRate.Pitch*0.75;

        If (speed < 50) 
        {
            bBounce = False;
            DesiredRotation.Yaw = Rotation.Yaw;
            DesiredRotation.Roll = Rotation.Roll;
            DesiredRotation.Pitch=18768;
            SetRotation(DesiredRotation);
        }
    }   

    function TakeDamage(int NDamage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<damageType> damageType)
    {
        if (StandingCount() > 1)
            return;

        SetPhysics(PHYS_Falling);
        bBounce = True;
        Velocity += Momentum/Mass;
        Velocity.Z = FMax(Momentum.Z, 200);
        StartRotating();
    }
}

defaultproperties
{
     bOrientOnSlope=false // Important for this case!
     bHighlight=True
     HitPoints=40
     PrePivot=(Z=18.000000)
     bInvincible=False
     bPushable=True
     bStatic=False
     Physics=PHYS_Falling
     FragType=class'DeusEx.PlasticFragment'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DXR_RoadPack.RoadCone'
     CollisionRadius=15.300000
     CollisionHeight=18.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bProjTarget=True
     Mass=35.000000
     Buoyancy=40.000000
     ItemName="Traffic cone"
     Skins[0]=Texture'DXR_RoadPack.Plastic.RoadCone_Tex'
}
