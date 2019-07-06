/*---------------------------------------------------------------
   DXRFootStepManager

   This is collection of predefined footstepping sound groups.
   You can change them "on the fly" in game settings.

   Groups are stored as objects in defprops block.
   You can add new groups o remove them.
   You can mix sounds from existing groups, just add new and define
   sounds.
   You must create new .uax package with custom sounds.
---------------------------------------------------------------*/
class DXRFootStepManager extends DXRSoundBase DependsOn(Actor);

// ToDo: Подхватить пакет со звуками?

// All sound sets are stored in this array, in defprops block.
var() array <FootSteppingSoundSet> Collection;

/* Returns predefined sounds set name */
static function string GetSoundsSetName(int Index)
{return default.Collection[Index].CollectionName;}

/*
   Return list of predefined groups.
*/
static function array<string> GetAllSoundSets()
{
  local array<string> Sets;
  local int x;

	for (x = 0; x < default.Collection.Length; x++ )
		Sets[Sets.Length] = default.Collection[x].CollectionName;

  return Sets;
}


static function Sound GetStepWater(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StepWater);
   return default.Collection[Index].StepWater[Rand(i)];
}
/*-----------------------------------------------------------*/

static function Sound GetStepTextile(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StepTextile);
   return default.Collection[Index].StepTextile[Rand(i)];
}

static function Sound GetStepPaper(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StepPaper);
   return default.Collection[Index].StepPaper[Rand(i)];
}
/*-----------------------------------------------------------*/
static function Sound GetFoliageStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].FoliageStep);
   return default.Collection[Index].FoliageStep[Rand(i)];
}

static function Sound GetEarthStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].EarthStep);
   return default.Collection[Index].EarthStep[Rand(i)];
}
/*-----------------------------------------------------------*/
static function Sound GetMetalStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].MetalStep);
   return default.Collection[Index].MetalStep[Rand(i)];
}
/*-----------------------------------------------------------*/
static function Sound GetLadderStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].LadderStep);
   return default.Collection[Index].LadderStep[Rand(i)];
}

static function Sound GetWoodLadderStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].WoodLadderStep);
   return default.Collection[Index].WoodLadderStep[Rand(i)];
}
/*-----------------------------------------------------------*/
static function Sound GetCeramicStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].CeramicStep);
   return default.Collection[Index].CeramicStep[Rand(i)];
}

static function Sound GetGlassStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].GlassStep);
   return default.Collection[Index].GlassStep[Rand(i)];
}

static function Sound GetTilesStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].TilesStep);
   return default.Collection[Index].TilesStep[Rand(i)];
}
/*-----------------------------------------------------------*/

static function Sound GetWoodStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].WoodStep);
   return default.Collection[Index].WoodStep[Rand(i)];
}
/*-----------------------------------------------------------*/
static function Sound GetBrickStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].BrickStep);
   return default.Collection[Index].BrickStep[Rand(i)];
}

static function Sound GetConcreteStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].ConcreteStep);
   return default.Collection[Index].ConcreteStep[Rand(i)];
}

static function Sound GetStoneStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StoneStep);
   return default.Collection[Index].StoneStep[Rand(i)];
}

static function Sound GetStuccoStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StuccoStep);
   return default.Collection[Index].StuccoStep[Rand(i)];
}

static function Sound GetDefaultStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].DefaultStep);
   return default.Collection[Index].DefaultStep[Rand(i)];
}



