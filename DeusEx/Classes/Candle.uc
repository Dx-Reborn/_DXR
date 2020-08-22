class Candle extends FuelLamps;

var EM_CandleFlame flame;
var DynamicCoronaLight DLight;
var DynamicCoronaLight DistantCorona;

function Frob(Actor Frobber, Inventory frobWith)
{
    Super.Frob(Frobber, frobWith);

    if (!bOn)
    {
        bOn = true;
        TurnOn();
    }
    else
    {
        bOn = false;
        TurnOff();
    }
}

function SpawnStuff()
{
   if (flame == none)
   {
       flame = Spawn(class'EM_CandleFlame', self,'', Location + vect(0,0,10), Rotation + rot(0,0,16384));
   }
   if (flame != None)
   {
       flame.SetBase(self);
   }

   if (DLight == None)
   {
       Dlight = Spawn(class'DynamicCoronaLight', self,'', Location + vect(0,0,8), Rotation);
   }
   if (DLight != None)
   {
       Dlight.bDynamicLight = true;
       DLight.SetBase(self);
       DLight.LightType = LT_SubtlePulse;
       DLight.LightHue = 14;
       DLight.LightSaturation = 35;
       DLight.LightBrightness = 155.00;
       DLight.LightRadius = 4.00;
       DLight.LightPeriod = 50;
       Dlight.SetDrawScale(0.2);
   }

   if (DistantCorona == None)
   {
       DistantCorona = Spawn(class'DynamicCoronaLight', self,'', Location + vect(0,0,8), Rotation);
   }
   if (DistantCorona != None)
   {
       DistantCorona.SetBase(Self);
       DistantCorona.MinCoronaSize = 0.00;
       DistantCorona.MaxCoronaSize = 10.00;
       DistantCorona.SetDrawScale(0.20);
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
    StaticMesh=StaticMesh'DXR_Lanterns.Scripted.Candle_a'
    CollisionRadius=4.000000
    CollisionHeight=6.500000
    PrePivot=(Z=-0.500000)
    ItemName="Candle"
}



