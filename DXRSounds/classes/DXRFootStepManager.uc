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
   return Sound(DynamicLoadObject(default.Collection[Index].StepWater[Rand(i)],class'Sound',true));
}
/*-----------------------------------------------------------*/

static function Sound GetStepTextile(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StepTextile);
   return Sound(DynamicLoadObject(default.Collection[Index].StepTextile[Rand(i)],class'Sound',true));
}

static function Sound GetStepPaper(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StepPaper);
   return Sound(DynamicLoadObject(default.Collection[Index].StepPaper[Rand(i)],class'Sound',true));
}
/*-----------------------------------------------------------*/
static function Sound GetFoliageStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].FoliageStep);
   return Sound(DynamicLoadObject(default.Collection[Index].FoliageStep[Rand(i)],class'Sound',true));
}

static function Sound GetEarthStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].EarthStep);
   return Sound(DynamicLoadObject(default.Collection[Index].EarthStep[Rand(i)],class'Sound',true));
}
/*-----------------------------------------------------------*/
static function Sound GetMetalStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].MetalStep);
   return Sound(DynamicLoadObject(default.Collection[Index].MetalStep[Rand(i)],class'Sound',true));
}
/*-----------------------------------------------------------*/
static function Sound GetLadderStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].LadderStep);
   return Sound(DynamicLoadObject(default.Collection[Index].LadderStep[Rand(i)],class'Sound',true));
}

static function Sound GetWoodLadderStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].WoodLadderStep);
   return Sound(DynamicLoadObject(default.Collection[Index].WoodLadderStep[Rand(i)],class'Sound',true));
}
/*-----------------------------------------------------------*/
static function Sound GetCeramicStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].CeramicStep);
   return Sound(DynamicLoadObject(default.Collection[Index].CeramicStep[Rand(i)],class'Sound',true));
}

static function Sound GetGlassStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].GlassStep);
   return Sound(DynamicLoadObject(default.Collection[Index].GlassStep[Rand(i)],class'Sound',true));
}

static function Sound GetTilesStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].TilesStep);
   return Sound(DynamicLoadObject(default.Collection[Index].TilesStep[Rand(i)],class'Sound',true));
}
/*-----------------------------------------------------------*/

static function Sound GetWoodStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].WoodStep);
   return Sound(DynamicLoadObject(default.Collection[Index].WoodStep[Rand(i)],class'Sound',true));
}
/*-----------------------------------------------------------*/
static function Sound GetBrickStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].BrickStep);
   return Sound(DynamicLoadObject(default.Collection[Index].BrickStep[Rand(i)],class'Sound',true));
}

static function Sound GetConcreteStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].ConcreteStep);
   return Sound(DynamicLoadObject(default.Collection[Index].ConcreteStep[Rand(i)],class'Sound',true));
}

static function Sound GetStoneStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StoneStep);
   return Sound(DynamicLoadObject(default.Collection[Index].StoneStep[Rand(i)],class'Sound',true));
}

static function Sound GetStuccoStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].StuccoStep);
   return Sound(DynamicLoadObject(default.Collection[Index].StuccoStep[Rand(i)],class'Sound',true));
}

static function Sound GetDefaultStep(int Index)
{
   local int i;

   i = ArrayCount(default.Collection[Index].DefaultStep);
   return Sound(DynamicLoadObject(default.Collection[Index].DefaultStep[Rand(i)],class'Sound',true));
}



