//=============================================================================
// SecurityCamera.
//=============================================================================
class SecurityCamera extends HackableDevices;

var() bool bSwing;
var() int swingAngle;
var() float swingPeriod;
var() int cameraFOV;
var() int cameraRange;
var float memoryTime;
var() bool bActive;
var() bool bNoAlarm;            // if True, does NOT sound alarm
var Rotator ReplicatedRotation; // for net propagation
var bool bTrackPlayer;
var bool bPlayerSeen;
var bool bEventTriggered;
var float lastSeenTimer;
var float playerCheckTimer;
var float swingTimer;
var bool bConfused;             // used when hit by EMP
var float confusionTimer;       // how long until camera resumes normal operation
var float confusionDuration;    // how long does EMP hit last?
var float triggerDelay;         // how long after seeing the player does it trigger?
var float triggerTimer;         // timer used for above
var vector playerLocation;      // last seen position of player

var localized string msgActivated;
var localized string msgDeactivated;

var int LightSkinNum; // DXR: Instead of hardcoded Skins[value]
var material RedLight, GreenLight, YellowLight, NeutralLight; // DXR: this way is more flexible, I think.

//event Destroyed()
function TakeDamage(int Damage,Pawn EventInstigator,vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
   Super.TakeDamage(Damage,EventInstigator,HitLocation,Momentum,DamageType);

   if (HitPoints <= 10)
       Spawn(class'EM_CameraExplosion',None,'',location,rotation + RotRand(true));
}

function Trigger(Actor Other, Pawn Instigator)
{
    if (bConfused)
        return;

    Super.Trigger(Other, Instigator);

    if (!bActive)
    {
        if (Instigator != None)
            Instigator.ClientMessage(msgActivated);
        bActive = True;
        LightType = LT_Steady;
        LightHue = 80;
        Skins[LightSkinNum] = GreenLight;
        AmbientSound = sound'CameraHum';
    }
}


function UnTrigger(Actor Other, Pawn Instigator)
{
    if (bConfused)
        return;

    Super.UnTrigger(Other, Instigator);

    if (bActive)
    {
        if (Instigator != None)
            Instigator.ClientMessage(msgDeactivated);
            TriggerEventX(False);
        bActive = False;
        TurnOff();
    }
}

function TurnOff()
{
    LightType = LT_None;
    AmbientSound = None;
    DesiredRotation = origRot;
    hackStrength = 0.0;
}


//simulated event TriggerEvent( Name EventName, Actor Other, Pawn EventInstigator )
// �������� � �����-�� �������� � UT2004, �������� �������������
function TriggerEventX(bool bTrigger)
{
    bEventTriggered = bTrigger;
    bTrackPlayer = bTrigger;
    triggerTimer = 0;

    // now, the camera sounds its own alarm
    if (bTrigger)
    {
        AmbientSound = Sound'Klaxon2';
        SoundVolume = 128;
        SoundRadius = 64;
        LightHue = 0;
        Skins[LightSkinNum] = RedLight;
        AIStartEvent('Alarm', EAITYPE_Audio, SoundVolume/255.0, 25*(SoundRadius+1));

        // make sure we can't go into stasis while we're alarming
        bStasis = False;
    }
    else
    {
        AmbientSound = Sound'CameraHum';
        SoundRadius = 48;
        SoundVolume = 192;
        LightHue = 80;
        Skins[LightSkinNum] = GreenLight;
        AIEndEvent('Alarm', EAITYPE_Audio);

        // reset our stasis info
        bStasis = default.bStasis;
    }
}

event Tick(float deltaTime)
{
    local float ang;
    local Rotator rot;

    Super.Tick(deltaTime);

    // if this camera is not active, get out
    if (!bActive)
    {
        Skins[LightSkinNum] = NeutralLight;  //Texture'BlackMaskTex'; 
        //Fuck you, light type -DDL
        LightType = LT_None;
        return;
    }

    // if we've been EMP'ed, act confused
    if (bConfused)
    {
        confusionTimer += deltaTime;

        // pick a random facing at random
        if (confusionTimer % 0.25 > 0.2)
        {
            DesiredRotation.Pitch = origRot.Pitch + 0.5*swingAngle - Rand(swingAngle);
            DesiredRotation.Yaw = origRot.Yaw + 0.5*swingAngle - Rand(swingAngle);
        }

        if (confusionTimer > confusionDuration)
        {
            bConfused = False;
            confusionTimer = 0;
            confusionDuration = default.confusionDuration;
            LightHue = 80;
            Skins[LightSkinNum] = GreenLight;
            SoundPitch = 64;
            DesiredRotation = origRot;
        }

        return;
    }

    // check the player's visibility every 0.1 seconds
    if (!bNoAlarm)
    {
        playerCheckTimer += deltaTime;

        if (playerCheckTimer > 0.1)
        {
            playerCheckTimer = 0;
            CheckPlayerVisibility(GetPlayerPawn2());
        }
    }

    // forget about the player after a set amount of time
    if (bPlayerSeen)
    {
        // if the player has been seen, but the camera hasn't triggered yet,
        // provide some feedback to the player (light and sound)
        if (!bEventTriggered)
        {
            triggerTimer += deltaTime;

            if (triggerTimer % 0.5 > 0.4)
            {
                LightHue = 0;
                Skins[LightSkinNum] = RedLight;
                PlaySound(Sound'Beep6',,,, 1280);
            }
            else
            {
                LightHue = 80;
                Skins[LightSkinNum] = GreenLight;
            }
        }

        if (lastSeenTimer < memoryTime)
            lastSeenTimer += deltaTime;
        else
        {
            lastSeenTimer = 0;
            bPlayerSeen = False;

            // untrigger the event
            TriggerEventX(False);
        }

        return;
    }

    swingTimer += deltaTime;
    Skins[LightSkinNum] = GreenLight;

    // swing back and forth if all is well
    if (bSwing && !bTrackPlayer)
    {
        ang = 2 * Pi * swingTimer / swingPeriod;
        rot = origRot;
        rot.Yaw += Sin(ang) * swingAngle;
        DesiredRotation = rot;
    }

}

