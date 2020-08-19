class OilLamp extends DeusExDecoration;

#exec OBJ LOAD FILE=DXR_Lanterns.usx

var() bool bOn;
var EM_OilLampFlame flame;
var DynamicCoronaLight DLight;

function Frob(Actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    if (!bOn)
    {
        bOn = true;
        bUseCylinderCollision = false;
        TurnOn();
    }
    else
    {
        bOn = false;
        bUseCylinderCollision = true;
        TurnOff();
    }
}

function SpawnStuff()
{
   if (flame == none)
       flame = Spawn(class'EM_OilLampFlame', self,'', Location + vect(0,0,2), Rotation + rot(0,0,16384));

   if (flame != None)
   {
       flame.SetBase(self);
   }

   if (DLight == None)
       Dlight = Spawn(class'DynamicCoronaLight', self,'', Location + vect(0,0,4), Rotation);

   if (DLight != None)
   {
       Dlight.bDynamicLight = true;
       DLight.SetBase(self);
       DLight.LightType = LT_SubtlePulse;
       DLight.LightHue = 14;
       DLight.LightSaturation = 35;
       DLight.LightBrightness = 155.00;
       DLight.LightRadius = 5.000000;
       DLight.LightPeriod = 50;
   }

}

function TurnOn()
{
    SpawnStuff();
}

function TurnOff()
{
    if (flame != None)
    {
        flame.Kill(); // So it will smoothly fade out
    }

    if (Dlight != None)
        Dlight.Destroy();
}


defaultproperties
{
    DrawType=DT_StaticMesh
    StaticMesh=StaticMesh'DXR_Lanterns.Scripted.OilLamp_a'
    CollisionRadius=8.000000
    CollisionHeight=15.500000
    bPushable=false
    ItemName="Oil Lamp"
}





