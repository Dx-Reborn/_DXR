//=============================================================================
// AutoTurret.
//=============================================================================
class AutoTurret extends DeusExDecoration;

var AutoTurretGun gun;

var() localized String titleString;     // So we can name specific turrets in multiplayer //DXR: Multiplayer is not supported!
var() bool bTrackPawnsOnly;
var() bool bTrackPlayersOnly;
var() bool bActive;
var() int maxRange;
var() float fireRate;
var() float gunAccuracy;
var() int gunDamage;
var() int ammoAmount;
var Actor curTarget;
var Actor prevTarget;         // target we had last tick.
var Pawn safeTarget;          // in multiplayer, this actor is strictly off-limits
                               // Usually for the player who activated the turret.
var float fireTimer;
var bool bConfused;             // used when hit by EMP
var float confusionTimer;       // how long until turret resumes normal operation
var float confusionDuration;    // how long does an EMP hit last?
var Actor LastTarget;           // what was our last target?
var float pitchLimit;           // what's the maximum pitch?
var bool bPreAlarmActiveState;  // was I previously awake or not?
var bool bDisabled;             // have I been hacked or shut down by computers?
var float TargetRefreshTime;      // used for multiplayer to reduce rate of checking for targets.

var bool bComputerReset;            // Keep track of if computer has been reset so we avoid all actors checks

var bool bSwitching;
var float SwitchTime, beepTime;
var Pawn savedTarget;

//------------------------------------------------

function AlarmHeard(Name event, DeusExPawn.EAIEventState state, optional DeusExPawn.XAIParams params)
{
    if (state == EAISTATE_Begin)
    {
        if (!bActive)
        {
            bPreAlarmActiveState = bActive;
            bActive = True;
        }
    }
    else if (state == EAISTATE_End)
    {
        if (bActive)
            bActive = bPreAlarmActiveState;
    }
}

event SetInitialState()
{
    SetTimer(0.1, true);
}


