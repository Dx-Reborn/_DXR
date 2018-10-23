//=============================================================================
// Mission15.
//=============================================================================
class Mission15 extends MissionScript;

struct sUCData
{
	var name				spawnTag;
	var class<ScriptedPawn>	spawnClass;
	var name				Tag;
	var name				orderTag;
	var int					count;
	var float				lastKilledTime;
};

var sUCData spawnData[12];
var float jockTimer, pageTimer;
var BobPageAugmented page;

// ----------------------------------------------------------------------
// FirstFrame()
// 
// Stuff to check at first frame
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// PreTravel()
// 
// Set flags upon exit of a certain map
// ----------------------------------------------------------------------


// ----------------------------------------------------------------------
// Timer()
//
// Main state machine for the mission
// ----------------------------------------------------------------------



// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     spawnData(0)=(SpawnTag=UC_spawn1,SpawnClass=Class'DeusEx.SpiderBot2',Tag=spbot1,OrderTag=spiderbot1_0,lastKilledTime=-1.000000)
     spawnData(1)=(SpawnTag=UC_spawn1,SpawnClass=Class'DeusEx.SpiderBot2',Tag=spbot2,OrderTag=spiderbot2_0,lastKilledTime=-1.000000)
     spawnData(2)=(SpawnTag=UC_spawn2,SpawnClass=Class'DeusEx.Gray',Tag=gray_1,OrderTag=gray1_0,lastKilledTime=-1.000000)
     spawnData(3)=(SpawnTag=UC_spawn2,SpawnClass=Class'DeusEx.Gray',Tag=gray_2,OrderTag=gray2_0,lastKilledTime=-1.000000)
     spawnData(4)=(SpawnTag=UC_spawn2,SpawnClass=Class'DeusEx.Gray',Tag=gray_3,OrderTag=gray3_0,lastKilledTime=-1.000000)
     spawnData(5)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Karkian',Tag=karkian_1,OrderTag=karkian1_0,lastKilledTime=-1.000000)
     spawnData(6)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Karkian',Tag=karkian_2,OrderTag=karkian2_0,lastKilledTime=-1.000000)
     spawnData(7)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Karkian',Tag=karkian_3,OrderTag=karkian3_0,lastKilledTime=-1.000000)
     spawnData(8)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_1,OrderTag=greasel1_0,lastKilledTime=-1.000000)
     spawnData(9)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_2,OrderTag=greasel2_0,lastKilledTime=-1.000000)
     spawnData(10)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_3,OrderTag=greasel3_0,lastKilledTime=-1.000000)
     spawnData(11)=(SpawnTag=UC_spawn3,SpawnClass=Class'DeusEx.Greasel',Tag=greasel_4,OrderTag=greasel4_0,lastKilledTime=-1.000000)
}
