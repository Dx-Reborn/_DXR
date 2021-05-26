//=============================================================================
// Toilet2.
//=============================================================================
class Toilet2a extends DeusExDecoration;

enum ESkinColor
{
    SC_Clean,
    SC_Filthy
};

var() ESkinColor SkinColor;
var bool bUsing;
//var EM_Toilet2aWater particles;

// bone004

event BeginPlay()
{
    Super.BeginPlay();

//    particles = Spawn(class'EM_Toilet2aWater');
//    AttachToBone(particles, 'Bone004');
//    particles.Emitters[0].Trigger();
//    particles.Emitters[1].Trigger();
    
    switch (SkinColor)
    {
//       case SC_Clean:  Skins[0] = Material(DynamicLoadObject("DXR_AnimDeco.Ceramic.toilet2a_HD_Clean", class'Material', false)); break;
//       case SC_Filthy: Skins[0] = Material(DynamicLoadObject("DXR_AnimDeco.Ceramic.toilet2a_HD_Dirty", class'Material', false)); break;
       case SC_Clean:  Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.Toilet2Tex1", class'Material', false)); break;
       case SC_Filthy: Skins[0] = Material(DynamicLoadObject("DeusExDeco.Skins.Toilet2Tex2", class'Material', false)); break;
    }
}

event Timer()
{
    bUsing = false;

//    particles.Emitters[0].Trigger();
//    particles.Emitters[1].Trigger();
}

function Frob(actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    if (bUsing)
        return;

    SetTimer(2.0, False);
    bUsing = true;

    PlaySound(sound'FlushUrinal',,,, 256);
    PlayAnim('Flush');

//    particles.Emitters[0].Trigger();
//    particles.Emitters[1].Trigger();

}


defaultproperties
{
     bInvincible=True
     ItemName="Urinal"
     bPushable=False
     Physics=PHYS_None
     mesh=mesh'DeusExDeco.Toilet2'
//     mesh=SkeletalMesh'DXR_AnimDeco.Toilet2a_HD'
     CollisionRadius=18.000000
     CollisionHeight=31.000000
     Mass=100.000000
     Buoyancy=5.000000
}
