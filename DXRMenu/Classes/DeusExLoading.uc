/*-----------------------------------------
  Map Loading screen
-----------------------------------------*/

class DeusExLoading extends UT2K4ServerLoading;

struct sMapLocalized
{
	var localized string sMapName;
	var localized string sMapCaption;
};

var() array <sMapLocalized> sML;

simulated event Init()
{
  Super.Init();

	DrawOpText(Operations[2]).Text = getMapDesc();
}

function string getMapDesc()
{
  local int z;
  local string TheMap;

  TheMap = StripMap(MapName);

  for(z=0; z<sML.length; z++)
  {
    if (sML[z].sMapName ~= TheMap)
    return sML[z].sMapCaption;
  }
  return StripMap(MapName);
}

defaultproperties
{
/* Training */
   sML(0)=(sMapName="00_Intro",sMapCaption="Intro")
   sML(1)=(sMapName="00_Training",sMapCaption="Training - beginning")
   sML(2)=(sMapName="00_TrainingCombat",sMapCaption="Training - combat")
   sML(3)=(sMapName="00_TrainingFinal",sMapCaption="Training - final")
/*  */
   sML(4)=(sMapName="01_NYC_UNATCOIsland",sMapCaption="NYC, Liberty Island")
   sML(5)=(sMapName="01_NYC_UNATCOHQ",sMapCaption="NYC, UNATCO HQ")
/*  */
   sML(6)=(sMapName="02_NYC_Bar",sMapCaption="NYC, Bar")
   sML(7)=(sMapName="02_NYC_BatteryPark",sMapCaption="NYC, Battery Park")
   sML(8)=(sMapName="02_NYC_FreeClinic",sMapCaption="NYC, Free Clinic")
   sML(9)=(sMapName="02_NYC_Hotel",sMapCaption="NYC, 'Ton Hotel")
   sML(10)=(sMapName="02_NYC_Smug",sMapCaption="NYC, Smuggler's home")
   sML(11)=(sMapName="02_NYC_Street",sMapCaption="NYC, Street")
   sML(12)=(sMapName="02_NYC_Underground",sMapCaption="NYC, Underground")
   sML(13)=(sMapName="02_NYC_Warehouse",sMapCaption="NYC, Warehouse")

   sML(14)=(sMapName="03_NYC_UNATCOIsland",sMapCaption="NYC, Liberty Island")
   sML(15)=(sMapName="03_NYC_UNATCOHQ",sMapCaption="NYC, UNATCO HQ")
   sML(16)=(sMapName="03_NYC_MolePeople",sMapCaption="NYC, Subway station")
   sML(17)=(sMapName="03_NYC_Hangar",sMapCaption="NYC, Hangar")
   sML(18)=(sMapName="03_NYC_BrooklynBridgeStation",sMapCaption="NYC, Brooklyn Bridge Station")
   sML(19)=(sMapName="03_NYC_BatteryPark",sMapCaption="NYC, Battery Park")
   sML(20)=(sMapName="03_NYC_AirfieldHeliBase",sMapCaption="NYC, Airfield Base")
   sML(21)=(sMapName="03_NYC_Airfield",sMapCaption="NYC, Airfield")
   sML(22)=(sMapName="03_NYC_747",sMapCaption="NYC, 747")

   sML(23)=(sMapName="04_NYC_Bar",sMapCaption="NYC, Bar")
   sML(24)=(sMapName="04_NYC_BatteryPark",sMapCaption="NYC, BatteryPark")
   sML(25)=(sMapName="04_NYC_Hotel",sMapCaption="NYC, 'Ton Hotel")
   sML(26)=(sMapName="04_NYC_NSFHQ",sMapCaption="NYC, NSF HQ")
   sML(27)=(sMapName="04_NYC_Smug",sMapCaption="NYC, Smuggler's home")
   sML(28)=(sMapName="04_NYC_Street",sMapCaption="NYC, Street")
   sML(29)=(sMapName="04_NYC_UNATCOHQ",sMapCaption="NYC, UNATCOHQ")
   sML(30)=(sMapName="04_NYC_UNATCOIsland",sMapCaption="NYC, Liberty Island")
   sML(31)=(sMapName="04_NYC_Underground",sMapCaption="NYC, Underground")

   sML(32)=(sMapName="05_NYC_UNATCOMJ12lab",sMapCaption="Unknown location")
   sML(33)=(sMapName="05_NYC_UNATCOHQ",sMapCaption="NYC, UNATCOHQ")
   sML(34)=(sMapName="05_NYC_UNATCOIsland",sMapCaption="NYC, Liberty Island")

   sML(35)=(sMapName="06_HongKong_Helibase",sMapCaption="short")
   sML(36)=(sMapName="06_HongKong_MJ12lab",sMapCaption="short")
   sML(37)=(sMapName="06_HongKong_Storage",sMapCaption="short")
   sML(38)=(sMapName="06_HongKong_TongBase",sMapCaption="short")
   sML(39)=(sMapName="06_HongKong_VersaLife",sMapCaption="short")
   sML(40)=(sMapName="06_HongKong_WanChai_Canal",sMapCaption="short")
   sML(41)=(sMapName="06_HongKong_WanChai_Garage",sMapCaption="short")
   sML(42)=(sMapName="06_HongKong_WanChai_Market",sMapCaption="short")
   sML(43)=(sMapName="06_HongKong_WanChai_Street",sMapCaption="short")
   sML(44)=(sMapName="06_HongKong_WanChai_Underworld",sMapCaption="short")

   sML(45)=(sMapName="08_NYC_Bar",sMapCaption="short")
   sML(46)=(sMapName="08_NYC_FreeClinic",sMapCaption="short")
   sML(47)=(sMapName="08_NYC_Hotel",sMapCaption="short")
   sML(48)=(sMapName="08_NYC_Smug",sMapCaption="short")
   sML(49)=(sMapName="08_NYC_Street",sMapCaption="short")
   sML(50)=(sMapName="08_NYC_Underground",sMapCaption="short")

   sML(51)=(sMapName="09_NYC_Dockyard",sMapCaption="short")
   sML(52)=(sMapName="09_NYC_Graveyard",sMapCaption="short")
   sML(53)=(sMapName="09_NYC_Ship",sMapCaption="short")
   sML(54)=(sMapName="09_NYC_ShipBelow",sMapCaption="short")
   sML(55)=(sMapName="09_NYC_ShipFan",sMapCaption="short")

   sML(56)=(sMapName="10_Paris_Catacombs",sMapCaption="short")
   sML(57)=(sMapName="10_Paris_Catacombs_Tunnels",sMapCaption="short")
   sML(58)=(sMapName="10_Paris_Chateau",sMapCaption="short")
   sML(59)=(sMapName="10_Paris_Club",sMapCaption="short")
   sML(60)=(sMapName="10_Paris_Metro",sMapCaption="short")

   sML(61)=(sMapName="11_Paris_Cathedral",sMapCaption="short")
   sML(62)=(sMapName="11_Paris_Everett",sMapCaption="short")
   sML(63)=(sMapName="11_Paris_Underground",sMapCaption="short")

   sML(64)=(sMapName="12_Vandenberg_Cmd",sMapCaption="short")
   sML(65)=(sMapName="12_Vandenberg_Computer",sMapCaption="short")
   sML(66)=(sMapName="12_Vandenberg_Gas",sMapCaption="Abandoned gas station")
   sML(67)=(sMapName="12_Vandenberg_Tunnels",sMapCaption="Vandenberg, Tunnels")

   sML(68)=(sMapName="14_Oceanlab_Silo",sMapCaption="short")
   sML(69)=(sMapName="14_OceanLab_Lab",sMapCaption="Ocean laboratory")
   sML(70)=(sMapName="14_OceanLab_UC",sMapCaption="Ocean laboratory, Universal Constructor")
   sML(71)=(sMapName="14_Vandenberg_Sub",sMapCaption="")

   sML(72)=(sMapName="15_Area51_Bunker",sMapCaption="Area 51, Bunker")
   sML(73)=(sMapName="15_Area51_Entrance",sMapCaption="Area 51, Entrance")
   sML(74)=(sMapName="15_Area51_Page",sMapCaption="Area 51") // нет идей ((((((
   sML(75)=(sMapName="15_Area51_Final",sMapCaption="Area 51")

   sML(76)=(sMapName="99_Endgame4",sMapCaption="short")
   sML(77)=(sMapName="99_Endgame1",sMapCaption="short")
   sML(78)=(sMapName="99_Endgame2",sMapCaption="short")
   sML(79)=(sMapName="99_Endgame3",sMapCaption="short")
/* Всё что-ли ? :)*/

   Backgrounds(0)=DXRLoading.loading.SH_DarkModulated

/*     Backgrounds(0)=DXRLoading.Loading.1
     Backgrounds(1)=DXRLoading.Loading.2
     Backgrounds(2)=DXRLoading.Loading.2
     Backgrounds(3)=DXRLoading.Loading.4
     Backgrounds(4)=DXRLoading.Loading.5
     Backgrounds(5)=DXRLoading.Loading.6*/

	Begin Object Class=DrawOpText Name=OpLoading
		Top=0.25
		Lft=0.25
		Height=0.05
		Width=0.49
		Justification=1
		Text="LOADING"
		FontName="DxFonts.fntUT2k4Large"
		DrawColor=(R=0,G=0,B=255,A=255)
		bWrapText=False
	End Object
	Operations(1)=OpLoading

	Begin Object Class=DrawOpText Name=OpMapname
		Top=0.75
		Lft=0.25
		Height=0.05
		Width=0.49
		Justification=1
		FontName="DxFonts.fntUT2k4Large"
		DrawColor=(R=0,G=0,B=255,A=255)
//	Text=""
		bWrapText=False
	End Object
	Operations(2)=OpMapname
}