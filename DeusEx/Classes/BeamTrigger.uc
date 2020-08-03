//=============================================================================
// BeamTrigger.
//=============================================================================
class BeamTrigger extends DeusExTrigger;

var EM_LaserBeam emitter;
var() bool bIsOn;
var actor LastHitActor;
var bool bConfused;             // used when hit by EMP
var float confusionTimer;       // how long until trigger resumes normal operation
var float confusionDuration;    // how long does EMP hit last?
var int HitPoints;
var int minDamageThreshold;
var bool bAlreadyTriggered;

singular function Touch(Actor Other)
{
    // does nothing when touched
}

event Tick(float deltaTime)
{
    local Actor A;
    local AdaptiveArmor armor;
    local bool bTrigger;

    if (emitter != None)
    {
        // if we've been EMP'ed, act confused
        if (bConfused && bIsOn)
        {
            confusionTimer += deltaTime;

            // randomly turn on/off the beam
            if (FRand() > 0.95)
                emitter.TurnOn();
            else
                emitter.TurnOff();

            if (confusionTimer > confusionDuration)
            {
                bConfused = False;
                confusionTimer = 0;
                emitter.TurnOn();
            }

            return;
        }

        emitter.SetLocation(Location);
        emitter.SetRotation(Rotation);

        if ((emitter.HitActor != None) && (LastHitActor != emitter.HitActor))
        {
            if (IsRelevant(emitter.HitActor))
            {
                bTrigger = True;

                if (emitter.HitActor.IsA('DeusExPlayer'))
                {
                    // check for adaptive armor - makes the player invisible
                    foreach AllActors(class'AdaptiveArmor', armor)
                        if ((armor.Owner == emitter.HitActor) && armor.bActive)
                        {
                            bTrigger = False;
                            break;
                        }
                }

                if (bTrigger)
                {
                    // play "beam broken" sound
                    PlaySound(sound'Beep2',,,, 1280, 3.0);
//                    log(self@"___ Beam has been broken!");

                    if (!bAlreadyTriggered)
                    {
                        // only be triggered once?
                        if (bTriggerOnceOnly)
                            bAlreadyTriggered = True;

                        // Trigger event
                        if(Event != '')
                            foreach AllActors(class 'Actor', A, Event)
                                A.Trigger(Self, Pawn(emitter.HitActor));
                    }
                }
            }
        }

        LastHitActor = emitter.HitActor;
    }
}

// if we are triggered, turn us on
function Trigger(Actor Other, Pawn Instigator)
{
    if (bConfused)
        return;

    if (emitter != None)
    {
        if (!bIsOn)
        {
            emitter.TurnOn();
            bIsOn = True;
            LastHitActor = None;
            Skins[1] = Texture'LaserSpot1';
        }
    }

    Super.Trigger(Other, Instigator);
}

// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn Instigator)
{
    if (bConfused)
        return;

    if (emitter != None)
    {
        if (bIsOn)
        {
            emitter.TurnOff();
            bIsOn = False;
            LastHitActor = None;
            Skins[1] = Texture'BlackMaskTex';
        }
    }

    Super.UnTrigger(Other, Instigator);
}

event BeginPlay()
{
    Super.BeginPlay();

    LastHitActor = None;
    emitter = Spawn(class'EM_LaserBeam');

    if (emitter != None)
    {
        emitter.SetBlueBeam();
        emitter.TurnOn();
        bIsOn = True;
    }
    else
        bIsOn = False;
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    local MetalFragment frag;

    if (DamageType == class'DM_EMP')
    {
        confusionTimer = 0;
        if (!bConfused)
        {
            bConfused = True;
            PlaySound(sound'EMPZap', SLOT_None,,, 1280);
        }
    }
    else if ((DamageType == class'DM_Exploded') || (DamageType == class'DM_Shot'))
    {
        if (Damage >= minDamageThreshold)
            HitPoints -= Damage;

        if (HitPoints <= 0)
        {
            frag = Spawn(class'MetalFragment', Owner);
            if (frag != None)
            {
                frag.Instigator = EventInstigator;
                frag.CalcVelocity(Momentum,0);
                frag.SetDrawScale(0.5*FRand());
                frag.Skins[0] = class'ObjectManager'.static.GetActorMeshTexture(self);
            }
            Destroy();
        }
    }
}

event Destroyed()
{
    if (emitter != None)
    {
        emitter.Kill();
        emitter.Destroy();
        emitter = None;
    }

    Super.Destroyed();
}

defaultproperties
{
     bIsOn=True
     confusionDuration=10.000000
     HitPoints=50
     minDamageThreshold=50
     TriggerType=TT_AnyProximity
     bHidden=False
     bDirectional=True
     mesh=mesh'DeusExDeco.LaserEmitter'
     CollisionRadius=2.500000
     CollisionHeight=2.500000
     DrawType=DT_Mesh
     Skins[0]=Texture'DeusExDeco.Skins.LaserEmitterTex1'
     Skins[1]=Texture'DeusExDeco.Skins.AlarmLightTex2'
}
