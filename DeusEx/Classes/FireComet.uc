//=============================================================================
// FireComet.
//=============================================================================
class FireComet extends DeusExFragment;

auto state Flying
{
    function HitWall(vector HitNormal, actor Wall)
    {
        local BurnMark mark;

        mark = spawn(class'BurnMark',,, Location, Rotator(HitNormal));
        if (mark != None)
        {
            mark.SetDrawScale(0.4*DrawScale);
            //mark.ReattachDecal();
        }
        Destroy();
    }
    function BeginState()
    {
        Velocity = VRand() * 300;
        Velocity.Z = FRand() * 200 + 200;
        SetDrawScale(0.3 + FRand());
        SetRotation(Rotator(Velocity));
    }
}

event Tick(float deltaTime)
{
    if (Velocity == vect(0,0,0))
    {
        spawn(class'BurnMark',,, Location, rot(16384,0,0));
        Destroy();
    }
    else
        SetRotation(Rotator(Velocity));
}


defaultproperties
{
     Style=STY_Translucent
     Mesh=Mesh'DeusExItems.FireComet'
     ScaleGlow=2.000000
     bUnlit=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bBounce=False
}