event Tick(float deltaTime)
{
    local DeusExPawn pawn;
    local ScriptedPawn sp;
    local DeusExDecoration deco;
    local float near;
    local Rotator destRot;

    Super.Tick(deltaTime);

    if (bActive && !bDisabled)
    {
        curTarget = None;

        // if we've been EMP'ed, act confused
        if (bConfused)
        {
            confusionTimer += deltaTime;

            // pick a random facing
            if (confusionTimer % 0.25 > 0.2)
            {
                gun.DesiredRotation.Pitch = origRot.Pitch + (pitchLimit / 2 - Rand(pitchLimit));
                gun.DesiredRotation.Yaw = Rand(65535);
            }

            if (confusionTimer > confusionDuration)
            {
                bConfused = False;
                confusionTimer = 0;
                confusionDuration = Default.confusionDuration;
            }
        }
        else
        {
            //
            // Logic table for turrets
            //
            // bTrackPlayersOnly        bTrackPawnsOnly     Should Attack
            //          T                       X               Allies
            //          F                       T               Enemies
            //          F                       F               Everything
            //

            // Attack allies and neutrals
            if (bTrackPlayersOnly || (!bTrackPlayersOnly && !bTrackPawnsOnly))
            {
                foreach gun.VisibleActors(class'DeusExPawn', pawn, maxRange, gun.Location)
                {
                    if (pawn.bDetectable && !pawn.bIgnore)
                    {
                        if (pawn.IsA('DeusExPlayer'))
                        {
                            // If the player's RadarTrans aug is off, the turret can see him
                            if (DeusExPlayer(pawn).AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') == -1.0)
                            {
                                curTarget = pawn;
                                break;
                            }
                        }
                        else if (pawn.IsA('ScriptedPawn') && (ScriptedPawn(pawn).GetPawnAllianceType(DeusExPawn(GetPlayerPawn())) != ALLIANCE_Hostile))
                        {
                            curTarget = pawn;
                            break;
                        }
                    }
                }
            }

            if (!bTrackPlayersOnly)
            {
                // Attack everything
                if (!bTrackPawnsOnly)
                {
                    foreach gun.VisibleActors(class'DeusExDecoration', deco, maxRange, gun.Location)
                    {
                        if (!deco.IsA('ElectronicDevices') && !deco.IsA('AutoTurret') && !deco.bInvincible && deco.bDetectable && !deco.bIgnore)
                        {
                            curTarget = deco;
                            break;
                        }
                    }
                }

                // Attack enemies
                foreach gun.VisibleActors(class'ScriptedPawn', sp, maxRange, gun.Location)
                {
                    if (sp.bDetectable && !sp.bIgnore && (sp.GetPawnAllianceType(DeusExPawn(GetPlayerPawn())) == ALLIANCE_Hostile))
                    {
                        curTarget = sp;
                        break;
                    }
                }
            }

            // if we have a target, rotate to face it
            if (curTarget != None)
            {
                destRot = Rotator(curTarget.Location - gun.Location);
                gun.DesiredRotation = destRot;
                near = pitchLimit / 2;
                gun.DesiredRotation.Pitch = FClamp(gun.DesiredRotation.Pitch, origRot.Pitch - near, origRot.Pitch + near);
            }
            else
                gun.DesiredRotation = origRot;
        }
    }
    else
    {
        gun.DesiredRotation = origRot;
    }

    near = (Abs(gun.Rotation.Pitch - gun.DesiredRotation.Pitch)) % 65536;
    near += (Abs(gun.Rotation.Yaw - gun.DesiredRotation.Yaw)) % 65536;

    if (bActive && !bDisabled)
    {
        // play an alert sound and light up
        if ((curTarget != None) && (curTarget != LastTarget))
            PlaySound(Sound'Beep6',,,, 1280);

        // if we're aiming close enough to our target
        if (curTarget != None)
        {
            //gun.Skins[1] = Texture'RedLightTex';
            if ((near < 4096) && (((Abs(gun.Rotation.Pitch - destRot.Pitch)) % 65536) < 8192))
            {
                if (fireTimer > fireRate)
                {
                    Fire();
                    fireTimer = 0;
                }
            }
        }
        else
        {
            if (gun.IsAnimating())
                gun.PlayAnim('Still', 10.0, 0.001);

            //if (bConfused)
                //gun.Skins[1] = Texture'YellowLightTex';
            //else
                //gun.Skins[1] = Texture'GreenLightTex';
        }

        fireTimer += deltaTime;
        LastTarget = curTarget;
    }
    else
    {
        if (gun.IsAnimating())
            gun.PlayAnim('Still', 10.0, 0.001);
        //gun.Skins[1] = texture'PinkMaskTex';
    }

    // make noise if we're still moving
    if (near > 64)
    {
        gun.AmbientSound = Sound'AutoTurretMove';
        if (bConfused)
            gun.SoundPitch = 128;
        else
            gun.SoundPitch = 64;
    }
    else
        gun.AmbientSound = None;
}



// if we are triggered, turn us on
function Trigger(Actor Other, Pawn EventInstigator)
{
    if (bConfused || bDisabled)
        return;

    if (!bActive)
    {
        bActive = True;
        AmbientSound = default.AmbientSound;
    }

    Super.Trigger(Other, EventInstigator);
}


// if we are untriggered, turn us off
function UnTrigger(Actor Other, Pawn EventInstigator)
{
    if (bConfused || bDisabled)
        return;

    if (bActive)
    {
        bActive = False;
        AmbientSound = None;
    }

    Super.UnTrigger(Other, EventInstigator);
}

event Destroyed()
{
    if (gun != None)
    {
        gun.Destroy();
        gun = None;
    }

    Super.Destroyed();      
}

function PreBeginPlay()
{
    local Vector v1, v2;
    local class<AutoTurretGun> gunClass;
    local Rotator rot;

    Super.PreBeginPlay();

    if (IsA('AutoTurretSmall'))
        gunClass = class'AutoTurretGunSmall';
    else
        gunClass = class'AutoTurretGun';

    rot = Rotation;
    rot.Pitch = 0;
    rot.Roll = 0;
    origRot = rot;
//  rot.Roll=32768; //rot.Roll = 0; неправильно повернута модель.
    gun = Spawn(gunClass, Self,, Location, rot);
    if (gun != None)
    {
        v1.X = 0;
        v1.Y = 0;
        v1.Z = CollisionHeight + gun.Default.CollisionHeight;
        v2 = v1 >> Rotation;
        v2 += Location;
        gun.SetLocation(v2);
        gun.SetBase(Self);
    }

    // set up the alarm listeners
//  EventManager.AISetEventCallback('Alarm', 'AlarmHeard');
}


// turn off the muzzle flash
event Timer()
{
    gun.LightType = LT_None;
    //gun.Skins[2] = None;
}

auto state Active
{
    function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
    {
        local float mindmg;

        if (DamageType == class'DM_EMP')
        {
            // duration is based on daamge
            // 10 seconds min to 30 seconds max
            mindmg = Max(Damage - 15.0, 0.0);
            confusionDuration += mindmg / 5.0;
            confusionTimer = 0;
            if (!bConfused)
            {
                bConfused = True;
                PlaySound(sound'EMPZap', SLOT_None,,, 1280);
            }
            return;
        }

        Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
    }
}


function Fire()
{
    local Vector HitLocation, HitNormal, StartTrace, EndTrace, X, Y, Z;
    local Rotator rot;
    local Actor hit;
    local ShellCasing shell;
    local Spark spark;
    local Pawn attacker;
    local playercontroller player;
    local DeusExGlobals gl;

    Player = Level.GetLocalPlayerController();
    gl = class'DeusExGlobals'.static.GetGlobals();

    if (!gun.IsAnimating())
        gun.LoopAnim('Fire');

    // CNN - give turrets infinite ammo // DXR: Now its toggleable.
    if (ammoAmount > 0)
    {
        ammoAmount--;
        if (gl.bInfiniteAmmoForTurrets)
            ammoAmount++; // DXR: So simple! 

        GetAxes(gun.Rotation, X, Y, Z);
        StartTrace = gun.Location;
        EndTrace = StartTrace + gunAccuracy * (FRand()-0.5)*Y*1000 + gunAccuracy * (FRand()-0.5)*Z*1000 ;
        EndTrace += 10000 * X;
        hit = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True);

        // spawn some effects
        shell = Spawn(class'ShellCasing',,, gun.Location);
        if (shell != None)
            shell.Velocity = Vector(gun.Rotation - rot(0,16384,0)) * 100 + VRand() * 30;

        MakeNoise(1.0);
        PlaySound(sound'PistolFire', SLOT_None);
//      EventManager.AISendEvent('LoudNoise', EAITYPE_Audio);

        // muzzle flash
        gun.LightType = LT_Steady;
        //gun.Skins[2] = Texture'FlatFXTex34';
//      SetTimer(0.1, False);

        // randomly draw a tracer
        if (FRand() < 0.5)
        {
            if (VSize(HitLocation - StartTrace) > 250)
            {
                rot = Rotator(EndTrace - StartTrace);
                Spawn(class'Tracer',,, StartTrace + 96 * Vector(rot), rot);
            }
        }

        if (hit != None)
        {
            // spawn a little spark and make a ricochet sound if we hit something
            spark = spawn(class'Spark',,,HitLocation+HitNormal, Rotator(HitNormal));
            if (spark != None)
            {
                spark.SetDrawScale(0.05);
                PlayHitSound(spark, hit);
            }

            attacker = None;
            if ((curTarget == hit) && !curTarget.IsA('PlayerPawn'))
                attacker = Human(player.pawn); //GetPlayerPawn();
            hit.TakeDamage(gunDamage, attacker, HitLocation, 1000.0*X, class'DM_shot');
            if (hit.IsA('Pawn') && !hit.IsA('Robot'))
                SpawnBlood(HitLocation, HitNormal);
            else if ((hit == Level) || hit.IsA('Mover'))
                SpawnEffects(HitLocation, HitNormal, hit);
        }
    }
  else
  {
      PlaySound(sound'DryFire', SLOT_None);
  }
}



