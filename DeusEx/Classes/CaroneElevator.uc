//==================================================================================
// CaroneElevator. Version 1.5 (or something like that) ;)
// Base: ElevatorMover. Modified by Carone (Well, there's actually
// only a small percentage of original code in here
// Please don't forget to give me credit for this and please notify me if you use it
// for a mod/map/level that's to be released
//==================================================================================

// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// CHANGED (Jan.2002)
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// You don't have to use the CEDoor Mover-class anymore.
// Just make sure that the 'InitialState' of your mover is set to 'TriggerToggle'

// Also IMPORTANT:
// You HAVE TO use the new CESequenceTrigger(located under Triggers/Trigger) to
// trigger the CaroneElevator
// Read below for advanced features or read the Readme-file that should be included.

// If you have bCEControlsDoors disabled and a keyframe request has been made while the
// CaroneElevator was still moving the Elevator finishes the current movement, sends out
// the CEEvents-Event for the particular Keyframe and pauses for CEDoorOpenTime seconds,
// then finishes the keyframe request.

// Update: May. 2, 2001
// SlaveMover:
// With the help of Steve Tack, I managed to fix the Attach-feature of the mover-class.
// It's now possible to attach movers to the Elevator which open and close correctly
// and can also be controlled by the CaroneElevator. Although any mover-class can be
// attached to the CaroneElevator(for now) I advise you to use the CEDoor class to be able
// to take advantage of future changes without having to redo anything.

// Update: March 28, 2002
// I improved the code and added some stuff I needed for my Hotel FM( http://www.carone1.de/HotelCarone/ )
// - Two sets of inner doors supported(to make an elevator accessible from two sides 
//   or whatever else you can come up with) =)
// - Elevator is breakable
// - Luckily with the new code a weird bug disappeared which caused the elevator to freeze
//   under certain circumstances
// Read the readme for details or go to the irc channel #dxediting on irc.starchat.net
// Well, have fun with the CaroneElevator!!! If you have questions or suggestions:
// Email: dxediting@carone-online.de
// Homepage: www.carone-online.de
//==================================================================================




class CaroneElevator extends Mover;

var() bool bFollowKeyframes;


// RealisticEFactor influences the time that is subtracted from total MoveTime to create
// a more realistic Movetime.
// It makes the Movetime shorter for greater distances.
// See function SetSeq to see how it affects the movetime exactly. 
// Small RealisticEFactor=Longer MoveTime
// Making it bigger than 0.5 is senseless because MoveTime will be set to 0
// (Actually 1/NumKeys should be the max unless you are going for something special)

var (CElevatorAdvanced) float       RealisticEFactor;
var (CElevatorAdvanced) float       CEDoorOpenTime;
var (CElevatorAdvanced) bool        bCEControlsDoors;
var (CElevatorAdvanced) bool        bRealisticMovetime;
var (CElevatorAdvanced) bool        bCEControlsSlave;
var (CElevatorAdvanced) name        CESlaveMover;
var (CElevatorAdvanced) name        CESlaveMover2;
var (CElevatorAdvanced) name        CEButtonEvent;

enum CESlaveSides
{
    CESlaveSide1,
    CESlaveSide2
};
// TODO: Добавить поддержку всех 24 кейфреймов (если конечно это найдет практическое применение)
var() float                 CEMoveTimes[7]; // Movetime between neighboring Keyframes (CEMoveTimes[0]=Movetime between Keyframes 0 and 1)
var() name              CEEvents[8]; // Event to be triggered when CaroneElevator has moved to(or is at!!!) Keyframe(SeqNum)
var() CESlaveSides          CESlaveSide[8]; // Which Slave to control at the specific keyframe
var() name              CEStartEvents[8]; // Send an event when CaroneElevator starts moving from specific keyframe
var() name              CEStartEvent;  // Sends an event whenever CaroneElevator starts moving 
                    // Note: I didn't let it send the event when movement is finished because there already
                    // is an option for that (Event-variable)

// Internal

var int                 CEMoveKeys; // Number of keys from current to triggered keyframe
var float               CEMoveTime; 
var int                 i;
var int                 oldkey;
var int                 firstkey;
var float               CESleepTime;

var int                 CERequest;    // If Elevator is moving while triggered for other keyframe, Elevator remembers
var bool                bCERequested;    // the keynum and procedes to that keynum after finishing all the movements
 
