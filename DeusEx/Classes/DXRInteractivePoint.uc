/*

*/

class DXRInteractivePoint extends DeusExDecoration
                                  Placeable;

var(InteractivePoint) bool bIsOn;
var(InteractivePoint) localized string MsgActivated, MsgDeactivated;
var(InteractivePoint) vector SpawnEmitterLocation; // if 0,0,0 then location of this actor will be used, otherwise effect will be spawned at specified location.
var(InteractivePoint) class<DeusExEmitter> SpawnEmitterClass; // Emitter class to spawn (must be inherited from DeusExEmitter).
var(InteractivePoint) Sound ActivatedSound, DeActivatedSound, LoopSound; // On/Off sounds.
//var(InteractivePoint) Name TriggerEventOn, TriggerEventOff; // Triffer these events? (Not implemented yet).


var DeusExEmitter SpawnedEmitter; // Pointer to spawned emitter

function frob(Actor frobber, Inventory FrobWith)
{
    bIsOn = !bIsOn;

    if (bIsOn)
    {
        CreateEffect();
        PlayActivatedSound();
        if (DeusExPlayer(frobber) != None)
            DeusExPlayer(frobber).ClientMessage(MsgActivated);
    }
    else
    {
        DestroyEffect();
        PlayDeActivatedSound();
        if (DeusExPlayer(frobber) != None)
            DeusExPlayer(frobber).ClientMessage(MsgDeactivated);
    }
}

function CreateEffect()
{
    local vector Loc;
    local rotator Rot;

    if (SpawnEmitterLocation == vect(0,0,0))
        loc = Location;
    else
        loc = SpawnEmitterLocation;

    Rot = Rotation;

    SpawnedEmitter = Spawn(SpawnEmitterClass,None,'',Loc,Rot);
}

function DestroyEffect()
{
    if (SpawnedEmitter != None)
    {
        SpawnedEmitter.Kill();
        SpawnedEmitter.Destroy();
    }
}

function PlayActivatedSound()
{
    if (ActivatedSound != None)
        PlaySound(ActivatedSound);

    if (LoopSound != None)
        SpawnedEmitter.AmbientSound = LoopSound;

}

function PlayDeActivatedSound()
{
    if (DeActivatedSound != None)
        PlaySound(DeActivatedSound);

    if (SpawnedEmitter != None)
        SpawnedEmitter.AmbientSound = None;
}


defaultproperties
{
    collisionHeight=20
    collisionRadius=20
    bDirectional=true
    MsgActivated="Activated!"
    MsgDeactivated="Deactivated!"
    DrawType=DT_Sprite
    bPushable=false
    SpawnEmitterLocation=(x=0,y=0,Z=0)
    SpawnEmitterClass=class'DeusEx.EM_ArcWeld'
    bInvincible=true
    bBlockActors=false
}