defaultproperties
{
   Begin Object class=DXRSounds.FootSteppingSoundSet Name=col00

     StepWater[0]=Sound'DeusExSounds.Player.WaterStep1'
     StepWater[1]=Sound'DeusExSounds.Player.WaterStep2'
     StepWater[2]=Sound'DeusExSounds.Player.WaterStep3'
/*--------------------------------------------------------*/
     StepTextile[0]=Sound'DeusExSounds.Player.CarpetStep1'
     StepTextile[1]=Sound'DeusExSounds.Player.CarpetStep2'
     StepTextile[2]=Sound'DeusExSounds.Player.CarpetStep3'
     StepTextile[3]=Sound'DeusExSounds.Player.CarpetStep4'

     StepPaper[0]=Sound'DeusExSounds.Player.CarpetStep1'
     StepPaper[1]=Sound'DeusExSounds.Player.CarpetStep2'
     StepPaper[2]=Sound'DeusExSounds.Player.CarpetStep3'
     StepPaper[3]=Sound'DeusExSounds.Player.CarpetStep4'
/*--------------------------------------------------------*/
     FoliageStep[0]=Sound'DeusExSounds.Player.GrassStep1'
     FoliageStep[1]=Sound'DeusExSounds.Player.GrassStep2'
     FoliageStep[2]=Sound'DeusExSounds.Player.GrassStep3'
     FoliageStep[3]=Sound'DeusExSounds.Player.GrassStep4'

     EarthStep[0]=Sound'DeusExSounds.Player.GrassStep1'
     EarthStep[1]=Sound'DeusExSounds.Player.GrassStep2'
     EarthStep[2]=Sound'DeusExSounds.Player.GrassStep3'
     EarthStep[3]=Sound'DeusExSounds.Player.GrassStep4'
/*--------------------------------------------------------*/
     MetalStep[0]=Sound'DeusExSounds.Player.MetalStep1'
     MetalStep[1]=Sound'DeusExSounds.Player.MetalStep2'
     MetalStep[2]=Sound'DeusExSounds.Player.MetalStep3'
     MetalStep[3]=Sound'DeusExSounds.Player.MetalStep4'
/*--------------------------------------------------------*/
     LadderStep[0]=Sound'STALKER_Sounds.Player.pl_Ladder1'
     LadderStep[1]=Sound'STALKER_Sounds.Player.pl_Ladder2'
     LadderStep[2]=Sound'STALKER_Sounds.Player.pl_Ladder3'
     LadderStep[3]=Sound'STALKER_Sounds.Player.pl_Ladder4'

     WoodLadderStep[0]=Sound'STALKER_Sounds.Player.pl_Ladder1'
     WoodLadderStep[1]=Sound'STALKER_Sounds.Player.pl_Ladder2'
     WoodLadderStep[2]=Sound'STALKER_Sounds.Player.pl_Ladder3'
     WoodLadderStep[3]=Sound'STALKER_Sounds.Player.pl_Ladder4'
/*--------------------------------------------------------*/
     CeramicStep[0]=Sound'DeusExSounds.Player.TileStep1'
     CeramicStep[1]=Sound'DeusExSounds.Player.TileStep2'
     CeramicStep[2]=Sound'DeusExSounds.Player.TileStep3'
     CeramicStep[3]=Sound'DeusExSounds.Player.TileStep4'

     GlassStep[0]=Sound'DeusExSounds.Player.TileStep1'
     GlassStep[1]=Sound'DeusExSounds.Player.TileStep2'
     GlassStep[2]=Sound'DeusExSounds.Player.TileStep3'
     GlassStep[3]=Sound'DeusExSounds.Player.TileStep4'

     TilesStep[0]=Sound'DeusExSounds.Player.TileStep1'
     TilesStep[1]=Sound'DeusExSounds.Player.TileStep2'
     TilesStep[2]=Sound'DeusExSounds.Player.TileStep3'
     TilesStep[3]=Sound'DeusExSounds.Player.TileStep4'
/*--------------------------------------------------------*/
     WoodStep[0]=Sound'DeusExSounds.Player.WoodStep1'
     WoodStep[1]=Sound'DeusExSounds.Player.WoodStep2'
     WoodStep[2]=Sound'DeusExSounds.Player.WoodStep3'
     WoodStep[3]=Sound'DeusExSounds.Player.WoodStep4'
/*--------------------------------------------------------*/
     BrickStep[0]=Sound'DeusExSounds.Player.StoneStep1'
     BrickStep[1]=Sound'DeusExSounds.Player.StoneStep2'
     BrickStep[2]=Sound'DeusExSounds.Player.StoneStep3'
     BrickStep[3]=Sound'DeusExSounds.Player.StoneStep4'

     ConcreteStep[0]=Sound'DeusExSounds.Player.StoneStep1'
     ConcreteStep[1]=Sound'DeusExSounds.Player.StoneStep2'
     ConcreteStep[2]=Sound'DeusExSounds.Player.StoneStep3'
     ConcreteStep[3]=Sound'DeusExSounds.Player.StoneStep4'

     StoneStep[0]=Sound'DeusExSounds.Player.StoneStep1'
     StoneStep[1]=Sound'DeusExSounds.Player.StoneStep2'
     StoneStep[2]=Sound'DeusExSounds.Player.StoneStep3'
     StoneStep[3]=Sound'DeusExSounds.Player.StoneStep4'

     StuccoStep[0]=Sound'DeusExSounds.Player.StoneStep1'
     StuccoStep[1]=Sound'DeusExSounds.Player.StoneStep2'
     StuccoStep[2]=Sound'DeusExSounds.Player.StoneStep3'
     StuccoStep[3]=Sound'DeusExSounds.Player.StoneStep4'

     DefaultStep[0]=Sound'DeusExSounds.Player.StoneStep1'
     DefaultStep[1]=Sound'DeusExSounds.Player.StoneStep2'
     DefaultStep[2]=Sound'DeusExSounds.Player.StoneStep3'
     DefaultStep[3]=Sound'DeusExSounds.Player.StoneStep4'
/*--------------------------------------------------------*/
     CollectionName="Default"
   End Object
   Collection(0)=col00

/*---------------------------------------------------------------*/

   Begin Object class=DXRSounds.FootSteppingSoundSet Name=col01

     StepWater[0]=Sound'DeusExSounds.Player.WaterStep1'
     StepWater[1]=Sound'DeusExSounds.Player.WaterStep2'
     StepWater[2]=Sound'DeusExSounds.Player.WaterStep3'
/*--------------------------------------------------------*/
     StepTextile[0]=Sound'DeusExSounds.Player.CarpetStep1'
     StepTextile[1]=Sound'DeusExSounds.Player.CarpetStep2'
     StepTextile[2]=Sound'DeusExSounds.Player.CarpetStep3'
     StepTextile[3]=Sound'DeusExSounds.Player.CarpetStep4'

     StepPaper[0]=Sound'DeusExSounds.Player.CarpetStep1'
     StepPaper[1]=Sound'DeusExSounds.Player.CarpetStep2'
     StepPaper[2]=Sound'DeusExSounds.Player.CarpetStep3'
     StepPaper[3]=Sound'DeusExSounds.Player.CarpetStep4'
/*--------------------------------------------------------*/
     FoliageStep[0]=Sound'DeusExSounds.Player.GrassStep1'
     FoliageStep[1]=Sound'DeusExSounds.Player.GrassStep2'
     FoliageStep[2]=Sound'DeusExSounds.Player.GrassStep3'
     FoliageStep[3]=Sound'DeusExSounds.Player.GrassStep4'

     EarthStep[0]=Sound'STALKER_Sounds.Player.DIRT1'
     EarthStep[1]=Sound'STALKER_Sounds.Player.DIRT2'
     EarthStep[2]=Sound'STALKER_Sounds.Player.DIRT3'
     EarthStep[3]=Sound'STALKER_Sounds.Player.DIRT4'
/*--------------------------------------------------------*/
     MetalStep[0]=Sound'DeusExSounds.Player.MetalStep1'
     MetalStep[1]=Sound'DeusExSounds.Player.MetalStep2'
     MetalStep[2]=Sound'DeusExSounds.Player.MetalStep3'
     MetalStep[3]=Sound'DeusExSounds.Player.MetalStep4'
/*--------------------------------------------------------*/
     LadderStep[0]=Sound'STALKER_Sounds.Player.pl_Ladder1'
     LadderStep[1]=Sound'STALKER_Sounds.Player.pl_Ladder2'
     LadderStep[2]=Sound'STALKER_Sounds.Player.pl_Ladder3'
     LadderStep[3]=Sound'STALKER_Sounds.Player.pl_Ladder4'

     WoodLadderStep[0]=Sound'STALKER_Sounds.Player.pl_Ladder1'
     WoodLadderStep[1]=Sound'STALKER_Sounds.Player.pl_Ladder2'
     WoodLadderStep[2]=Sound'STALKER_Sounds.Player.pl_Ladder3'
     WoodLadderStep[3]=Sound'STALKER_Sounds.Player.pl_Ladder4'
/*--------------------------------------------------------*/
     CeramicStep[0]=Sound'DeusExSounds.Player.TileStep1'
     CeramicStep[1]=Sound'DeusExSounds.Player.TileStep2'
     CeramicStep[2]=Sound'DeusExSounds.Player.TileStep3'
     CeramicStep[3]=Sound'DeusExSounds.Player.TileStep4'

     GlassStep[0]=Sound'STALKER_Sounds.Player.GLASS1'
     GlassStep[1]=Sound'STALKER_Sounds.Player.GLASS2'
     GlassStep[2]=Sound'STALKER_Sounds.Player.GLASS3'
     GlassStep[3]=Sound'STALKER_Sounds.Player.GLASS4'

     TilesStep[0]=Sound'DeusExSounds.Player.TileStep1'
     TilesStep[1]=Sound'DeusExSounds.Player.TileStep2'
     TilesStep[2]=Sound'DeusExSounds.Player.TileStep3'
     TilesStep[3]=Sound'DeusExSounds.Player.TileStep4'
/*--------------------------------------------------------*/
     WoodStep[0]=Sound'DeusExSounds.Player.WoodStep1'
     WoodStep[1]=Sound'DeusExSounds.Player.WoodStep2'
     WoodStep[2]=Sound'DeusExSounds.Player.WoodStep3'
     WoodStep[3]=Sound'DeusExSounds.Player.WoodStep4'
/*--------------------------------------------------------*/
     BrickStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     BrickStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     BrickStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     BrickStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'

     ConcreteStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     ConcreteStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     ConcreteStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     ConcreteStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'

     StoneStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     StoneStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     StoneStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     StoneStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'

     StuccoStep[0]=Sound'STALKER_Sounds.Player.CARDB1'
     StuccoStep[1]=Sound'STALKER_Sounds.Player.CARDB2'
     StuccoStep[2]=Sound'STALKER_Sounds.Player.CARDB3'
     StuccoStep[3]=Sound'STALKER_Sounds.Player.CARDB4'

     DefaultStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     DefaultStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     DefaultStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     DefaultStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'
/*--------------------------------------------------------*/

     CollectionName="GMDX"
   End Object
   Collection(1)=col01

/*---------------------------------------------------------------*/
   Begin Object class=DXRSounds.FootSteppingSoundSet Name=col02

     StepWater[0]=Sound'DeusExSounds.Player.WaterStep1'
     StepWater[1]=Sound'DeusExSounds.Player.WaterStep2'
     StepWater[2]=Sound'DeusExSounds.Player.WaterStep3'
/*--------------------------------------------------------*/
     StepTextile[0]=Sound'DeusExSounds.Player.CarpetStep1'
     StepTextile[1]=Sound'DeusExSounds.Player.CarpetStep2'
     StepTextile[2]=Sound'DeusExSounds.Player.CarpetStep3'
     StepTextile[3]=Sound'DeusExSounds.Player.CarpetStep4'

     StepPaper[0]=Sound'DeusExSounds.Player.CarpetStep1'
     StepPaper[1]=Sound'DeusExSounds.Player.CarpetStep2'
     StepPaper[2]=Sound'DeusExSounds.Player.CarpetStep3'
     StepPaper[3]=Sound'DeusExSounds.Player.CarpetStep4'
/*--------------------------------------------------------*/
     FoliageStep[0]=Sound'STALKER_Sounds.Player.t_bush1'
     FoliageStep[1]=Sound'STALKER_Sounds.Player.t_bush2'
     FoliageStep[2]=Sound'STALKER_Sounds.Player.t_bush3'
     FoliageStep[3]=Sound'STALKER_Sounds.Player.t_bush4'

     EarthStep[0]=Sound'STALKER_Sounds.Player.t_gravel1'
     EarthStep[1]=Sound'STALKER_Sounds.Player.t_gravel2'
     EarthStep[2]=Sound'STALKER_Sounds.Player.t_gravel3'
     EarthStep[3]=Sound'STALKER_Sounds.Player.t_gravel4'
/*--------------------------------------------------------*/
     MetalStep[0]=Sound'STALKER_Sounds.Player.Metal_plate1'
     MetalStep[1]=Sound'STALKER_Sounds.Player.Metal_plate2'
     MetalStep[2]=Sound'STALKER_Sounds.Player.Metal_plate3'
     MetalStep[3]=Sound'STALKER_Sounds.Player.Metal_plate4'
/*--------------------------------------------------------*/
     LadderStep[0]=Sound'STALKER_Sounds.Player.pl_Ladder1'
     LadderStep[1]=Sound'STALKER_Sounds.Player.pl_Ladder2'
     LadderStep[2]=Sound'STALKER_Sounds.Player.pl_Ladder3'
     LadderStep[3]=Sound'STALKER_Sounds.Player.pl_Ladder4'

     WoodLadderStep[0]=Sound'STALKER_Sounds.Player.pl_Ladder1'
     WoodLadderStep[1]=Sound'STALKER_Sounds.Player.pl_Ladder2'
     WoodLadderStep[2]=Sound'STALKER_Sounds.Player.pl_Ladder3'
     WoodLadderStep[3]=Sound'STALKER_Sounds.Player.pl_Ladder4'
/*--------------------------------------------------------*/
     CeramicStep[0]=Sound'DeusExSounds.Player.TileStep1'
     CeramicStep[1]=Sound'DeusExSounds.Player.TileStep2'
     CeramicStep[2]=Sound'DeusExSounds.Player.TileStep3'
     CeramicStep[3]=Sound'DeusExSounds.Player.TileStep4'

     GlassStep[0]=Sound'STALKER_Sounds.Player.GLASS1'
     GlassStep[1]=Sound'STALKER_Sounds.Player.GLASS2'
     GlassStep[2]=Sound'STALKER_Sounds.Player.GLASS3'
     GlassStep[3]=Sound'STALKER_Sounds.Player.GLASS4'

     TilesStep[0]=Sound'DeusExSounds.Player.TileStep1'
     TilesStep[1]=Sound'DeusExSounds.Player.TileStep2'
     TilesStep[2]=Sound'DeusExSounds.Player.TileStep3'
     TilesStep[3]=Sound'DeusExSounds.Player.TileStep4'
/*--------------------------------------------------------*/
     WoodStep[0]=Sound'STALKER_Sounds.Player.WLStep1'
     WoodStep[1]=Sound'STALKER_Sounds.Player.WLStep2'
     WoodStep[2]=Sound'STALKER_Sounds.Player.WLStep3'
     WoodStep[3]=Sound'STALKER_Sounds.Player.WLStep4'
/*--------------------------------------------------------*/
     BrickStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     BrickStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     BrickStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     BrickStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'

     ConcreteStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     ConcreteStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     ConcreteStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     ConcreteStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'

     StoneStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     StoneStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     StoneStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     StoneStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'

     StuccoStep[0]=Sound'STALKER_Sounds.Player.CARDB1'
     StuccoStep[1]=Sound'STALKER_Sounds.Player.CARDB2'
     StuccoStep[2]=Sound'STALKER_Sounds.Player.CARDB3'
     StuccoStep[3]=Sound'STALKER_Sounds.Player.CARDB4'

     DefaultStep[0]=Sound'STALKER_Sounds.Player.concrete_ct_01'
     DefaultStep[1]=Sound'STALKER_Sounds.Player.concrete_ct_02'
     DefaultStep[2]=Sound'STALKER_Sounds.Player.concrete_ct_03'
     DefaultStep[3]=Sound'STALKER_Sounds.Player.concrete_ct_04'

     CollectionName="S.T.A.L.K.E.R."
   End Object
   Collection(2)=col02
/*---------------------------------------------------------------*/
}