var bool                bCEDoorsOpening; // What state are CEDoors in?
var bool                bCEDoorsClosed;  //
var bool                bCEDoorsOpen;    //
var bool                bCEDoorsClosing; //
var bool                bCheckingDoors; // Damn, have to add and add and add, just to make it 'unscrewable'
var bool                bCESlaveClosed; // Check the slave as well
var bool                bCESlaveMoving; // Make sure the Slave is NOT MOVING when the Elevator is. It would be "FATAL"!!!
var bool                bCESlaveOpen;
var bool                bIsMoving;


// bBreakable
var() bool              bBreakable;
var() int               minDamageThreshold;
var() int               NumFragments;           // number of fragments to spew on destroy
var() float             FragmentScale;          // scale of fragments
var() int               FragmentSpread;         // distance fragments will be thrown
var() class<DeusExFragment>         FragmentClass;          // which fragment
var() texture               FragmentTexture;        // what texture to use on fragments
var() bool              bFragmentTranslucent;       // are these fragments translucent?
var() bool              bFragmentUnlit;         // are these fragments unlit?
var() sound             ExplodeSound1;          // small explosion sound
var() sound             ExplodeSound2;          // large explosion sound
var() bool              bDrawExplosion;         // should we draw an explosion?
var() float                 MoverStrength;          // (0.0 - 5.0)
var() name              DestroyedEvent;         // triggers that event when elevator has been destroyed

var bool                bDestroyed;

var Actor                 Target;        // Actor we're aiming at (other uses as well).

event BeginPlay()
{
    Super.BeginPlay();
    bIsMoving = False;
}

// Lots of stuff copied from DeusExMover(but changed a bit) :)

function DropThings()
{
    local actor A;

    // drop everything that is on us
    foreach BasedActors(class'Actor', A)
        A.SetPhysics(PHYS_Falling);
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    if (bDestroyed)
        return;
    if (bIsMoving)
        return;

    if ((damageType == class'DM_TearGas') || (damageType == class'DM_PoisonGas') || (damageType == class'DM_HalonGas'))
        return;

    if ((damageType == class'DM_Stunned') || (damageType == class'DM_Radiation'))
        return;

    if ((DamageType == class'DM_EMP') || (DamageType == class'DM_NanoVirus') || (DamageType == class'DM_Shocked'))
        return;

    if (bBreakable)
    {
        // add up the damage
        if (Damage >= minDamageThreshold)
            MoverStrength -= Damage * 0.01;

        MoverStrength = FClamp(MoverStrength, 0.0, 5.0);
        if (MoverStrength ~= 0.0)
            BlowItUp(instigatedBy);
    }
}

//
// "Destroy" the mover (copied from deusexmover, I think) (carone)
//
function BlowItUp(Pawn instigatedBy)
{
    local int k;
    local DeusExFragment frag;
    local Actor A;
    local DeusExDecal D;
    local Vector spawnLoc;
    local ExplosionLight light;

    // force the mover to stop
    if (Leader != None)
        Leader.MakeGroupStop();

    Instigator = instigatedBy;

    // trigger our event
    if (DestroyedEvent != '')
        foreach AllActors(class'Actor', A, DestroyedEvent)
            if (A != None)
                A.Trigger(Self, instigatedBy);

    // destroy all effects that are on us
    foreach BasedActors(class'DeusExDecal', D)
        D.Destroy();

    DropThings();

    // get the origin of the mover
    spawnLoc = Location - (PrePivot >> Rotation);

    // spawn some fragments and make a sound
    for (k=0; k<NumFragments; k++)
    {
        frag = Spawn(FragmentClass,,, spawnLoc + FragmentSpread * VRand());
        if (frag != None)
        {
            frag.Instigator = instigatedBy;

            // make the last fragment just drop down so we have something to attach the sound to
            if (k == NumFragments - 1)
                frag.Velocity = vect(0,0,0);
            else
                frag.CalcVelocity(VRand(), FragmentSpread);

            frag.SetDrawScale(FragmentScale);
            if (FragmentTexture != None)
                frag.Skins[0] = FragmentTexture;
            if (bFragmentTranslucent)
                frag.Style = STY_Translucent;
            if (bFragmentUnlit)
                frag.bUnlit = True;
        }
    }

    // should we draw explosion effects?
    if (bDrawExplosion)
    {
        light = Spawn(class'ExplosionLight',,, spawnLoc);
        if (FragmentSpread < 64)
        {
            Spawn(class'ExplosionSmall',,, spawnLoc);
            if (light != None)
                light.size = 2;
        }
        else if (FragmentSpread < 128)
        {
            Spawn(class'ExplosionMedium',,, spawnLoc);
            if (light != None)
                light.size = 4;
        }
        else
        {
            Spawn(class'ExplosionLarge',,, spawnLoc);
            if (light != None)
                light.size = 8;
        }
    }

    // alert NPCs that I'm breaking
    class'EventManager'.static.AISendEvent(self,'LoudNoise', EAITYPE_Audio, 2.0, FragmentSpread * 16);

    MakeNoise(2.0);
    if (frag != None)
    {
        if (NumFragments <= 5)
            frag.PlaySound(ExplodeSound1, SLOT_None, 2.0,, FragmentSpread*256);
        else
            frag.PlaySound(ExplodeSound2, SLOT_None, 2.0,, FragmentSpread*256);
    }

    SetLocation(Location+vect(0,0,20000));      // move it out of the way
    SetCollision(False, False, False);          // and make it non-colliding
    bDestroyed = True;
}


