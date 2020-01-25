//=============================================================================
// HKIncenseBurner.
//=============================================================================
class HKIncenseBurner extends HongKongDecoration;

var EM_IncenseBurner smokeGen;

#exec OBJ LOAD FILE=Effects

function Destroyed()
{
    if (smokeGen != None)
        smokeGen.Kill();

    Super.Destroyed();
}

function PostBeginPlay()
{
    Super.PostBeginPlay();

    SetBase(Owner);
    smokeGen = Spawn(class'EM_IncenseBurner', Self,, Location + vect(0,0,1) * CollisionHeight * 0.6, rot(16384,0,0));
    if (smokeGen != None)
    {
        smokeGen.SetBase(Self);
    }
}


defaultproperties
{
     FragType=Class'DeusEx.WoodFragment'
     bHighlight=True
     ItemName="Incense Burner"
     AmbientSound=Sound'DeusExSounds.Generic.Flare'
     mesh=mesh'DeusExDeco.HKIncenseBurner'
     SoundRadius=8
     SoundVolume=32
     SoundPitch=72
     CollisionRadius=13.000000
     CollisionHeight=27.000000
     Mass=20.000000
     Buoyancy=5.000000
     Skins[0]=Texture'DeusExDeco.Skins.HKIncenseBurnerTex1'
     Skins[1]=Texture'DeusExDeco.Skins.HKIncenseBurnerTex2'
     Skins[2]=Texture'DeusExDeco.Skins.HKIncenseBurnerTex1'
}