defaultproperties
{
   Begin Object class=DXRSounds.FootSteppingSoundSet Name=col00

     StepWater[0]="DeusExSounds.Player.WaterStep1"
     StepWater[1]="DeusExSounds.Player.WaterStep2"
     StepWater[2]="DeusExSounds.Player.WaterStep3"
/*--------------------------------------------------------*/
     StepTextile[0]="DeusExSounds.Player.CarpetStep1"
     StepTextile[1]="DeusExSounds.Player.CarpetStep2"
     StepTextile[2]="DeusExSounds.Player.CarpetStep3"
     StepTextile[3]="DeusExSounds.Player.CarpetStep4"

     StepPaper[0]="DeusExSounds.Player.CarpetStep1"
     StepPaper[1]="DeusExSounds.Player.CarpetStep2"
     StepPaper[2]="DeusExSounds.Player.CarpetStep3"
     StepPaper[3]="DeusExSounds.Player.CarpetStep4"
/*--------------------------------------------------------*/
     FoliageStep[0]="DeusExSounds.Player.GrassStep1"
     FoliageStep[1]="DeusExSounds.Player.GrassStep2"
     FoliageStep[2]="DeusExSounds.Player.GrassStep3"
     FoliageStep[3]="DeusExSounds.Player.GrassStep4"

     EarthStep[0]="DeusExSounds.Player.GrassStep1"
     EarthStep[1]="DeusExSounds.Player.GrassStep2"
     EarthStep[2]="DeusExSounds.Player.GrassStep3"
     EarthStep[3]="DeusExSounds.Player.GrassStep4"
/*--------------------------------------------------------*/
     MetalStep[0]="DeusExSounds.Player.MetalStep1"
     MetalStep[1]="DeusExSounds.Player.MetalStep2"
     MetalStep[2]="DeusExSounds.Player.MetalStep3"
     MetalStep[3]="DeusExSounds.Player.MetalStep4"
/*--------------------------------------------------------*/
     LadderStep[0]="STALKER_Sounds.Player.pl_Ladder1"
     LadderStep[1]="STALKER_Sounds.Player.pl_Ladder2"
     LadderStep[2]="STALKER_Sounds.Player.pl_Ladder3"
     LadderStep[3]="STALKER_Sounds.Player.pl_Ladder4"

     WoodLadderStep[0]="STALKER_Sounds.Player.pl_Ladder1"
     WoodLadderStep[1]="STALKER_Sounds.Player.pl_Ladder2"
     WoodLadderStep[2]="STALKER_Sounds.Player.pl_Ladder3"
     WoodLadderStep[3]="STALKER_Sounds.Player.pl_Ladder4"
/*--------------------------------------------------------*/
     CeramicStep[0]="DeusExSounds.Player.TileStep1"
     CeramicStep[1]="DeusExSounds.Player.TileStep2"
     CeramicStep[2]="DeusExSounds.Player.TileStep3"
     CeramicStep[3]="DeusExSounds.Player.TileStep4"

     GlassStep[0]="DeusExSounds.Player.TileStep1"
     GlassStep[1]="DeusExSounds.Player.TileStep2"
     GlassStep[2]="DeusExSounds.Player.TileStep3"
     GlassStep[3]="DeusExSounds.Player.TileStep4"

     TilesStep[0]="DeusExSounds.Player.TileStep1"
     TilesStep[1]="DeusExSounds.Player.TileStep2"
     TilesStep[2]="DeusExSounds.Player.TileStep3"
     TilesStep[3]="DeusExSounds.Player.TileStep4"
/*--------------------------------------------------------*/
     WoodStep[0]="DeusExSounds.Player.WoodStep1"
     WoodStep[1]="DeusExSounds.Player.WoodStep2"
     WoodStep[2]="DeusExSounds.Player.WoodStep3"
     WoodStep[3]="DeusExSounds.Player.WoodStep4"
/*--------------------------------------------------------*/
     BrickStep[0]="DeusExSounds.Player.StoneStep1"
     BrickStep[1]="DeusExSounds.Player.StoneStep2"
     BrickStep[2]="DeusExSounds.Player.StoneStep3"
     BrickStep[3]="DeusExSounds.Player.StoneStep4"

     ConcreteStep[0]="DeusExSounds.Player.StoneStep1"
     ConcreteStep[1]="DeusExSounds.Player.StoneStep2"
     ConcreteStep[2]="DeusExSounds.Player.StoneStep3"
     ConcreteStep[3]="DeusExSounds.Player.StoneStep4"

     StoneStep[0]="DeusExSounds.Player.StoneStep1"
     StoneStep[1]="DeusExSounds.Player.StoneStep2"
     StoneStep[2]="DeusExSounds.Player.StoneStep3"
     StoneStep[3]="DeusExSounds.Player.StoneStep4"

     StuccoStep[0]="DeusExSounds.Player.StoneStep1"
     StuccoStep[1]="DeusExSounds.Player.StoneStep2"
     StuccoStep[2]="DeusExSounds.Player.StoneStep3"
     StuccoStep[3]="DeusExSounds.Player.StoneStep4"

     DefaultStep[0]="DeusExSounds.Player.StoneStep1"
     DefaultStep[1]="DeusExSounds.Player.StoneStep2"
     DefaultStep[2]="DeusExSounds.Player.StoneStep3"
     DefaultStep[3]="DeusExSounds.Player.StoneStep4"
/*--------------------------------------------------------*/
     CollectionName="Default"
   End Object
   Collection(0)=col00

/*---------------------------------------------------------------*/

   Begin Object class=DXRSounds.FootSteppingSoundSet Name=col01

     StepWater[0]="DeusExSounds.Player.WaterStep1"
     StepWater[1]="DeusExSounds.Player.WaterStep2"
     StepWater[2]="DeusExSounds.Player.WaterStep3"
/*--------------------------------------------------------*/
     StepTextile[0]="DeusExSounds.Player.CarpetStep1"
     StepTextile[1]="DeusExSounds.Player.CarpetStep2"
     StepTextile[2]="DeusExSounds.Player.CarpetStep3"
     StepTextile[3]="DeusExSounds.Player.CarpetStep4"

     StepPaper[0]="DeusExSounds.Player.CarpetStep1"
     StepPaper[1]="DeusExSounds.Player.CarpetStep2"
     StepPaper[2]="DeusExSounds.Player.CarpetStep3"
     StepPaper[3]="DeusExSounds.Player.CarpetStep4"
/*--------------------------------------------------------*/
     FoliageStep[0]="DeusExSounds.Player.GrassStep1"
     FoliageStep[1]="DeusExSounds.Player.GrassStep2"
     FoliageStep[2]="DeusExSounds.Player.GrassStep3"
     FoliageStep[3]="DeusExSounds.Player.GrassStep4"

     EarthStep[0]="STALKER_Sounds.Player.DIRT1"
     EarthStep[1]="STALKER_Sounds.Player.DIRT2"
     EarthStep[2]="STALKER_Sounds.Player.DIRT3"
     EarthStep[3]="STALKER_Sounds.Player.DIRT4"
/*--------------------------------------------------------*/
     MetalStep[0]="DeusExSounds.Player.MetalStep1"
     MetalStep[1]="DeusExSounds.Player.MetalStep2"
     MetalStep[2]="DeusExSounds.Player.MetalStep3"
     MetalStep[3]="DeusExSounds.Player.MetalStep4"
/*--------------------------------------------------------*/
     LadderStep[0]="STALKER_Sounds.Player.pl_Ladder1"
     LadderStep[1]="STALKER_Sounds.Player.pl_Ladder2"
     LadderStep[2]="STALKER_Sounds.Player.pl_Ladder3"
     LadderStep[3]="STALKER_Sounds.Player.pl_Ladder4"

     WoodLadderStep[0]="STALKER_Sounds.Player.pl_Ladder1"
     WoodLadderStep[1]="STALKER_Sounds.Player.pl_Ladder2"
     WoodLadderStep[2]="STALKER_Sounds.Player.pl_Ladder3"
     WoodLadderStep[3]="STALKER_Sounds.Player.pl_Ladder4"
/*--------------------------------------------------------*/
     CeramicStep[0]="DeusExSounds.Player.TileStep1"
     CeramicStep[1]="DeusExSounds.Player.TileStep2"
     CeramicStep[2]="DeusExSounds.Player.TileStep3"
     CeramicStep[3]="DeusExSounds.Player.TileStep4"

     GlassStep[0]="STALKER_Sounds.Player.GLASS1"
     GlassStep[1]="STALKER_Sounds.Player.GLASS2"
     GlassStep[2]="STALKER_Sounds.Player.GLASS3"
     GlassStep[3]="STALKER_Sounds.Player.GLASS4"

     TilesStep[0]="DeusExSounds.Player.TileStep1"
     TilesStep[1]="DeusExSounds.Player.TileStep2"
     TilesStep[2]="DeusExSounds.Player.TileStep3"
     TilesStep[3]="DeusExSounds.Player.TileStep4"
/*--------------------------------------------------------*/
     WoodStep[0]="DeusExSounds.Player.WoodStep1"
     WoodStep[1]="DeusExSounds.Player.WoodStep2"
     WoodStep[2]="DeusExSounds.Player.WoodStep3"
     WoodStep[3]="DeusExSounds.Player.WoodStep4"
/*--------------------------------------------------------*/
     BrickStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     BrickStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     BrickStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     BrickStep[3]="STALKER_Sounds.Player.concrete_ct_04"

     ConcreteStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     ConcreteStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     ConcreteStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     ConcreteStep[3]="STALKER_Sounds.Player.concrete_ct_04"

     StoneStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     StoneStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     StoneStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     StoneStep[3]="STALKER_Sounds.Player.concrete_ct_04"

     StuccoStep[0]="STALKER_Sounds.Player.CARDB1"
     StuccoStep[1]="STALKER_Sounds.Player.CARDB2"
     StuccoStep[2]="STALKER_Sounds.Player.CARDB3"
     StuccoStep[3]="STALKER_Sounds.Player.CARDB4"

     DefaultStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     DefaultStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     DefaultStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     DefaultStep[3]="STALKER_Sounds.Player.concrete_ct_04"
/*--------------------------------------------------------*/

     CollectionName="GMDX"
   End Object
   Collection(1)=col01

/*---------------------------------------------------------------*/
   Begin Object class=DXRSounds.FootSteppingSoundSet Name=col02

     StepWater[0]="DeusExSounds.Player.WaterStep1"
     StepWater[1]="DeusExSounds.Player.WaterStep2"
     StepWater[2]="DeusExSounds.Player.WaterStep3"
/*--------------------------------------------------------*/
     StepTextile[0]="DeusExSounds.Player.CarpetStep1"
     StepTextile[1]="DeusExSounds.Player.CarpetStep2"
     StepTextile[2]="DeusExSounds.Player.CarpetStep3"
     StepTextile[3]="DeusExSounds.Player.CarpetStep4"

     StepPaper[0]="DeusExSounds.Player.CarpetStep1"
     StepPaper[1]="DeusExSounds.Player.CarpetStep2"
     StepPaper[2]="DeusExSounds.Player.CarpetStep3"
     StepPaper[3]="DeusExSounds.Player.CarpetStep4"
/*--------------------------------------------------------*/
     FoliageStep[0]="STALKER_Sounds.Player.t_bush1"
     FoliageStep[1]="STALKER_Sounds.Player.t_bush2"
     FoliageStep[2]="STALKER_Sounds.Player.t_bush3"
     FoliageStep[3]="STALKER_Sounds.Player.t_bush4"

     EarthStep[0]="STALKER_Sounds.Player.t_gravel1"
     EarthStep[1]="STALKER_Sounds.Player.t_gravel2"
     EarthStep[2]="STALKER_Sounds.Player.t_gravel3"
     EarthStep[3]="STALKER_Sounds.Player.t_gravel4"
/*--------------------------------------------------------*/
     MetalStep[0]="STALKER_Sounds.Player.Metal_plate1"
     MetalStep[1]="STALKER_Sounds.Player.Metal_plate2"
     MetalStep[2]="STALKER_Sounds.Player.Metal_plate3"
     MetalStep[3]="STALKER_Sounds.Player.Metal_plate4"
/*--------------------------------------------------------*/
     LadderStep[0]="STALKER_Sounds.Player.pl_Ladder1"
     LadderStep[1]="STALKER_Sounds.Player.pl_Ladder2"
     LadderStep[2]="STALKER_Sounds.Player.pl_Ladder3"
     LadderStep[3]="STALKER_Sounds.Player.pl_Ladder4"

     WoodLadderStep[0]="STALKER_Sounds.Player.pl_Ladder1"
     WoodLadderStep[1]="STALKER_Sounds.Player.pl_Ladder2"
     WoodLadderStep[2]="STALKER_Sounds.Player.pl_Ladder3"
     WoodLadderStep[3]="STALKER_Sounds.Player.pl_Ladder4"
/*--------------------------------------------------------*/
     CeramicStep[0]="DeusExSounds.Player.TileStep1"
     CeramicStep[1]="DeusExSounds.Player.TileStep2"
     CeramicStep[2]="DeusExSounds.Player.TileStep3"
     CeramicStep[3]="DeusExSounds.Player.TileStep4"

     GlassStep[0]="STALKER_Sounds.Player.GLASS1"
     GlassStep[1]="STALKER_Sounds.Player.GLASS2"
     GlassStep[2]="STALKER_Sounds.Player.GLASS3"
     GlassStep[3]="STALKER_Sounds.Player.GLASS4"

     TilesStep[0]="DeusExSounds.Player.TileStep1"
     TilesStep[1]="DeusExSounds.Player.TileStep2"
     TilesStep[2]="DeusExSounds.Player.TileStep3"
     TilesStep[3]="DeusExSounds.Player.TileStep4"
/*--------------------------------------------------------*/
     WoodStep[0]="STALKER_Sounds.Player.WLStep1"
     WoodStep[1]="STALKER_Sounds.Player.WLStep2"
     WoodStep[2]="STALKER_Sounds.Player.WLStep3"
     WoodStep[3]="STALKER_Sounds.Player.WLStep4"
/*--------------------------------------------------------*/
     BrickStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     BrickStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     BrickStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     BrickStep[3]="STALKER_Sounds.Player.concrete_ct_04"

     ConcreteStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     ConcreteStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     ConcreteStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     ConcreteStep[3]="STALKER_Sounds.Player.concrete_ct_04"

     StoneStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     StoneStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     StoneStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     StoneStep[3]="STALKER_Sounds.Player.concrete_ct_04"

     StuccoStep[0]="STALKER_Sounds.Player.CARDB1"
     StuccoStep[1]="STALKER_Sounds.Player.CARDB2"
     StuccoStep[2]="STALKER_Sounds.Player.CARDB3"
     StuccoStep[3]="STALKER_Sounds.Player.CARDB4"

     DefaultStep[0]="STALKER_Sounds.Player.concrete_ct_01"
     DefaultStep[1]="STALKER_Sounds.Player.concrete_ct_02"
     DefaultStep[2]="STALKER_Sounds.Player.concrete_ct_03"
     DefaultStep[3]="STALKER_Sounds.Player.concrete_ct_04"

     CollectionName="S.T.A.L.K.E.R."
   End Object
   Collection(2)=col02
/*---------------------------------------------------------------*/
}











