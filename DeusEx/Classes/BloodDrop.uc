//=============================================================================
// BloodDrop.
//=============================================================================
class BloodDrop extends DeusExFragment;

auto state Flying
{
    simulated function HitWall(vector HitNormal, actor Wall)
    {
        spawn(class'BloodSplat',,, Location, Rotator(-HitNormal));
        Destroy();
    }

    simulated function BeginState()
    {
        Velocity = VRand() * 100;
        //SetDrawScale(1.0 + FRand());
        SetDrawScale(default.DrawScale + FRand());
        SetRotation(Rotator(Velocity));

        // Gore check
        if (Level.Game.bLowGore)
        {
            Destroy();
            return;
        }
    }
}

simulated function Tick(float deltaTime)
{
    if (Velocity == vect(0,0,0))
    {
//        spawn(class'BloodSplat',,, Location, rot(16384,0,0));
        spawn(class'BloodSplat',,, Location);
        Destroy();
    }
    else
        SetRotation(Rotator(Velocity));
}


defaultproperties
{
     //Style=STY_Modulated
//     Skins[0]=shader'DXR_FX.Particles.DarkRed_Modulated'
     DrawScale=0.1
//     Mesh=Mesh'DeusExItems.BloodDrop'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bBounce=False
     DrawType=DT_None
}
