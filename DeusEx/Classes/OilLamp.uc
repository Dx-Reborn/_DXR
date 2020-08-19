class OilLamp extends DeusExDecoration;

#Exec OBJ LOAD FILE=DXR_Lanterns.usx

var() bool bOn;

function SpawnStuff()
{

}

function TurnOn()
{

}

function TurnOff()
{

}


defaultproperties
{
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_Lanterns.Scripted.OilLamp_a'
    CollisionRadius=8.000000
    CollisionHeight=15.500000
}