event BeginPlay()
{
    Super.BeginPlay();

    origRot = Rotation;
    DesiredRotation = origRot;

    playerLocation = Location;

    if (!bActive) //some start off
        TurnOff();
}

function CheckPlayerVisibility(DeusExPlayer player)
{
    local float yaw, pitch, dist;
    local Actor hit;
    local Vector HitLocation, HitNormal;
    local Rotator rot;

   if (player == None)
      return;
    dist = Abs(VSize(player.Location - Location));

    // if the player is in range
    if (player.bDetectable && !player.bIgnore && (dist <= cameraRange))
    {
        hit = Trace(HitLocation, HitNormal, player.Location, Location, True);
        if (hit == player)
        {
            // If the player's RadarTrans aug is on, the camera can't see him
            if (player.AugmentationSystem.GetAugLevelValue(class'AugRadarTrans') != -1.0)
                return;

            // figure out if we can see the player
            rot = Rotator(player.Location - Location);
            rot.Roll = 0;
            yaw = (Abs(Rotation.Yaw - rot.Yaw)) % 65536;
            pitch = (Abs(Rotation.Pitch - rot.Pitch)) % 65536;

            // center the angles around zero
            if (yaw > 32767)
                yaw -= 65536;
            if (pitch > 32767)
                pitch -= 65536;

            // if we are in the camera's FOV
            if ((Abs(yaw) < cameraFOV) && (Abs(pitch) < cameraFOV))
            {
                // rotate to face the player
                if (bTrackPlayer)
                    DesiredRotation = rot;

                lastSeenTimer = 0;
                bPlayerSeen = True;
                bTrackPlayer = True;
                //bFoundCurPlayer = True;

                playerLocation = player.Location - vect(0,0,1)*(player.CollisionHeight-5);

                // trigger the event if we haven't yet for this sighting
                if (!bEventTriggered && (triggerTimer >= triggerDelay) && (Level.Netmode == NM_Standalone))
                    TriggerEventX(True);

                return;
            }
        }
    }
}


function DeusExPlayer GetPlayerPawn2()
{
    return DeusExPlayer(Level.GetLocalPlayerController().Pawn);
}



defaultproperties
{
     RedLight=Shader'DeusExStaticMeshes0.CameraLights.SC_Red_SH'
     GreenLight=Shader'DeusExStaticMeshes0.CameraLights.SC_Green_SH'
     YellowLight=Shader'DeusExStaticMeshes0.CameraLights.SC_Yellow_SH'
     NeutralLight=ConstantColor'DeusExStaticMeshes0.Plastic.KP_Gray'

     swingAngle=8192
     swingPeriod=8.000000
     cameraFOV=4096
     cameraRange=1024
     memoryTime=5.000000
     bActive=True
     confusionDuration=10.000000
     triggerDelay=4.000000
     msgActivated="Camera activated"
     msgDeactivated="Camera deactivated"
     bVisionImportant=True
     HitPoints=50
     minDamageThreshold=50
     bInvincible=False
     FragType=Class'DeusEx.MetalFragment'
     ItemName="Surveillance Camera"
     Physics=PHYS_Rotating
     AmbientSound=Sound'DeusExSounds.Generic.CameraHum'
//     mesh=mesh'DeusExDeco.SecurityCamera'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'DeusExStaticMeshes0.SecurityCamera_HD'
     SoundRadius=48
     SoundVolume=192
     CollisionRadius=10.720000
     CollisionHeight=11.000000
//     LightType=LT_Steady
     LightType=LT_None
     LightBrightness=120
     LightHue=80
     LightSaturation=100
     LightRadius=0//1
     bRotateToDesired=True
     Mass=20.000000
     Buoyancy=5.000000
     RotationRate=(Pitch=65535,Yaw=65535)
//     Skins[0]=Texture'DeusExDeco.Skins.SecurityCameraTex1'
//     Skins[1]=Texture'DeusExDeco.Skins.SecurityCameraTex1'
//     Skins[2]=Texture'DeusExDeco.Skins.PinkMaskTex'
//     Skins[3]=TexEnvMap'Effects_EX.Unlit.Camera_Shine'
     LightSkinNum=1
     Skins[0]=Shader'DeusExStaticMeshes0.Metal.SecurityCamera_HD_SH'
     Skins[1]=Shader'DeusExStaticMeshes0.Plastic.KP_Green_SH'

     //bDynamicLight=true
     bDynamicLight=false
     bShouldBeAlwaysUpdated=true
}