function CEMovingTrigger()
{
    if ( CEStartEvent != '' )
    {
    foreach AllActors ( class 'Actor', Target, CEStartEvent )
                    Target.Trigger( Self, Instigator );
    }
}

function CEStartTrigger()
{
    if ( CEStartEvents[oldkey] != '' )
    {
    foreach AllActors ( class 'Actor', Target, CEStartEvents[oldkey] )
                    Target.Trigger( Self, Instigator );
    }
}


function CETrigger()
{
    if ( CEEvents[oldkey] != '' )
    {
        foreach AllActors( class 'Actor', Target, CEEvents[oldkey] )
                Target.Trigger( Self, Instigator );
    }
}

function CESlaveTrigger()
{
local Mover M;
local name HCESlave;
    
    HCESlave='';
    
// log('CESlaveTrigger');
    
    if (CESlaveMover2 != '')
    {
        switch (CESlaveSide[oldkey])
        {
            case CESlaveSide1:  HCESlave=CESlaveMover;
                                break;
    
            case CESlaveSide2:  HCESlave=CESlaveMover2;
                                break;
        }
    }
    else if (CESlaveMover != '')
        HCESlave=CESlaveMover;
    
    if ( HCESlave != '' )
        foreach AllActors( class'Mover', M, HCESlave )
                M.Trigger( Self, Instigator );

}

function SetSeq(int seqnum)
{
//log("function SetSeq "$seqnum);

    if (bDestroyed)
        return;


    if (bIsMoving)
    {
        if (seqnum!=KeyNum)
        {
            bCERequested=true;
            CERequest=seqnum;
        }
        return;
    }


    if (KeyNum != seqnum) 
    {
        bCERequested=false;
        if (!bCheckingDoors)
                FirstKey=KeyNum;
        else KeyNum=FirstKey;

        CEMoveTime=0;
        oldkey=KeyNum;
        if (KeyNum>seqnum) 
        {
            for (i=seqnum;i<KeyNum;i++)
                CEMoveTime=CEMoveTime+CEMoveTimes[i];
                CEMoveKeys=KeyNum-seqnum;
        }

        if (KeyNum<seqnum)
        {
            for (i=KeyNum;i<seqnum;i++)
                CEMoveTime=CEMoveTime+CEMoveTimes[i];
                CEMoveKeys=seqnum-KeyNum;
        }

        if (bRealisticMovetime)
        {
            CEMoveTime=CEMoveTime*(1-RealisticEFactor*CEMovekeys);
            if (CEMoveTime<0) CEMoveTime=0;
        }       

        KeyNum = seqnum;
//      log("seqnum "$seqnum$ "GotoState('CaroneElevator', 'CheckDoors'); keynum=" $keynum);
        GotoState('CaroneElevatorEx', 'CheckDoors');
    }
    else if (KeyNum == seqnum)
    {
//      log(keynum$" keynum     GotoState('CaroneElevator', 'OpenCloseDoors');");
        GotoState('CaroneElevatorEx', 'OpenCloseDoors');
    }
}


