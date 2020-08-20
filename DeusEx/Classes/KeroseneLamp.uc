class KeroseneLamp extends FuelLamps;

var EM_OilLampFlame flame;
var DynamicCoronaLight DLight;
var DynamicCoronaLight DistantCorona;

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
   {
       flame = Spawn(class'EM_OilLampFlame', self,'', Location + vect(0,0,-8), Rotation + rot(0,0,16384));
   }
   if (flame != None)
   {
       flame.SetBase(self);
   }

   if (DLight == None)
   {
       Dlight = Spawn(class'DynamicCoronaLight', self,'', Location + vect(0,0,4), Rotation);
   }
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
       Dlight.SetDrawScale(0.4);
   }

   if (DistantCorona == None)
   {
       DistantCorona = Spawn(class'DynamicCoronaLight', self,'', Location + vect(0,0,-4), Rotation);
   }
   if (DistantCorona != None)
   {
       DistantCorona.SetBase(Self);
       DistantCorona.MinCoronaSize = 0.00;
       DistantCorona.MaxCoronaSize = 10.00;
       DistantCorona.SetDrawScale(0.40);
       DistantCorona.CullDistance = 1500; //LightRadius = 50;
       DistantCorona.Skins[0] = Texture'DXR_FX.Effects.impflash';
   }

}

function TurnOff()
{
    if (flame != None)
    {
        flame.Kill(); // So it will smoothly fade out
    }

    if (Dlight != None)
        Dlight.Destroy();

    if (DistantCorona != None)
        DistantCorona.Destroy();
}


defaultproperties
{
    StaticMesh=StaticMesh'DXR_Lanterns.Scripted.KeroseneLantern'
    CollisionRadius=8.00
    CollisionHeight=17.00
    ItemName="Kerosene lantern"
}

