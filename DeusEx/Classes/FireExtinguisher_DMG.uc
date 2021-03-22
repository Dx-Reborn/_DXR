/*
    Использованный огнетушитель
*/

class FireExtinguisher_DMG extends DeusExDecoration;


event Destroyed()
{
   local int i;
   local DeusExEmitter em;

   for(i=0; i<5; i++)
       foreach RadiusActors(class'DeusExEmitter', em, 10)
               em.Kill();
}


defaultproperties
{
    ItemName="Used fireextinguisher"
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_Pickups.FireExtinguisher_HD'
    CollisionRadius=5.000000
    CollisionHeight=10.27
    Mass=10.000000
    Buoyancy=8.000000
}