function CEGetMoverInfo() // To check what the hell CEDoor is doing right now :) (and get CESleeptime=CEDoor.MoveTime)
    {
    local Mover CED;
        CESleeptime=0;
        foreach AllActors( class 'Mover', CED, CEEvents[oldkey] )
        {
            if ((CED.KeyNum==0) && (!CED.bOpening) && (!CED.bInterpolating)) 
            {
                bCEDoorsClosed=True;
                bCEDoorsClosing=False;
                bCEDoorsOpen=False;
                bCEDoorsOpening=False;
            }
            
            
            else if ((CED.KeyNum!=0) && (!CED.bInterpolating))
            {
                bCEDoorsClosed=False;
                bCEDoorsClosing=False;
                bCEDoorsOpen=True;
                bCEDoorsOpening=False;
            }

            else  if ((CED.KeyNum !=0) && (CED.bInterpolating) && (CED.bOpening))
            {
                bCEDoorsClosed=False;
                bCEDoorsClosing=False;
                bCEDoorsOpen=False;
                bCEDoorsOpening=True;
            }
            else 
            {
                bCEDoorsClosed=False;
                bCEDoorsClosing=True;
                bCEDoorsOpen=False;
                bCEDoorsOpening=False;
            }
            CESleeptime=CED.MoveTime*(CED.NumKeys-1);
        }
    }


function CECheckSlave()
{
    local Mover M;
    local name HCESlave;
    
    CESleeptime=0;
        
    HCESlave='';
    
    if (CESlaveMover2 != '')
        switch (CESlaveSide[oldkey])
        {
            case CESlaveSide1:  HCESlave=CESlaveMover;
                        break;
    
            case CESlaveSide2:  HCESlave=CESLaveMover2;
                        break;
        }
    else if (CESlaveMover != '')
        HCESlave=CESlaveMover;
    
    if (HCESlave != '')
        foreach AllActors( class 'Mover', M, HCESlave )
            {
                if ((M.KeyNum==0) && (!M.bOpening) && (!M.bInterpolating)) 
                    {
                    bCESlaveClosed=True;
                    bCESlaveMoving=False;
                    bCESlaveOpen=False;
                    }
                else if ((M.KeyNum!=0) && (!M.bInterpolating))
                    {
                    bCESlaveClosed=False;
                    bCESlaveMoving=False;
                    bCESlaveOpen=True;
                    break;
                    }
                else 
                    {
                    bCESlaveClosed=False;
                    bCESlaveMoving=True;
                    bCESlaveOpen=False;
                    break;
                    }
                CESleeptime=M.MoveTime;
            }
}


/*function CEAttachFix()   // Fixes the Attach-bug
{
local Mover M;

    foreach AllActors( class 'Mover', M )
        if (M.Attachtag==Tag)
        {
            M.BasePos = M.Location-M.KeyPos[M.KeyNum];
      M.BaseRot = M.Rotation-M.KeyRot[M.KeyNum];
        }
}*/

function CEDisableSlaves()
{
local Mover M;
local CESequenceTrigger WWCEST;
    
        if (Attachtag != '')
            foreach AllActors( class 'Mover', M, Attachtag )
            {
                if (!M.IsA('CaroneElevator'))
                    M.Disable( 'Trigger' );
                else
                foreach AllActors(class'CESequenceTrigger', WWCEST)
                    if (WWCEST!=none)
                        if (WWCEST.Event==M.Tag)
                            WWCEST.CESDisabled=true;
            }
// and disable the master!!!!!!
            
        foreach AllActors( class 'Mover', M)
        if (M!=none && M.Attachtag==Tag)
        {
            if (!M.IsA('CaroneElevator'))
                M.Disable( 'Trigger' );
            else
            foreach AllActors(class'CESequenceTrigger', WWCEST)
                if (WWCEST!=none && WWCEST.Event==M.Tag)
                    WWCEST.CESDisabled=true;
        }
            
            
            
}

function CEEnableSlaves()
{
local Mover M;
local CESequenceTrigger WWCEST;

        if (Attachtag != '')
            foreach AllActors( class 'Mover', M, Attachtag )
            {
                if (!M.IsA('CaroneElevator'))
                    M.Enable( 'Trigger' );
                else
                foreach AllActors(class'CESequenceTrigger', WWCEST)
                    if (WWCEST!=none && WWCEST.Event==M.Tag)
                        WWCEST.CESDisabled=false;
            }
// and enable the master!!!!!!
        foreach AllActors( class 'Mover', M)
        if (M!=none && M.Attachtag==Tag)
        {
            if (!M.IsA('CaroneElevator'))
                M.Enable( 'Trigger' );
            else
            foreach AllActors(class'CESequenceTrigger', WWCEST)
                if (WWCEST!=none)
                    if (WWCEST.Event==M.Tag)
                        WWCEST.CESDisabled=false;
        }
}


