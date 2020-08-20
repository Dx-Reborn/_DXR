class FuelLamps extends DeusExDecoration
                               abstract;


#exec OBJ LOAD FILE=DXR_Lanterns.usx
#exec OBJ LOAD FILE=DXR_FX.utx

var() bool bOn;

event SetInitialState()
{
    if (bOn)
        TurnOn();

    Super.SetInitialState();
}

/* override in subclasses */
function SpawnStuff();
function TurnOff();

function TurnOn()
{
    SpawnStuff();
}

event Destroyed()
{
     TurnOff();
     Super.Destroyed();
}


defaultproperties
{
    DrawType=DT_StaticMesh
    CollisionRadius=8.000000
    CollisionHeight=15.500000
    bPushable=false
}
