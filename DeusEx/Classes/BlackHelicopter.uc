//=============================================================================
// BlackHelicopter.
//=============================================================================
class BlackHelicopter extends Helicopters;

var vector origLoc;
const BLADES_KILL_VALUE = 10000;

auto state Flying
{
    event BeginState()
    {
        Super.BeginState();
        LoopAnim('Fly');
        origLoc = Location;
        origRot = Rotation;
    }
}

event Tick(float deltaTime)
{
    local float        ang;
    local rotator      rot;

    super.Tick(deltaTime);

    if (!IsInState('Interpolating')) //CyberP/Totalitarian: subtle hover effect
    {
        ang = 2 * Pi * Level.TimeSeconds / 4.0;
        rot = origRot;

        rot.Pitch += Sin(ang) * 48;
        rot.Roll += Cos(ang) * 48;
        rot.Yaw += Sin(ang) * 32;

        SetRotation(rot);
    }
}

singular function SupportActor(Actor standingActor)
{
    // kill whatever lands on the blades
    if (standingActor != None)
        standingActor.TakeDamage(BLADES_KILL_VALUE, None, standingActor.Location, vect(0,0,0), class'DM_Exploded');
}




defaultproperties
{
     ItemName="Black Helicopter"
     AmbientSound=Sound'Ambient.Ambient.Helicopter2'
     mesh=mesh'DeusExDeco.BlackHelicopter'
     SoundRadius=160
     SoundVolume=192
     CollisionRadius=461.230011
     CollisionHeight=87.839996
     Mass=6000.000000
     Buoyancy=1000.000000

     skins(0)=Texture'DeusExDeco.Skins.BlackHelicopterTex1'
     skins(1)=Shader'DeusExStaticMeshes.Skins.HelicopterBladesSH'
     skins(2)=Shader'DeusExStaticMeshes.Glass.GlassSH1'
}
