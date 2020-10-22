//=============================================================================
// Spark.
//=============================================================================
class Spark extends Effects;

#exec OBJ LOAD FILE=Effects

var float TraceMult;

var Rotator rot;
var Sound Metal[4]; // metal_impact
var Sound Wood[4]; //?
var Sound Textile[4];
var sound Paper[4]; // paper_impact
var sound Foliage[4]; // earth_impact
var sound Earth[4]; // sand_impact
var sound Ceramic[4];
var sound Glass[4]; // glass_impact
var sound Tiles[4]; // tile_impact
var sound Brick[4]; // brick_impact_hard
var sound Concrete[4]; //concrete_impact
var sound Stone[4];
var sound Stucco[4];
var sound Snow[4];
var sound Plastic[4];
var sound FallBack[4];


function SpawnDecal(Name DecalName, vector HitLoc, vector HitNormal)
{
   local BulletHole hole;
   local GlassCrack crack;
   local WoodCrack wCrack;
   local MetalDent dent;
   local ConcreteCrack keyGen;
   local EarthHit eh;
   local BrickHit br;

   if (ExcludeTag[7] == 'NoDecal')
       return;

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

// Создать эффект попадания по Actor (DeusExDecoration?)
// Примечание: лучше всего это будет работать с цилиндрическими декорациями!
function SpawnActorEffect(Actor Actor, vector Loc)
{
   if (Actor == None)
       return;

   if (Actor.IsA('BarrelFire') || Actor.IsA('CrateUnbreakableSmall') || Actor.IsA('CrateUnbreakableMed') || Actor.IsA('CrateUnbreakableLarge') ||
      (Actor.IsA('Barrel1a') && Barrel1a(Actor).SkinColor != SC_Wood) || Actor.IsA('FirePlug') || Actor.IsA('Trashcans') || Actor.IsA('SecurityCamera'))
   {
      Spawn(class'EM_MetalHit',,,Loc,);
      PlayActorSound('Metal');
   }
   else if (Actor.IsA('RoadBlock'))
   {
      Spawn(class'EM_ConcreteHit',,,Loc,);
      PlayActorSound('Ceramic');
   }
   else if (Actor.IsA('CementBag')) // Cement
   {
      Spawn(class'EM_ConcreteHit_a',,,Loc,);
      PlayActorSound('Ceramic');
   }
   else if (Actor.IsA('Toilet2a') || Actor.IsA('Toilet'))
   {
      //Spawn(class'EM_ConcreteHit',,,Loc,); // looks SCARY!
      PlayActorSound('Ceramic');
   }
   else if (Actor.IsA('CrateBreakableMedMedical') || Actor.IsA('CrateBreakableMedGeneral') || Actor.IsA('CrateBreakableMedCombat'))
   {
      Spawn(class'EM_WoodHit',,,Loc,);
      PlayActorSound('Wood');      
   }
   else if (Actor.IsA('Trashbag') || Actor.IsA('Trashbag2'))
   {
      Spawn(class'EM_NeutralHit',,,Loc,);
      PlayActorSound('Plastic');      
   }
}

function PlayActorSound(Name EffectGroup)
{
    local sound ActualSound;

    switch(EffectGroup)
    {
        case 'Metal':
            ActualSound = Metal[Rand(4)];
            break;

        case 'Ceramic':
            ActualSound = Ceramic[Rand(4)];
            break;

        case 'Wood':
            ActualSound = Wood[Rand(4)];
            break;

        case 'Plastic':
            ActualSound = plastic[Rand(4)];
            break;

        default:
            ActualSound = FallBack[Rand(4)];
            break;
    }
    PlaySound(ActualSound, SLOT_None,1.2,, /*256*/157,);
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
       Spawn(class'EM_WoodHit_a',,,Loc,);

   if (TypeOfParticles == 'Textile' || TypeOfParticles == 'Paper') // Ткань или бумага
       Spawn(class'EM_ClothHit',,,Loc,);

   if ((TypeOfParticles == 'Brick') || (TypeOfParticles == 'Tiles'))
       Spawn(class'EM_BrickHit_a',,,Loc,);

   if (TypeOfParticles == 'Stucco')
       Spawn(class'EM_StuccoHit_a',,,Loc,);
   
   if (TypeOfParticles == 'Concrete')
       Spawn(class'EM_ConcreteHit_a',,,Loc,);
   
   if (TypeOfParticles == 'Stone')
       Spawn(class'EM_ConcreteHit',,,Loc,);

   if (TypeOfParticles == 'Glass')
       Spawn(class'EM_GlassHit_a',,,Loc,);

   if (TypeOfParticles == 'Wall_Objects') // Стены
       Spawn(class'EM_StuccoHit_a',,,Loc,);
}

function MakeSound()
{
    local Sound ActualSound;
    local Name ImpactMaterial;

    ImpactMaterial = GetImpactMaterial();
        
    switch(ImpactMaterial)
    {
        case 'Textile':
            ActualSound = Textile[Rand(4)];
            break;

        case 'Paper':
            ActualSound = Paper[Rand(4)];
            break;

        case 'Foliage':
            ActualSound = Foliage[Rand(4)];
            break;

        case 'Earth':
            ActualSound = Earth[Rand(4)];
            break;

        case 'Metal':
        case 'Ladder':
            ActualSound = Metal[Rand(4)];
            break;

        case 'Ceramic':
            ActualSound = Ceramic[Rand(4)];
            break;

        case 'Glass':
            ActualSound = Glass[Rand(4)];
            break;

        case 'Tiles':
            ActualSound = Glass[Rand(4)];
            break;

        case 'Wood':
            ActualSound = Wood[Rand(4)];
            break;

        case 'Brick':
            ActualSound = Brick[Rand(4)];
            break;

        case 'Concrete':
            ActualSound = Concrete[Rand(4)];
            break;

        case 'Stone':
            ActualSound = Stone[Rand(4)];
            break;

        case 'Stucco':
        case 'Wall_Objects':
            ActualSound = Stucco[Rand(4)];
            break;

        case 'Plastic':
            ActualSound = plastic[Rand(4)];

        default:
            ActualSound = FallBack[Rand(4)];
            break;
    }
        if (PhysicsVolume.bWaterVolume == false)
            PlaySound(ActualSound, SLOT_None,1.2,, /*256*/157,);
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
begin:
  Sleep(0.0001);
  MakeSound();
} 


function name GetImpactMaterial()
{
    local vector EndTrace, HitLocation, HitNormal;
    local actor target;
    local int texFlags;
    local name texName, texGroup;
    local material mat;

    EndTrace = Location - (Vector(Rotation) * TraceMult);

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
        if (!target.bWorldGeometry)
            SpawnActorEffect(Target, HitLocation);
    }
    return texGroup;
}


