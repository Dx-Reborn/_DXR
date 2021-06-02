//=============================================================================
// HumanMilitary.
//=============================================================================
class HumanMilitary extends ScriptedPawn
    abstract;

var() bool bHasFlashLight;
var() editconst LightProjectorNPC fl;
var() editconst DynamicCoronaLight DCL;
var() Name LampBone; // Косточка для "фонарика"
var() float FlashlightThreshold;

event AnimEnd(int Channel)
{
    Super.AnimEnd(Channel);

    if (Controller != None)
    {
        if (AIVisibility(self) < FlashlightThreshold) // && (cState == 'Seeking'))
            fTurnOn();
            else
            fTurnOff();
    }
}


// pawn is killed, destroy the flashlight.
event Destroyed()
{
   Super.Destroyed();
   fTurnOff();

   if (DCL != None)
       DCL.Destroy();

   if (fl != None)
       fl.Destroy();
}

function CreateFlashLight()
{
   if (bHasFlashLight)
   {
      if (fl == None)
          fl = Spawn(class'LightProjectorNPC',,,Location,GetViewRotation());

      if (DCL == None)
          DCL = Spawn(class'DynamicCoronaLight',,,Location,GetViewRotation());

          DCL.MinCoronaSize = 5;
          DCL.MaxCoronaSize = 5;

   }
}

function fTurnOn()
{
   if (DCL != None)
       DCL.bCorona = true;

   if (fl != None)
       fl.MaxTraceDistance = fl.default.MaxTraceDistance;
}

function fTurnOff()
{
   if (DCL != None)
       DCL.bCorona = false;

   if (fl != None)
       fl.MaxTraceDistance = 0;
}

event Tick(float dt)
{
    local Vector loc;
    local Rotator lrt;

    loc = Location;
    loc.z = loc.z + EyeHeight;

    if (fl != None)
    {
       lrt = GetViewRotation();
       lrt.Pitch = lrt.Pitch - 500; // Повернуть ближе к поверхности

       fl.SetRotation(lrt);
       fl.SetLocation(loc);
    }

    if (DCL != None)
    {
        AttachToBone(DCL, LampBone);
    }

    Super.Tick(dt);
}

function bool PlayTurnHead(ELookDirection newLookDir, float rate, float tweentime)
{
    if (bCanTurnHead)
    {
        if (Super.PlayTurnHead(newLookDir, rate, tweentime))
        {
            AIAddViewRotation = rot(0,0,0); // default
            switch (newLookDir)
            {
                case LOOK_Left:
                    AIAddViewRotation = rot(0,-5461,0);  // 30 degrees left
                    break;
                case LOOK_Right:
                    AIAddViewRotation = rot(0,5461,0);   // 30 degrees right
                    break;
                case LOOK_Up:
                    AIAddViewRotation = rot(5461,0,0);   // 30 degrees up
                    break;
                case LOOK_Down:
                    AIAddViewRotation = rot(-5461,0,0);  // 30 degrees down
                    break;

                case LOOK_Forward:
                    AIAddViewRotation = rot(0,0,0);      // 0 degrees
                    break;
            }
        }
        else
            return false;
    }
    else
        return false;
}


event PostBeginPlay()
{
    Super.PostBeginPlay();

    // change the sounds for chicks
    if (bIsFemale)
    {
        HitSound1 = Sound'FemalePainMedium';
        HitSound2 = Sound'FemalePainLarge';
        Die = Sound'FemaleDeath';
    }
    CreateFlashLight();
}

function bool WillTakeStompDamage(actor stomper)
{
    // This blows chunks!
    if (stomper.IsA('PlayerPawn') && (GetPawnAllianceType(Pawn(stomper)) != ALLIANCE_Hostile))
        return false;
    else
        return true;
}


defaultproperties
{
     FlashlightThreshold=0.01
     VisibilityThreshold=0.010000
     BindName="HumanMilitary"
     BaseAccuracy=0.200000
     MaxRange=1000.000000
     MinHealth=20.000000
     bPlayIdle=True
     bCanCrouch=True
     bSprint=True
     CrouchRate=1.000000
     SprintRate=1.000000
     bReactAlarm=True
     EnemyTimeout=5.000000
     bCanTurnHead=True
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     die=Sound'DeusExSounds.Player.MaleDeath'
     Texture=Texture'Engine.S_Pawn'
     Mass=150.000000
     Buoyancy=155.000000
}
