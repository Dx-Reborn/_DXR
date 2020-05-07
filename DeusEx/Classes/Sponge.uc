/*
   Губка (для мытья посуды)
*/

class Sponge extends DeusExDecoration;

//#EXEC OBJ LOAD FILE=DeusExStaticMeshes9

defaultproperties
{
     FragType=Class'DeusEx.PlasticFragment'
     ItemName="Sponge"
     StaticMesh=Staticmesh'DeusExStaticMeshes9.Sponge_a'
     DrawType=DT_StaticMesh
     CollisionRadius=6
     CollisionHeight=1.2
     Mass=10.000000
     Buoyancy=12.000000
     bUseCylinderCollision=true
}
