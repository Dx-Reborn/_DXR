//=============================================================================
// LaserTrigger.
//=============================================================================
class LaserTrigger extends DeusExTrigger;

var() bool bIsOn;
var() bool bNoAlarm;            // if True, does NOT sound alarm
var actor LastHitActor;
var bool bConfused;             // used when hit by EMP
var float confusionTimer;       // how long until trigger resumes normal operation
var float confusionDuration;    // how long does EMP hit last?
var int HitPoints;
var int minDamageThreshold;
var float lastAlarmTime;        // last time the alarm was sounded
var int alarmTimeout;           // how long before the alarm silences itself
//var actor triggerActor;           // actor which last triggered the alarm
var vector actorLocation;       // last known location of actor that triggered alarm
var EM_Laserbeam emitter;

/*event PreBeginPlay()
{
    Super.PreBeginPlay();
} */

singular function Touch(Actor Other)
{
    // does nothing when touched
}

function BeginAlarm()
{
    AmbientSound = Sound'Klaxon2';
    SoundVolume = 128;
    SoundRadius = 64;
    lastAlarmTime = Level.TimeSeconds;
    class'EventManager'.static.AIStartEvent(self, 'Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));

    // make sure we can't go into stasis while we're alarming
    bStasis = False;
}

function EndAlarm()
{
    AmbientSound = None;
    lastAlarmTime = 0;
    class'EventManager'.static.AIEndEvent(self, 'Alarm', EAITYPE_Audio);

    // reset our stasis info
    bStasis = Default.bStasis;
}

function Tick(float deltaTime)
{
    local AdaptiveArmor armor;
    local bool bTrigger;

    if (emitter != None)
    {
        // shut off the alarm if the timeout has expired
        if (lastAlarmTime != 0)
        {
            if (Level.TimeSeconds - lastAlarmTime >= alarmTimeout)
                EndAlarm();
        }

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

        if (!bNoAlarm)
        {
            if ((emitter.HitActor != None) && (LastHitActor != emitter.HitActor))
            {
                // TT_PlayerProximity actually works with decorations, too
                if (IsRelevant(emitter.HitActor) ||
                    ((TriggerType == TT_PlayerProximity) && emitter.HitActor.IsA('Decoration')))
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
                        // now, the trigger sounds its own alarm
                        if (AmbientSound == None)
                        {
                            triggerActor = emitter.HitActor;
                            actorLocation = emitter.HitActor.Location - vect(0,0,1)*(emitter.HitActor.CollisionHeight-1);
                            BeginAlarm();
                        }

                        // play "beam broken" sound
                        PlaySound(sound'Beep2',,,, 1280, 3.0);
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
            EndAlarm();
        }
    }

    Super.UnTrigger(Other, Instigator);
}

function BeginPlay()
{
    Super.BeginPlay();

    LastHitActor = None;
    emitter = Spawn(class'EM_Laserbeam');

    if (emitter != None)
    {
        emitter.TurnOn();
        bIsOn = True;

        // turn off the sound if we should
        if (SoundVolume == 0)
            emitter.AmbientSound = None;
    }
    else
        bIsOn = False;
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
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
                frag.Instigator = instigatedBy;
                frag.CalcVelocity(Momentum);
                frag.SetDrawScale(0.5*FRand());
                frag.Skins[0] = class'ObjectManager'.static.GetActorMeshTexture(self);// = Skins[0];
            }
            Destroy();
        }
    }
}

function Destroyed()
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
     alarmTimeout=30
     TriggerType=TT_AnyProximity
     bHidden=False
     bDirectional=True
     mesh=mesh'DeusExDeco.LaserEmitter'
     DrawType=DT_Mesh
     CollisionRadius=2.500000
     CollisionHeight=2.500000
     Skins[0]=Texture'DeusExDeco.Skins.LaserEmitterTex1'
     Skins[1]=Texture'DeusExDeco.Skins.AlarmLightTex2'
}