auto state() CaroneElevatorEx
{
    event KeyFrameReached()
    {
//      log("state() CaroneElevator");
        if (bFollowKeyframes)
            Super.KeyFrameReached();
    }

CheckDoors:

    if (bCEControlsDoors)
        {
        bCheckingDoors=True;
        CEGetMoverInfo();

            if ((bCEDoorsOpening) || (bCEDoorsClosing))
            {
                if (bCEControlsSlave)
                {
                    CECheckSlave();
                    if (bCESlaveOpen)
                        CESlaveTrigger();
                }
                sleep(0.5);
                GotoState ( 'CaroneElevatorEx' , 'CheckDoors' );
            }
            else if (bCEDoorsOpen)
            {
                CETrigger();
                sleep(0.5);
                GotoState ( 'CaroneElevatorEx' , 'CheckDoors');
            }
        }
Next:
    if (bCEControlsDoors)
    {
        CEGetMoverInfo();
        if (!bCEDoorsClosed)
            GotoState('CaroneElevatorEx' , 'CheckDoors');
        else bCheckingDoors=False;
    }

//  Disable ( 'SetSeq');
    CECheckSlave(); 
    if (bCESlaveMoving)
        {
        sleep(0.5);
        GotoState('CaroneElevatorEx' , 'Next');
        }

    If (bCEControlsSlave)
        {
        CECheckSlave();
        if (bCESlaveOpen)
            {
//          Enable ('SetSeq');
            CESlaveTrigger();
            Sleep(CESleepTime);
            GotoState('CaroneElevatorEx' , 'Next');
            }
        }
            
//  Enable ( 'SetSeq' );
    CEDisableSlaves();
    bIsMoving = True;
    CEMovingTrigger();
    CEStartTrigger();
    PlaySound(OpeningSound);
    AmbientSound = MoveAmbientSound;

    InterpolateTo(KeyNum, CEMoveTime);

    FinishInterpolation();
    AmbientSound = None;
//  CEAttachfix();
    CEEnableSlaves();
    FinishedOpening();
    bIsMoving = False;
    CEEnableSlaves();
    oldkey=KeyNum;

// This stops any further action(after sending the "Finished-Moving"-event) 
// if DoorControl by CaroneElevator (bCEControlsDoors=False) is not wanted
// and if there hasn't been a new request
    
    if (!bCEControlsDoors)  
    {
        CETrigger();
        if (bCERequested)
        {
            sleep(CEDoorOpenTime);
            SetSeq(CERequest);
        }
        Stop;
    }


OpenCloseDoors:
    if (!bCEControlsDoors)
    {
        CETrigger();
        If (bCEControlsSlave)
            CESlaveTrigger();

        if (bCERequested)
        {
            sleep(CEDoorOpenTime);
            SetSeq(CERequest);
        }
        Stop;
    }

    CEGetMoverInfo();
    if (!bCEDoorsClosed)
        if ((bCEDoorsOpening) || (bCEDoorsClosing))
        {
            sleep(0.5);
            GotoState ('CaroneElevatorEx','OpenCloseDoors');
        }
    
    if (bCEDoorsClosed)
    {
        CETrigger();
        If (bCEControlsSlave)
        {
            CECheckSlave();

            If (bCESlaveClosed)
                CESlaveTrigger();
        }
        
        Sleep(CESleepTime);
        Sleep(CEDoorOpenTime);
    }
CloseDoors:

    CEGetMoverInfo();
    if (bCEDoorsOpen)
        CETrigger();

    If (bCEControlsSlave)
    {
        CECheckSlave();
        If (bCESlaveOpen)
            CESlaveTrigger();
    }
    if (bCERequested)
        SetSeq(CERequest);

    Stop;
}

     
defaultproperties
{
    RealisticEFactor=0.07
    CEDoorOpenTime=5.00
    CEMoveTimes(0)=3.00
    CEMoveTimes(1)=3.00
    CEMoveTimes(2)=3.00
    CEMoveTimes(3)=3.00
    CEMoveTimes(4)=3.00
    CEMoveTimes(5)=3.00
    CEMoveTimes(6)=3.00
    minDamageThreshold=10
    NumFragments=32
    FragmentScale=1.00
    FragmentSpread=32
    FragmentClass=Class'DeusEx.MetalFragment'
    ExplodeSound1=Sound'DeusExSounds.Generic.WoodBreakSmall'
    ExplodeSound2=Sound'DeusExSounds.Generic.WoodBreakLarge'
    MoverStrength=1.00
    MoverEncroachType=2
    InitialState=CaroneElevator
    bUseDynamicLights=true
}