function PlayHitSound(actor destActor, Actor hitActor)
{
    local float rnd;
    local sound snd;

    rnd = FRand();

    if (rnd < 0.25)
        snd = sound'Ricochet1';
    else if (rnd < 0.5)
        snd = sound'Ricochet2';
    else if (rnd < 0.75)
        snd = sound'Ricochet3';
    else
        snd = sound'Ricochet4';

    // play a different ricochet sound if the object isn't damaged by normal bullets
    if (hitActor != None) 
    {
        if (hitActor.IsA('DeusExDecoration') && (DeusExDecoration(hitActor).minDamageThreshold > 10))
            snd = sound'ArmorRicochet';
        else if (hitActor.IsA('Robot'))
            snd = sound'ArmorRicochet';
    }

    if (destActor != None)
        destActor.PlaySound(snd, SLOT_None,,, 1024, 1.1 - 0.2*FRand());
}

function SpawnBlood(Vector HitLocation, Vector HitNormal)
{
    local rotator rot;

    rot = Rotator(Location - HitLocation);
    rot.Pitch = 0;
    rot.Roll = 0;
    spawn(class'BloodSpurt',,,HitLocation+HitNormal, rot);
    spawn(class'BloodDrop',,,HitLocation+HitNormal);
    if (FRand() < 0.5)
        spawn(class'BloodDrop',,,HitLocation+HitNormal);
}

