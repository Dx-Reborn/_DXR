//=============================================================================
// DeusExFragment.
//=============================================================================
class DeusExFragment extends Fragment 
                             placeable;

var() float Elasticity;
var() float Speed;          // Initial speed of projectile.
var() float MaxSpeed;       // Limit on speed of projectile (0 means no limit)

var bool bVisionImportant;
var bool bSmoking;
var Vector lastHitLoc;
var float smokeTime;
var   sound    MiscSound;

// DXR: New vars
var finalBlend TransMat;
var EM_ThinTrail smokegen;

// Создать прозрачный вариант текстуры
function material CreateTranslucentMaterial()
{
   TransMat = FinalBlend(Level.ObjectPool.AllocateObject(class'FinalBlend'));
   if (TransMat != none)
   {
      TransMat.Material = class'ObjectManager'.static.GetActorMeshTexture(self, 0);
      TransMat.FrameBufferBlending = FB_Brighten;
      TransMat.ZWrite = true;
      TransMat.ZTest = true;
      TransMat.AlphaTest = true;
      TransMat.TwoSided = false;

      return TransMat;
   }
}


// copied from Engine.Fragment
//
event HitWall(vector HitNormal, actor HitWall)
{
    local Sound sound;
    local float volume, radius;

    // if we are stuck, stop moving
    if (lastHitLoc == Location)
        Velocity = vect(0,0,0);
    else
        Velocity = Elasticity * ((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    speed = VSize(Velocity);    
    if (bFirstHit && speed < 400) 
    {
        bFirstHit = false;
        bRotatetoDesired = true;
        bFixedRotationDir = false;
        DesiredRotation.Pitch = 0;
        DesiredRotation.Yaw = FRand() * 65536;
        DesiredRotation.roll = 0;
    }
    RotationRate.Yaw = RotationRate.Yaw * 0.75;
    RotationRate.Roll = RotationRate.Roll * 0.75;
    RotationRate.Pitch = RotationRate.Pitch * 0.75;
    if (((speed < 60) && (HitNormal.Z > 0.7) ) || (speed == 0))
    {
        class'ActorManager'.static.SetPhysicsEx(self,PHYS_none, HitWall);
        if (Physics == PHYS_None)
        {
            bBounce = false;
            GoToState('Dying');
        }
    }

    volume = 0.5+FRand()*0.5;
    radius = 768;
    if (FRand()<0.5)
        sound = ImpactSound;
    else
        sound = MiscSound;
    PlaySound(sound, SLOT_None, volume,, radius, 0.85+FRand()*0.3);

    if (sound != None)
        class'EventManager'.static.AISendEvent(self, 'LoudNoise', EAITYPE_Audio, volume, radius * 0.5);     // lower AI sound radius for gameplay balancing

    lastHitLoc = Location;
}

state Dying
{
    event HitWall (vector HitNormal, actor HitWall)
    {
        // if we are stuck, stop moving
        if (lastHitLoc == Location)
            Velocity = vect(0,0,0);
        else
            Velocity = Elasticity * ((Velocity dot HitNormal) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
        speed = VSize(Velocity);    
        if (bFirstHit && speed<400) 
        {
            bFirstHit=False;
            bRotatetoDesired=True;
            bFixedRotationDir=False;
            DesiredRotation.Pitch=0;    
            DesiredRotation.Yaw=FRand() * 65536;
            DesiredRotation.roll=0;
        }
        RotationRate.Yaw = RotationRate.Yaw * 0.75;
        RotationRate.Roll = RotationRate.Roll * 0.75;
        RotationRate.Pitch = RotationRate.Pitch * 0.75;
        if ((Velocity.Z < 50) && (HitNormal.Z > 0.7))
        {
            class'ActorManager'.static.SetPhysicsEx(self,PHYS_none, HitWall);
            if (Physics == PHYS_None)
                bBounce = false;
        }

        if (FRand()<0.5)
            PlaySound(ImpactSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);
        else
            PlaySound(MiscSound, SLOT_None, 0.5+FRand()*0.5,, 512, 0.85+FRand()*0.3);

        lastHitLoc = Location;
    }

    event BeginState()
    {
        Super.BeginState();

        if (smokeGen != None)
            smokeGen.Kill();
    }
}

event Destroyed()
{
  if (smokeGen != None)
      smokeGen.Kill();

    Super.Destroyed();
}

event PostBeginPlay()
{
    Super.PostBeginPlay();

    // randomize the lifespan a bit so things don't all disappear at once
    LifeSpan += FRand()*2.0;
}

function AddSmoke()
{
    smokeGen = Spawn(class'EM_ThinTrail', Self);
    if (smokeGen != None)
        smokeGen.SetBase(Self);
}

event Tick(float deltaTime)
{
   if ((Level.NetMode != NM_Standalone) && (Role == ROLE_Authority))
        return;

   if (bSmoking && !IsInState('Dying') && (smokeGen == None))
       AddSmoke();
  
    // fade out the object smoothly 2 seconds before it dies completely
    if (LifeSpan <= 2)
    {
        if (Style != STY_Translucent)
            Style = STY_Translucent;

        ScaleGlow = LifeSpan / 2.0;
    }
}

function CalcVelocity(vector Momentum, optional float ExplosionSize)
{
    Velocity = VRand() * (ExplosionSize+FRand()*150.0+100.0 + VSize(Momentum)/80); 
}


defaultproperties
{
     LifeSpan=10.000000
}
