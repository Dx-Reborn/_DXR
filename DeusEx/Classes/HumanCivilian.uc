//=============================================================================
// HumanCivilian.
//=============================================================================
class HumanCivilian extends ScriptedPawn
    abstract;

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


function PostBeginPlay()
{
    Super.PostBeginPlay();

    // Eventually, these will all be unique sounds per NPC specified in
    // the defaultproperties

    // change the sounds for chicks
    if (bIsFemale)
    {
        HitSound1 = Sound'FemalePainMedium';
        HitSound2 = Sound'FemalePainLarge';
        Die = Sound'FemaleDeath';
    }

    // change the sounds for kids
    if (IsA('ChildMale') || IsA('ChildMale2'))
    {
        HitSound1 = Sound'ChildPainMedium';
        HitSound2 = Sound'ChildPainLarge';
        Die = Sound'ChildDeath';
    }
}

function bool WillTakeStompDamage(actor stomper)
{
    // This blows chunks!
    if (stomper.IsA('PlayerPawn') && (GetPawnAllianceType(DeusExPawn(stomper)) != ALLIANCE_Hostile))
        return false;
    else
        return true;
}

defaultproperties
{
     VisibilityThreshold=0.010000
     BindName="HumanCivilian"
     BaseAccuracy=1.200000
     MaxRange=400.000000
     MinHealth=40.000000
     bPlayIdle=True
     bAvoidAim=False
     bReactProjectiles=False
     bFearShot=True
     bFearIndirectInjury=True
     bFearCarcass=True
     bFearDistress=True
     bFearAlarm=True
     EnemyTimeout=1.500000
     bCanTurnHead=True
     bCanStrafe=False
     WaterSpeed=80.000000
     AirSpeed=160.000000
     AccelRate=500.000000
     BaseEyeHeight=40.000000
     UnderWaterTime=20.000000
     //  AttitudeToPlayer=ATTITUDE_Ignore
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     die=Sound'DeusExSounds.Player.MaleDeath'
     Mass=150.000000
     Buoyancy=155.000000
}