function SpawnEffects(Vector HitLocation, Vector HitNormal, Actor Other)
{
    local SmokeTrail puff;
    local int i;
    local BulletHole hole;

    if (FRand() < 0.5)
    {
        puff = spawn(class'SmokeTrail',,,HitLocation+HitNormal, Rotator(HitNormal));
        if (puff != None)
        {
            puff.SetDrawScale(DrawScale * 0.3); // DrawScale *= 0.3;
            puff.OrigScale = puff.DrawScale;
            puff.LifeSpan = 0.25;
            puff.OrigLifeSpan = puff.LifeSpan;
        }
    }

    if (!Other.IsA('BreakableGlass'))
        for (i=0; i<2; i++)
            if (FRand() < 0.8)
                spawn(class'Rockchip',,,HitLocation+HitNormal);


    hole = spawn(class'BulletHole', Other,, HitLocation, Rotator(HitNormal));

    // should we crack glass?
    if (GetWallMaterial(HitLocation, HitNormal) == 'Glass')
    {
        if (FRand() < 0.5)
            hole.ProjTexture = Texture'FlatFXTex29';
        else
            hole.ProjTexture = Texture'FlatFXTex30';

        hole.SetDrawScale(0.1);
//      hole.ReattachDecal();
    }
}

function name GetWallMaterial(vector HitLocation, vector HitNormal)
{
    local vector EndTrace, StartTrace;
    local actor newtarget;
    local int texFlags;
    local name texName, texGroup;

    StartTrace = HitLocation + HitNormal*16;        // make sure we start far enough out
    EndTrace = HitLocation - HitNormal;

    foreach class'ActorManager'.static.TraceTexture(self,class'Actor', newtarget, texName, texGroup, texFlags, StartTrace, HitNormal, EndTrace)
        if ((newtarget == Level) || newtarget.IsA('Mover'))
            break;

    return texGroup;
}

function Pawn GetPlayerPawn()
{
    return Level.GetLocalPlayerController().Pawn;
}

event BeginPlay();
event FellOutOfWorld(eKillZType KillType);


defaultproperties
{
     titleString="AutoTurret"
     bTrackPlayersOnly=True
     bActive=True
     MaxRange=512
     fireRate=0.250000
     gunAccuracy=0.500000
     gunDamage=5
     AmmoAmount=1000
     confusionDuration=10.000000
     pitchLimit=11000.000000
     bVisionImportant=True
     HitPoints=50
     minDamageThreshold=50
     bHighlight=False
     ItemName="Turret Base"
     bPushable=False
     Physics=PHYS_None
     AmbientSound=Sound'DeusExSounds.Generic.AutoTurretHum'
     mesh=mesh'DeusExDeco.AutoTurretBase'
     SoundRadius=48
     SoundVolume=192
     bUseCylinderCollision=true
     CollisionRadius=14.000000
     CollisionHeight=20.200001
     Mass=50.000000
     Buoyancy=10.000000
     bShouldBeAlwaysUpdated=true
}
