//=============================================================================
// Spark.
//=============================================================================
class Spark extends Effects;

#exec OBJ LOAD FILE=Effects

var Rotator rot;
var Sound HitSounds[4];
var Sound EarthHitSounds[4];
var Sound WoodHitSounds[4];

event PostBeginPlay()
{
   Super.PostBeginPlay();       
   MakeSound();
}

function SpawnDecal(Name DecalName, vector HitLoc, vector HitNormal)
{
   local BulletHole hole;
   local GlassCrack crack;
   local WoodCrack wCrack;
   local MetalDent dent;
   local ConcreteCrack keyGen;
   local EarthHit eh;
   local BrickHit br;

   if (DecalName == 'Metal' || DecalName == 'Ladder') // Металл
       dent = spawn(class'MetalDent', , , HitLoc, Rotator(-HitNormal));
   else if (DecalName == 'Earth' || DecalName == 'Foliage')
       eh = spawn(class'EarthHit', , , HitLoc, Rotator(-HitNormal));
   else if (DecalName == 'Wood')
       wCrack = spawn(class'WoodCrack', , , HitLoc, Rotator(-HitNormal));
   else if (DecalName == 'Glass' || DecalName == 'Ceramic')
       crack = spawn(class'GlassCrack', , , HitLoc, Rotator(-HitNormal));
   else if (DecalName == 'Brick')
       br = spawn(class'BrickHit', , , HitLoc, Rotator(-HitNormal));
   else if (DecalName == 'Concrete' || DecalName == 'Stone' || DecalName == 'Stucco')
       keyGen = spawn(class'ConcreteCrack', , , HitLoc, Rotator(-HitNormal));
   else
   hole = spawn(class'BulletHole', , , HitLoc, Rotator(-HitNormal));

}

function SpawnCoolEffect(Name TypeOfParticles, vector Loc)
{
   if (TypeOfParticles == 'None') // На всякий случай...
       return;

   if (TypeOfParticles == 'Metal' || TypeOfParticles == 'Ladder') // Металл
       Spawn(class'EM_MetalHit',,,Loc,);

   if (TypeOfParticles == 'Foliage') // Трава
       Spawn(class'EM_GrassHit',,,Loc,);
   
   if (TypeOfParticles == 'Earth') // Земля
       Spawn(class'EM_DirtHit',,,Loc,);

   if (TypeOfParticles == 'Wood') // Дерево
       Spawn(class'EM_WoodHit',,,Loc,);

   if (TypeOfParticles == 'Textile' || TypeOfParticles == 'Paper') // Ткань или бумага
       Spawn(class'EM_ClothHit',,,Loc,);

   if (TypeOfParticles == 'Brick' || TypeOfParticles == 'Concrete' || TypeOfParticles == 'Stone' || TypeOfParticles == 'Stucco')
       Spawn(class'EM_ConcreteHit',,,Loc,);
}

function MakeSound()
{
    local float rnd;
    local Sound ActualSound;
    local Name ImpactMaterial;

    rnd = FRand();
    ImpactMaterial = GetImpactMaterial();
        
    switch(ImpactMaterial)
    {
        case 'Textile':
        case 'Paper':
            ActualSound = Sound'PaperHit1';
            break;

        case 'Foliage':
        case 'Earth':
            ActualSound = EarthHitSounds[Rand(4)];
            break;

        case 'Metal':
        case 'Ladder':
            if (rnd < 0.5)
                ActualSound = Sound'BulletImpactMetal1';
            else
                ActualSound = Sound'BulletImpactMetal2';
            break;

        case 'Ceramic':
        case 'Glass':
            if (rnd < 0.5)
                ActualSound = Sound'Glass04hl';
            else
                ActualSound = Sound'glass01hl';
            break;
        case 'Tiles':
            ActualSound = Sound'GlassHit2';
            break;

        case 'Wood':
            ActualSound = WoodHitSounds[Rand(4)];
            break;

        case 'Brick':
        case 'Concrete':
        case 'Stone':
        case 'Stucco':
        default:
            ActualSound = HitSounds[Rand(4)];
            break;
    }
            PlaySound(ActualSound, SLOT_None,1.1 - 0.2 * FRand() ,, 1024, 1.1 - 0.2 * FRand());
}



auto state Flying
{
    function BeginState()
    {
        Velocity = vect(0,0,0);
        rot = Rotation;
        rot.Roll += FRand() * 65535;
        SetRotation(rot);
    }
}


function name GetImpactMaterial()
{
    local vector EndTrace, HitLocation, HitNormal;
    local actor target;
    local int texFlags;
    local name texName, texGroup;
    local material mat;

    EndTrace = Location - (Vector(Rotation) * 5.0);

    foreach class'ActorManager'.static.TraceTexture(self,class'Actor', target, texName, texGroup, texFlags, HitLocation, HitNormal, EndTrace)
    {
        if (target == Level)
        {
            SpawnCoolEffect(texGroup, HitLocation);
            SpawnDecal(texGroup, HitLocation, HitNormal);
            break;
        }
        if ((target.bWorldGeometry) || (target.IsA('Mover')))
        {
           Trace(HitLocation, HitNormal, EndTrace, , false, , mat);

            if (mat != none)
            {
               texGroup = class'DxUtil'.static.GetMaterialGroup(mat);
               SpawnCoolEffect(texGroup, HitLocation);
               SpawnDecal(texGroup, HitLocation, HitNormal);
               break;
            }
        }
    }
    return texGroup;
}


defaultproperties
{
     HitSounds(0)=Sound'DeusExSounds.Generic.Ricochet1'
     HitSounds(1)=Sound'DeusExSounds.Generic.Ricochet2'
     HitSounds(2)=Sound'DeusExSounds.Generic.Ricochet3'
     HitSounds(3)=Sound'DeusExSounds.Generic.Ricochet4'

     EarthHitSounds(0)=Sound'impact_wpn_small_asphalt2'
     EarthHitSounds(1)=Sound'impact_wpn_small_earth2'
     EarthHitSounds(2)=Sound'impact_wpn_small_mud1'
     EarthHitSounds(3)=Sound'impact_wpn_small_mud2'

     WoodHitSounds(0)=Sound'Wood01gr'
     WoodHitSounds(1)=Sound'Wood02gr'
     WoodHitSounds(2)=Sound'Wood03gr'
     WoodHitSounds(3)=Sound'Wood04gr'

     LifeSpan=0.250000
     Style=STY_Translucent
     DrawType=DT_Sprite//Mesh
//     Texture=FireTexture'Effects.Fire.SparkFX1'
     Mesh=Mesh'DeusExItems.FlatFX'
     DrawScale=0.100000
     bUnlit=True
     bCollideWorld=True
     bBounce=True
     bFixedRotationDir=True
}