defaultproperties
{
     Wood(0)=Sound'DXR_Impact.Wood_impact1'
     Wood(1)=Sound'DXR_Impact.Wood_impact2'
     Wood(2)=Sound'DXR_Impact.Wood_impact3'
     Wood(3)=Sound'DXR_Impact.Wood_impact4'

     Metal[0]=Sound'DXR_Impact.metal_impact1' // metal_impact
     Metal[1]=Sound'DXR_Impact.metal_impact2' // metal_impact
     Metal[2]=Sound'DXR_Impact.metal_impact3' // metal_impact
     Metal[3]=Sound'DXR_Impact.metal_impact4' // metal_impact

     Textile[0]=Sound'DXR_Impact.paper_impact1'
     Textile[1]=Sound'DXR_Impact.paper_impact2'
     Textile[2]=Sound'DXR_Impact.paper_impact3'
     Textile[3]=Sound'DXR_Impact.paper_impact4'

     Paper[0]=Sound'DXR_Impact.paper_impact1' // paper_impact
     Paper[1]=Sound'DXR_Impact.paper_impact2' // paper_impact
     Paper[2]=Sound'DXR_Impact.paper_impact3' // paper_impact
     Paper[3]=Sound'DXR_Impact.paper_impact4' // paper_impact

     Foliage[0]=Sound'DXR_Impact.earth_impact1' // earth_impact
     Foliage[1]=Sound'DXR_Impact.earth_impact2' // earth_impact
     Foliage[2]=Sound'DXR_Impact.earth_impact3' // earth_impact
     Foliage[3]=Sound'DXR_Impact.earth_impact4' // earth_impact

     Earth[0]=Sound'DXR_Impact.gravel_impact1'
     Earth[1]=Sound'DXR_Impact.gravel_impact2'
     Earth[2]=Sound'DXR_Impact.gravel_impact3'
     Earth[3]=Sound'DXR_Impact.gravel_impact4'

     Ceramic[0]=Sound'DXR_Impact.concrete_impact1'
     Ceramic[1]=Sound'DXR_Impact.concrete_impact2'
     Ceramic[2]=Sound'DXR_Impact.concrete_impact3'
     Ceramic[3]=Sound'DXR_Impact.concrete_impact4'

     Glass[0]=Sound'DXR_Impact.glass_impact1' // glass_impact
     Glass[1]=Sound'DXR_Impact.glass_impact2' // glass_impact
     Glass[2]=Sound'DXR_Impact.glass_impact3' // glass_impact
     Glass[3]=Sound'DXR_Impact.glass_impact4' // glass_impact

     Tiles[0]=Sound'DXR_Impact.tile_impact1' // tile_impact
     Tiles[1]=Sound'DXR_Impact.tile_impact2' // tile_impact
     Tiles[2]=Sound'DXR_Impact.tile_impact3' // tile_impact
     Tiles[3]=Sound'DXR_Impact.tile_impact4' // tile_impact

     Brick[0]=Sound'DXR_Impact.brick_impact_hard1' // brick_impact_hard
     Brick[1]=Sound'DXR_Impact.brick_impact_hard2' // brick_impact_hard
     Brick[2]=Sound'DXR_Impact.brick_impact_hard3' // brick_impact_hard
     Brick[3]=Sound'DXR_Impact.brick_impact_hard4' // brick_impact_hard

     Concrete[0]=Sound'DXR_Impact.concrete_impact1' //concrete_impact
     Concrete[1]=Sound'DXR_Impact.concrete_impact2' //concrete_impact
     Concrete[2]=Sound'DXR_Impact.concrete_impact3' //concrete_impact
     Concrete[3]=Sound'DXR_Impact.concrete_impact4' //concrete_impact

     Stone[0]=Sound'DXR_Impact.concrete_impact1'
     Stone[1]=Sound'DXR_Impact.concrete_impact2'
     Stone[2]=Sound'DXR_Impact.concrete_impact3'
     Stone[3]=Sound'DXR_Impact.concrete_impact4'

     Stucco[0]=Sound'DXR_Impact.concrete_impact1'
     Stucco[1]=Sound'DXR_Impact.concrete_impact2'
     Stucco[2]=Sound'DXR_Impact.concrete_impact3'
     Stucco[3]=Sound'DXR_Impact.concrete_impact4'

     Plastic[0]=Sound'DXR_Impact.plastic_impact4'
     Plastic[1]=Sound'DXR_Impact.plastic_impact3'
     Plastic[2]=Sound'DXR_Impact.plastic_impact2'
     Plastic[3]=Sound'DXR_Impact.plastic_impact1'

/*
   ToDo: Заполнить 
     Snow[0];
     Snow[1];
     Snow[2];
     Snow[3];
*/
/*     FallBack(0)=Sound'DXR_Impact.brick_impact_hard1'
     FallBack(1)=Sound'DXR_Impact.brick_impact_hard2'
     FallBack(2)=Sound'DXR_Impact.brick_impact_hard3'
     FallBack(3)=Sound'DXR_Impact.brick_impact_hard4'
*/
     LifeSpan=0.250000
     DrawType=DT_None
     Mesh=Mesh'DeusExItems.FlatFX'
     DrawScale=0.100000
     bUnlit=True
     bCollideWorld=True
     bBounce=True
     bFixedRotationDir=True
     TraceMult=5.0
     Tag="123"
}
