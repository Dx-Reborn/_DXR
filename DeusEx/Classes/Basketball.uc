//=============================================================================
// Basketball.
//=============================================================================
class Basketball extends DeusExDecoration;

event HitWall(vector HitNormal, actor HitWall)
{
    local float speed;

    Velocity = 0.8*((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    if (HitWall.IsA('Pawn'))
    {
       Velocity = VRand() * 200;
       return;
    }
    speed = VSize(Velocity);
    bFixedRotationDir = True;
    RotationRate = RotRand(False);
    if ((speed > 0) && (speed < 30) && (HitNormal.Z > 0.7))
    {
        class'ActorManager'.static.SetPhysicsEx(self, PHYS_None, HitWall);
        if (Physics == PHYS_None)
            bFixedRotationDir = False;
    }
    else if (speed > 30)
    {
        PlaySound(sound'BasketballBounce', SLOT_None);
        class'EventManager'.static.AISendEvent(self, 'LoudNoise', EAITYPE_Audio);
    }
}

defaultproperties
{
     bInvincible=True
     ItemName="Basketball"
//     mesh=mesh'DeusExDeco.Basketball'
     StaticMesh=StaticMesh'DeusExStaticMeshes3.Basketball_a'
     DrawType=DT_StaticMesh
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bBounce=True
     Mass=8.000000
     Buoyancy=10.000000
     Physics=PHYS_Projectile
}
